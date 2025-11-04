String generateUpiUrl({
  required String upiId,
  required String upiName,
  required String invoiceId,
 // required String refId,
  required double amount,
}) {
  final cleanedUpiId = upiId.trim().toLowerCase();

  final formattedAmount = amount.toStringAsFixed(2);
  final encodedName = Uri.encodeComponent(upiName);
  final encodedNote = Uri.encodeComponent('Invoice $invoiceId');

  final url =
      'upi://pay?pa=$cleanedUpiId&pn=$encodedName&am=$formattedAmount&cu=INR&tn=$encodedNote';

  print('✅ Generated UPI URL → $url');
  return url;
}
