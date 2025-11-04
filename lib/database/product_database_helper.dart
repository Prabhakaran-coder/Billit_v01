import 'package:billit/models/product_db_data.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart'; 
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';

class ProductDatabaseHelper {
  static Database? _database;
  static final ProductDatabaseHelper instance = ProductDatabaseHelper._();
  final String upiRefId;
  ProductDatabaseHelper._()  : upiRefId = const Uuid().v4();
 
  

  // This is the method to get the database instance
 static Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  // This method will initialize the database and return the instance
 static Future<Database> _initDatabase() async {
   
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, 'Billit_v01.db'); 

    // Open the database and create the tables if not already present
    return await openDatabase(
      path,
      version: 1, 
      onCreate: (db, version) async {
        
        await db.execute(''' 
          CREATE TABLE Products(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            itemName TEXT,
            qty INTEGER,
            price DOUBLE,
            cgst INTEGER,
            sgst INTEGER
          )
        ''');
        await db.execute(''' 
          CREATE TABLE Customers(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            customerName TEXT,
            customerAddress TEXT,
            district TEXT,
            state TEXT,
            customerContact INTEGER,
            customeremailContact TEXT,
            customerPincode INTEGER,
            gst TEXT
          )
        ''');
        await db.execute(''' 
          CREATE TABLE Profile(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            profileName TEXT,
            profileAddress TEXT,
            district TEXT,
            state TEXT,
            profileContact INTEGER,
            emailAddress TEXT,
            pincode INTEGER,
            gst TEXT
          )
        ''');
         await db.execute('''
          CREATE TABLE invoice_header (
            invoiceId TEXT PRIMARY KEY,
            customerName TEXT,
            isGstApplicable TEXT,
            subtotal REAL,
            cgst REAL,
            sgst REAL,
            igst REAL,
            totalAmount REAL,
            date TEXT
          )
        ''');
        db.execute('''
          CREATE TABLE invoice_detail (            
            invoiceId TEXT,
            productName TEXT,
            quantity INTEGER,
            price REAL,
            amount REAL,
            cgstPerProduct REAL,
            sgstPerProduct REAL,
            FOREIGN KEY(invoiceId) REFERENCES invoice_header(id)
          )
        ''');

         db.execute('''
          CREATE TABLE payment_detail (            
            invoiceId TEXT,
            dateofpayment TEXT,
            amountpaid REAL,
            pendingamount TEXT,
            paymentstatus TEXT,
            upiRefId TEXT,
            status TEXT          
          )
        ''');
         db.execute('''
          CREATE TABLE adminData (
            id INTEGER PRIMARY KEY AUTOINCREMENT,            
            username TEXT,
            emailid TEXT UNIQUE,
            password TEXT       
          )
        ''');
        await db.execute('''
  CREATE TABLE IF NOT EXISTS email_queue (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    to_email TEXT NOT NULL,
    file_path TEXT NOT NULL,
    file_name TEXT NOT NULL,
    invoiceId TEXT,
    total_amount TEXT,
    customer_name TEXT,
    sent INTEGER DEFAULT 0,
    created_at TEXT DEFAULT CURRENT_TIMESTAMP
  )
''');

      },
     
    );
  }

  //admin
  static Future<int> insertAdmin(AdminSignUp admin) async {
    final db = await database;
    return await db.insert('adminData', admin.toMap());
  }

  /// Get all admins
  static Future<List<Map<String, dynamic>>> getAdmins() async {
    final db = await database;
    return await db.query('adminData');
  }

  // Fetch admin by email
static Future<AdminSignUp?> getAdminByEmail(String email) async {
  final db = await database; 
  final result = await db.query(
    'adminData', 
    where: 'emailid = ?',
    whereArgs: [email],
  );

  if (result.isNotEmpty) {
    return AdminSignUp.fromMap(result.first);
  } else {
    return null;
  }
}


  /// Update password
  static Future<int> updatePassword(int id, String newPassword) async {
    final db = await database;
    return await db.update(
      'adminData',
      {'password': newPassword},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  /// Delete admin
  static Future<int> deleteAdmin(int id) async {
    final db = await database;
    return await db.delete('adminData', where: 'id = ?', whereArgs: [id]);
  }
  // Insert a new product into the Products table
  Future<int> insertProduct(Product product) async {
    final db = await database;
    return await db.insert('Products', product.toMap());
  }

  // Insert Customer 
  Future<int> insertCustomers(Customers Customer) async {
    final db = await database;
    return await db.insert('Customers', Customer.toMap());
  }
   Future<int> insertProfile(Profile Profile) async {
    final db = await database;
    return await db.insert('Profile', Profile.toMap());
  }
 Future<int> insertInvoiceHeader(InvoiceHeader header) async {
    final dbClient = await database;
    return await dbClient.insert('invoice_header', header.toMap());
  }

  Future<int> insertInvoiceDetail(InvoiceDetail detail) async {
    final dbClient = await database;
    return await dbClient.insert('invoice_detail', detail.toMap());
  }
   Future<int> insertPaymentData(PaymentDetail paymentData) async {
    final dbClient = await database;
    return await dbClient.insert('payment_detail', paymentData.toMap());
  }


  Future<String?> getLatestInvoiceIdForMonth(String year, String month,bool isGstApplicable) async {
  final db = await database; // Access your database instance
  String gstFlag=isGstApplicable?'true':'false';
  // Query the latest invoice ID for the given year and month
  final result = await db.rawQuery('''
    SELECT invoiceId 
    FROM invoice_header 
    WHERE date LIKE '$year-$month%' AND isGstApplicable = '$gstFlag'
    ORDER BY date DESC 
    LIMIT 1
  ''',);

  if (result.isNotEmpty) {
    return result.first['invoiceId'] as String;
  } else {
    return null; // No invoice found
  }
}

  // Get all products from the Products table
  Future<List<Product>> getProduct() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('Products');
    return List.generate(maps.length, (i) {
      return Product.fromMap(maps[i]);
    });
  }

  // Get all customers from the customers table
  Future<List<Customers>> getCustomers() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('Customers');
    return List.generate(maps.length, (i) {
      return Customers.fromMap(maps[i]);
    });
  }
// Get all customers from the profile table
  Future<List<Profile>> getProfile() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('Profile');
    return List.generate(maps.length, (i) {
      return Profile.fromMap(maps[i]);
    });
  }
   Future<List<InvoiceHeader>> getAllPaymentData() async {
    final db = await database;
    //final List<Map<String, dynamic>> maps = await db.query('payment_detail');
    final List<Map<String, dynamic>> maps = await db.query('invoice_header');
    return List.generate(maps.length, (i) {
      return InvoiceHeader.fromMap(maps[i]);
    });
  }

  Future<List<PaymentDetail>> getPaidPaymentData() async {
    final db = await database;
     final result = await db.query(
      'payment_detail',
      where: 'status= ?', 
      whereArgs: ["Paid"],
     
    );

     return List.generate(result.length, (i) {
    return PaymentDetail.fromMap(result[i]);
  });
  }
  Future<List<PaymentDetail>> getPendingPaymentData() async {
    final db = await database;
     final result = await db.query(
      'payment_detail',
      where: 'status= ?', 
      whereArgs: ["Pending"],
     
    );

     return List.generate(result.length, (i) {
    return PaymentDetail.fromMap(result[i]);
  });
  }
  //fetch payment data for the specified record

  Future<List<PaymentDetail>> getPaymentData(String invoiceId) async {
  final dbClient = await database;

     final result = await dbClient.query(
      'payment_detail',
      where: 'invoiceId= ?', 
      whereArgs: [invoiceId],
     
    );

     return List.generate(result.length, (i) {
    return PaymentDetail.fromMap(result[i]);
  });
  }
   Future<List<Customers>> getParticularCustomer(String customerName) async {
    final db = await database;
    final result = await db.query(
      'customers',
      where: 'customerName= ?', 
      whereArgs: [customerName],
     
    );

     return List.generate(result.length, (i) {
    return Customers.fromMap(result[i]);
  });
  }
Future<List<String>> getGstCustomerNames() async {
    final db = await database;
    final result = await db.query(
      'customers',
      where: 'gst != ?', // Filtering based on the 'gst' column being 'yes'
      whereArgs: ['No'],
      columns: ['customerName'],
    );

    return result.map((e) => e['customerName'] as String).toList();
  }
Future<List<String>> getCustomerNames() async {
    final db = await database;
    final result = await db.query(
      'customers',
      where: 'customerName = ?', 
      whereArgs: ['customerName'],
      
    );

    return result.map((e) => e['customerName'] as String).toList();
  }
  
   Future<List<InvoiceHeader>> getAllInvoiceHeader() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('invoice_header');
    return List.generate(maps.length, (i) {
      return InvoiceHeader.fromMap(maps[i]);
    });
  }
Future<List<Map<String, dynamic>>> getInvoiceTotalsByMonth() async {
  final db = await database;
  final result = await db.rawQuery('''
      SELECT 
  CASE strftime('%m', dateofpayment)
    WHEN '01' THEN 'Jan'
    WHEN '02' THEN 'Feb'
    WHEN '03' THEN 'Mar'
    WHEN '04' THEN 'Apr'
    WHEN '05' THEN 'May'
    WHEN '06' THEN 'Jun'
    WHEN '07' THEN 'Jul'
    WHEN '08' THEN 'Aug'
    WHEN '09' THEN 'Sep'
    WHEN '10' THEN 'Oct'
    WHEN '11' THEN 'Nov'
    WHEN '12' THEN 'Dec'
  END AS month,
  SUM(amountpaid) AS total
FROM payment_detail
WHERE status IN ('Paid', 'Pending')
GROUP BY month
ORDER BY strftime('%m', dateofpayment);
  ''');
  return result;
}

Future<List<Map<String, dynamic>>> getProductSalesData() async {
  final db = await database;

  final result = await db.rawQuery('''
    SELECT 
      productName AS name,
      COUNT(*) AS soldCount
    FROM invoice_detail
    GROUP BY productName
    ORDER BY soldCount DESC;
  ''');

  return result;
}
  Future<List<InvoiceHeader>> getSpecificInvoiceHeader(String invoiceId) async {
  final dbClient = await database;
  final List<Map<String, dynamic>> maps = await dbClient.query(
    'invoice_header',
    where: 'invoiceId = ?',
    whereArgs: [invoiceId],
  );
  // Return a list of InvoiceHeader objects.
  return List.generate(maps.length, (i) {
    return InvoiceHeader.fromMap(maps[i]);
  });
}

  Future<List<InvoiceDetail>> getInvoiceDetails(String invoiceId) async {
  final dbClient = await database;
  final List<Map<String, dynamic>> maps = await dbClient.query(
    'invoice_detail',
    where: 'invoiceId = ?',
    whereArgs: [invoiceId],
  );
     return List.generate(maps.length, (i) {
      return InvoiceDetail.fromMap(maps[i]);
    });
  }

  // Update an existing product in the Products table
  Future<int> updateProduct(Product product) async {
    final db = await database;
    return await db.update(
      'Products',
      product.toMap(),
      where: 'id = ?',
      whereArgs: [product.id],
    );
  }

  // Update an existing Customer in the Customer table
  Future<int> updateCustomers(Customers customer) async {
    final db = await database;
    return await db.update(
      'Customers',
      customer.toMap(),
      where: 'id = ?',
      whereArgs: [customer.id],
    );
  }

  // Update an existing admin in the prfoile table
  Future<int> updateProfile(Profile profile) async {
    final db = await database;
    return await db.update(
      'Profile',
      profile.toMap(),
      where: 'id = ?',
      whereArgs: [profile.id],
    );
  }


  // Delete a product from the Products table
  Future<int> deleteProduct(int id) async {
    final db = await database;
    return await db.delete(
      'Products',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Delete a customer from the customer table
  Future<int> deleteCustomers(int id) async {
    final db = await database;
    return await db.delete(
      'Customers',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // ---------------------- EMAIL QUEUE METHODS ----------------------

Future<int> insertQueuedEmail(
  String toEmail,
  String filePath,
  String fileName,
  String invoiceId,
  String totalAmount,
  String customerName,
) async {
  final db = await database;
  return await db.insert('email_queue', {
    'to_email': toEmail,
    'file_path': filePath,
    'file_name': fileName,
    'invoiceId': invoiceId,
    'total_amount': totalAmount,
    'customer_name': customerName,
    'sent': 0,
  });
}

Future<List<Map<String, dynamic>>> getUnsentEmails() async {
  final db = await database;
  return await db.query('email_queue', where: 'sent = ?', whereArgs: [0]);
}

Future<void> markEmailAsSent(int id) async {
  final db = await database;
  await db.update('email_queue', {'sent': 1}, where: 'id = ?', whereArgs: [id]);
}
Future<List<Map<String, dynamic>>> getAllEmails() async {
  final db = await database;
  return await db.query('email_queue');
}

Future<int> updateEmailStatus(int id, bool sent) async {
  final db = await database;
  return await db.update(
    'email_queue',
    {'sent': sent ? 1 : 0},
    where: 'id = ?',
    whereArgs: [id],
  );
}
}
