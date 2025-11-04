import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:billit/database/product_database_helper.dart';

class EmailQueueTable extends StatefulWidget {
  const   EmailQueueTable({Key? key}) : super(key: key);

  @override
  State<EmailQueueTable> createState() => _EmailQueueTableState();
}

class _EmailQueueTableState extends State<EmailQueueTable> {
  final ProductDatabaseHelper _databaseHelper = ProductDatabaseHelper.instance;
  late Future<List<Map<String, dynamic>>> _emailsFuture;

  @override
  void initState() {
    super.initState();
    _refreshEmails();
  }

  void _refreshEmails() {
    setState(() {
      _emailsFuture = _databaseHelper.getAllEmails();
    });
  }

  Future<void> resendEmail(Map<String, dynamic> email) async {
    try {
      final pdfPath = email['file_path']; // store full path in db
      final file = File(pdfPath);
      if (!await file.exists()) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('File not found: $pdfPath')),
        );
        return;
      }

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

      if (response.body.contains("✅ Email sent")) {
        // ✅ Update DB to mark as sent
        await _databaseHelper.updateEmailStatus(email['id'], true);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Email sent to ${email['to_email']}')),
        );
        _refreshEmails();
      } else {
        throw Exception(response.body);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to resend: $e')),
      );
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _emailsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(
            child: Text(
              'No queued emails found.',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          );
        }

        // Sort by newest first (descending id)
        final emails = snapshot.data!..sort((a, b) => b['id'].compareTo(a['id']));

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔄 Refresh Button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  '📧 Email Queue',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: const Icon(Icons.refresh, color: Colors.blue),
                  onPressed: _refreshEmails,
                  tooltip: 'Refresh queue',
                ),
              ],
            ),
            const SizedBox(height: 8),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Card(
                  margin: const EdgeInsets.all(8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 3,
                  child: DataTable(
                    headingRowColor:
                        WidgetStateProperty.all(Colors.blueGrey.shade50),
                    border: TableBorder.all(color: Colors.grey.shade300),
                    columns: const [
                      DataColumn(label: Text('To Email')),
                      DataColumn(label: Text('Invoice No')),
                      DataColumn(label: Text('Customer')),
                      DataColumn(label: Text('Amount')),
                      DataColumn(label: Text('File Name')),
                      DataColumn(label: Text('Status')),
                      DataColumn(label: Text('Actions')),
                    ],
                    rows: emails.map((e) {
                      final isSent = e['sent'] == 1;
                      return DataRow(cells: [
                        DataCell(Text(e['to_email'] ?? '-')),
                        DataCell(Text(e['invoice_no'] ?? '-')),
                        DataCell(Text(e['customer_name'] ?? '-')),
                        DataCell(Text(e['total_amount'] ?? '-')),
                        DataCell(Text(e['file_name'] ?? '-')),
                        DataCell(Row(
                          children: [
                            Icon(
                              isSent ? Icons.check_circle : Icons.schedule,
                              color: isSent ? Colors.green : Colors.orange,
                              size: 18,
                            ),
                            const SizedBox(width: 6),
                            Text(isSent ? 'Sent' : 'Pending'),
                          ],
                        )),
                        DataCell(
                          isSent
                              ? const Text('-')
                              : IconButton(
                                  icon: const Icon(Icons.send, color: Colors.blue),
                                  tooltip: 'Resend Email',
                                  onPressed: () => resendEmail(e),
                                ),
                        ),
                      ]);
                    }).toList(),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
