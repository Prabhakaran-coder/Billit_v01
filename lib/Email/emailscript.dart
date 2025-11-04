import 'dart:convert';
import 'dart:io';
import 'package:billit/database/product_database_helper.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as p;


Future<void> sendInvoiceEmailWithAttachment({
  required String pdfPath,
  required String toEmail,
  required String invoiceNo,
  required String totalAmount,
  required String customerName,
}) async {
  final connectivity = await Connectivity().checkConnectivity();
  final dbHelper = ProductDatabaseHelper.instance;

  // Prepare data
  final file = File(pdfPath);
  final fileBytes = await file.readAsBytes();
  final base64Pdf = base64Encode(fileBytes);

  final url = Uri.parse(
    'https://script.google.com/macros/s/AKfycbxLzPeYgzFW09UQe4fNyZx9N4xWFZUJ-96TGF-S4EjhyhmDZ9akuYMeCWKnyL1OIU89PQ/exec',
  );

  final emailPayload = jsonEncode({
    'toEmail': toEmail,
    'fileName': p.basename(pdfPath),
    'pdfBase64': base64Pdf,
    'invoiceNumber': invoiceNo,
    'totalAmount': totalAmount,
    'customerName': customerName,
  });

  // Check network status
  if (connectivity == ConnectivityResult.none) {
    // Offline: store the email for later
    await dbHelper.insertQueuedEmail(
      toEmail,
      pdfPath,
      p.basename(pdfPath),
      invoiceNo,
      totalAmount,
      customerName,
    );
    print('Queued invoice email for $toEmail (Offline)');
    return;
  }

  // Online: try sending now
  try {
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: emailPayload,
    );

    if (response.statusCode == 200 &&
        response.body.toLowerCase().contains('success')) {
      print(' Invoice email sent successfully to $toEmail');
    } else {
      print('Email send failed, queuing for later...');
      await dbHelper.insertQueuedEmail(
        toEmail,
        pdfPath,
        p.basename(pdfPath),
        invoiceNo,
        totalAmount,
        customerName,
      );
    }
  } catch (e) {
    print(' Email send exception, queued instead: $e');
    await dbHelper.insertQueuedEmail(
      toEmail,
      pdfPath,
      p.basename(pdfPath),
      invoiceNo,
      totalAmount,
      customerName,
    );
  }
}
void startEmailSyncService(ProductDatabaseHelper dbHelper) {
  Connectivity().onConnectivityChanged.listen((result) async {
    if (result != ConnectivityResult.none) {
      print('Internet restored — syncing queued emails...');
      final unsentEmails = await dbHelper.getUnsentEmails();

      for (final email in unsentEmails) {
        try {
          final file = File(email['file_path']);
          final fileBytes = await file.readAsBytes();
          final base64Pdf = base64Encode(fileBytes);

          final url = Uri.parse(
            'https://script.google.com/macros/s/AKfycbxLzPeYgzFW09UQe4fNyZx9N4xWFZUJ-96TGF-S4EjhyhmDZ9akuYMeCWKnyL1OIU89PQ/exec',
          );

          final response = await http.post(
            url,
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'toEmail': email['to_email'],
              'fileName': email['file_name'],
              'pdfBase64': base64Pdf,
              'invoiceNumber': email['invoice_no'],
              'totalAmount': email['total_amount'],
              'customerName': email['customer_name'],
            }),
          );

          if (response.statusCode == 200 &&
              response.body.toLowerCase().contains('success')) {
            await dbHelper.markEmailAsSent(email['id']);
            print('Resent queued email to ${email['to_email']}');
          } else {
            print('Failed to resend email ${email['file_name']}');
          }
        } catch (e) {
          print('Error resending queued email: $e');
        }
      }
    }
  });
}
