import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = "http://192.168.0.106:5000"; // for Android emulator
  // Use "http://localhost:5000" if you’re running on Flutter desktop

  static Future<bool> createPayment({
    required String invoiceId,
    required String refId,
    required double amount,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/payment/create'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'invoiceId': invoiceId,
        'refId': refId,
        'amount': amount,
      }),
    );
    return response.statusCode == 200;
  }

  static Future<Map<String, dynamic>?> verifyPayment(String refId) async {
    final response = await http.get(Uri.parse('$baseUrl/api/payment/verify/$refId'));

    if (response.statusCode == 200) {
      return jsonDecode(response.body)['payment'];
    }
    return null;
  }

  
}

