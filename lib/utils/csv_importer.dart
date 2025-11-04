// import 'dart:io';
// import 'package:csv/csv.dart';
// // import '../database/product_database_helper.dart';

// // Future<void> importUpiTransactions(File csvFile) async {
// //   final db = ProductDatabaseHelper.instance;
// //   final csvContent = await csvFile.readAsString();
// //   final rows = const CsvToListConverter().convert(csvContent, eol: '\n');

// //   // Assuming CSV Header: ["Date","RefId","Amount","Status","Remarks"]
// //   for (int i = 1; i < rows.length; i++) {
// //     final ref = rows[i][1].toString();
// //     final amount = double.tryParse(rows[i][2].toString()) ?? 0.0;
// //     await db.updatePaymentFromUpi(ref, amount);
// //   }
// // }
