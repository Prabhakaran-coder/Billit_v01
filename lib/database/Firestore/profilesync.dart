import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'dart:async';
import 'package:firebase_storage/firebase_storage.dart';

class ProfileSyncService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //Use a single, safe FFI-based openDb
  Future<Database> _openDb() async {
    sqfliteFfiInit();
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, 'Billit_v01.db');
    return await databaseFactoryFfi.openDatabase(path);
  }

  // Profile Sync
 
  Future<void> syncProfilesToFirestore() async {
    final db = await _openDb();
    final profiles = await db.query('Profile');
    print('Found ${profiles.length} profiles');

    for (final profile in profiles) {
      final id = profile['id'].toString();
      await _firestore.collection('profiles').doc(id).set(
            profile,
            SetOptions(merge: true),
          );
      print('Synced Profile ID: $id');
    }
  }


  // Customers Sync

  Future<void> syncCustomersToFirestore() async {
    final db = await _openDb();
    final customers = await db.query('Customers');
    print('Found ${customers.length} customers');

    for (final c in customers) {
      final id = c['id'].toString();
      await _firestore.collection('customers').doc(id).set(
            c,
            SetOptions(merge: true),
          );
      print('Synced Customer ID: $id');
    }
  }

 
  // Products Sync

  Future<void> syncProductsToFirestore() async {
    final db = await _openDb();
    final products = await db.query('Products');
    print('Found ${products.length} products');

    for (final p in products) {
      final id = p['id'].toString();
      await _firestore.collection('products').doc(id).set(
            p,
            SetOptions(merge: true),
          );
      print('Synced Product ID: $id');
    }
  }

  
  //  Invoice Header + Detail Sync
 
  Future<void> syncInvoicesToFirestore() async {
    final db = await _openDb();
    final headers = await db.query('invoice_header');
    print('Found ${headers.length} invoices');

    for (final header in headers) {
      final invoiceId = header['invoiceId'].toString();
      final invoiceDoc =
          _firestore.collection('invoice_header').doc(invoiceId);

      // Header
      await invoiceDoc.set(header, SetOptions(merge: true));

      // Details
      final details = await db.query(
        'invoice_detail',
        where: 'invoiceId = ?',
        whereArgs: [invoiceId],
      );

      for (int i = 0; i < details.length; i++) {
        await invoiceDoc
            .collection('invoice_detail')
            .doc('item_$i')
            .set(details[i], SetOptions(merge: true));
      }

      print('Synced invoice $invoiceId with ${details.length} items');
    }
  }

 
  Future<void> syncPaymentsToFirestore() async {
    final db = await _openDb();
    final payments = await db.query('payment_detail');
    print('Found ${payments.length} payments');

    for (final p in payments) {
      final invoiceId = p['invoiceId'] ?? 'unknown';
      final date = (p['dateofpayment'] ?? DateTime.now().toString()).toString();
      final docId =
          '${invoiceId}_${date.replaceAll(RegExp(r'[^0-9a-zA-Z]+'), "_")}';

      await _firestore
          .collection('payment_detail')
          .doc(docId)
          .set(p, SetOptions(merge: true));
      print('Synced payment for invoice: $invoiceId');
    }
  }

Future<void> syncProfilesFromFirestore() async {
  final db = await _openDb();
  final snapshot = await _firestore.collection('Profile').get();

  print('Syncing ${snapshot.docs.length} profiles from Firestore...');

  for (final doc in snapshot.docs) {
    final data = doc.data();
    await db.insert(
      'Profile',
      {
        'id': data['id'],
        'profileName': data['profileName'],
        'profileAddress': data['profileAddress'],
        'district': data['district'],
        'state': data['state'],
        'profileContact': data['profileContact'],
        'emailAddress': data['emailAddress'],
        'pincode': data['pincode'],
        'gst': data['gst'],
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  print('Profiles restored from Firestore.');
}
Future<void> syncCustomersFromFirestore() async {
  final db = await _openDb();
  final snapshot = await _firestore.collection('customers').get();

  print('Syncing ${snapshot.docs.length} customers from Firestore...');

  for (final doc in snapshot.docs) {
    final data = doc.data();
    await db.insert(
      'Customers',
      {
        'id': data['id'],
        'customerName': data['customerName'],
        'customerAddress': data['customerAddress'],
        'district': data['district'],
        'state': data['state'],
        'customerContact': data['customerContact'],
        'customeremailContact': data['customeremailContact'],
        'customerPincode': data['customerPincode'],
        'gst': data['gst'],
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  print('Customers restored from Firestore.');
}

Future<void> syncProductsFromFirestore() async {
  final db = await _openDb();
  final snapshot = await _firestore.collection('products').get();

  print('Syncing ${snapshot.docs.length} products from Firestore...');

  for (final doc in snapshot.docs) {
    final data = doc.data();
    await db.insert(
      'Products',
      {
        'id': data['id'],
        'itemName': data['itemName'],
        'qty': data['qty'],
        'price': data['price'],
        'cgst': data['cgst'],
        'sgst': data['sgst'],
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  print('Products restored from Firestore.');
}

Future<void> syncInvoicesFromFirestore() async {
  final db = await _openDb();
  final snapshot = await _firestore.collection('invoice_header').get();

  print('Syncing ${snapshot.docs.length} invoices from Firestore...');

  for (final doc in snapshot.docs) {
    final headerData = doc.data();

    await db.insert(
      'invoice_header',
      headerData,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    // Now sync details for each invoice
    final detailsSnap =
        await _firestore.collection('invoice_header').doc(doc.id).collection('invoice_detail').get();

    for (final d in detailsSnap.docs) {
      await db.insert(
        'invoice_detail',
        d.data(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
  }

  print('Invoices restored from Firestore.');
}

Future<void> syncPaymentsFromFirestore() async {
  final db = await _openDb();
  final snapshot = await _firestore.collection('payment_detail').get();

  print('⬇Syncing ${snapshot.docs.length} payment records from Firestore...');

  for (final doc in snapshot.docs) {
    final data = doc.data();

    await db.insert(
      'payment_detail',
      {
        'invoiceId': data['invoiceId'],
        'dateofpayment': data['dateofpayment'],
        'amountpaid': data['amountpaid'],
        'pendingamount': data['pendingamount'],
        'paymentstatus': data['paymentstatus'],
        'status': data['status'],
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  print('Payments restored from Firestore.');
}
Future<String> uploadInvoiceToFirebase(File file) async {
  final storageRef = FirebaseStorage.instance.ref();
  final invoiceRef = storageRef.child('invoices/${file.uri.pathSegments.last}');

  // Upload the file
  await invoiceRef.putFile(file);

  // Get the public download URL
  final downloadUrl = await invoiceRef.getDownloadURL();
  return downloadUrl;
}

 static Future<String?> uploadInvoicesToFirebase(File invoiceFile, String invoiceId) async {
    try {
      
      final ref = FirebaseStorage.instance.ref().child('invoices/$invoiceId.pdf');

      // Upload the file and wait for completion
      final uploadTask = await ref.putFile(invoiceFile);

      // After successful upload, get the file URL
      final downloadUrl = await ref.getDownloadURL();

      print('Uploaded invoice: $downloadUrl');
      return downloadUrl;
    } on FirebaseException catch (e) {
      print('Firebase upload failed: ${e.message}');
      return null;
    } catch (e) {
      print('Unexpected error during upload: $e');
      return null;
    }
  }


}
