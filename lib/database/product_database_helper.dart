import 'package:billit/models/product_db_data.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart'; // Import sqflite_common_ffi
import 'package:path/path.dart';
import 'dart:io' as io;

class ProductDatabaseHelper {
  static Database? _database;
  static final ProductDatabaseHelper instance = ProductDatabaseHelper._();

  ProductDatabaseHelper._();

  // This is the method to get the database instance
  Future<Database> get database async {
    if (_database != null) return _database!;

    // Initialize sqflite_common_ffi for Windows, Linux, macOS
    if (io.Platform.isWindows || io.Platform.isLinux || io.Platform.isMacOS) {
      // Initialize databaseFactoryFfi for desktop platforms
      databaseFactory = databaseFactoryFfi;
    }

    // If the database doesn't exist, create one
    _database = await _initDatabase();
    return _database!;
  }

  // This method will initialize the database and return the instance
  Future<Database> _initDatabase() async {
    // Get the application document directory for storing the database file
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, 'Billit_v01.db'); // Your database path

    // Open the database and create the tables if not already present
    return await openDatabase(
      path,
      version: 1, // Incremented the version
      onCreate: (db, version) async {
        // Create Products table on first run
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
            state TEXT,
            customerContact INTEGER,
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
            FOREIGN KEY(invoiceId) REFERENCES invoice_header(id)
          )
        ''');
      },
     
    );
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
 Future<int> insertInvoiceHeader(InvoiceHeader header) async {
    final dbClient = await database;
    return await dbClient.insert('invoice_header', header.toMap());
  }

  Future<int> insertInvoiceDetail(InvoiceDetail detail) async {
    final dbClient = await database;
    return await dbClient.insert('invoice_detail', detail.toMap());
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
   Future<List<Customers>> getParticularCustomer(String customerName) async {
    final db = await database;
    final result = await db.query(
      'customers',
      where: 'customerName= ?', // Filtering based on the 'gst' column being 'yes'
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
      where: 'gst = ?', // Filtering based on the 'gst' column being 'yes'
      whereArgs: ['No'],
      columns: ['customerName'],
    );

    return result.map((e) => e['customerName'] as String).toList();
  }
  //-------retrievein all invoice details from invoiceheader(invoice id,customername etc....)
   Future<List<InvoiceHeader>> getAllInvoiceHeader() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('invoice_header');
    return List.generate(maps.length, (i) {
      return InvoiceHeader.fromMap(maps[i]);
    });
  }
//----retrieveing specif invoice------///
  // Future<List<InvoiceHeader>> getSpecificInvoiceHeader(String invoiceId) async {
  // final dbClient = await database;
  // final List<Map<String, dynamic>> maps = await dbClient.query(
  //   'invoice_header',
  //   where: 'invoiceId = ?',
  //   whereArgs: [invoiceId],
  // );
  //   return List.generate(maps.length, (i) {
  //     return InvoiceHeader.fromMap(maps[i]);
  //   });
  // }
  Future<List<InvoiceHeader>> getSpecificInvoiceHeader(String invoiceId) async {
  final dbClient = await database;
  final List<Map<String, dynamic>> maps = await dbClient.query(
    'invoice_header',
    where: 'invoiceId = ?',
    whereArgs: [invoiceId],
  );
  print("Fetched ${maps.length} records for invoiceId: $invoiceId");
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

  // Delete a product from the Products table
  Future<int> deleteProduct(int id) async {
    final db = await database;
    return await db.delete(
      'Products',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Delete a product from the Products table
  Future<int> deleteCustomers(int id) async {
    final db = await database;
    return await db.delete(
      'Customers',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
