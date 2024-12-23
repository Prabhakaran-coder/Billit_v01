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
    final path = join(documentsDirectory.path, 'Billit.db'); // Your database path

    // Open the database and create the tables if not already present
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        // Create Products table on first run
        await db.execute(''' 
          CREATE TABLE Products(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            itemName TEXT,
            qty INTEGER,
            price INTEGER
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

  // Get all products from the Products table
  Future<List<Product>> getProduct() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('Products');
    return List.generate(maps.length, (i) {
    return Product.fromMap(maps[i]);
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

  // Delete a product from the Products table
  Future<int> deleteProduct(int id) async {
    final db = await database;
    return await db.delete(
      'Products',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
