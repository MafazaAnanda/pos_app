import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';

class DatabaseService {
  static Database? _db;
  static final DatabaseService instance = DatabaseService._constructor();

  DatabaseService._constructor();

  Future<Database> get database async {
    if (_db != null) {
      return _db!;
    }

    _db = await initDatabase();
    return _db!;
  }

  Future<Database> initDatabase() async {
    final databaseDirPath = await getDatabasesPath();
    final databasePath = join(databaseDirPath, "master_db.db");
    final database = await openDatabase(
      databasePath,
      version: 1,
      onCreate: (db, version) async {
        await db.execute("PRAGMA foreign_key = ON");

        // products table
        await db.execute('''
        CREATE TABLE products (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name TEXT NOT NULL,
          category TEXT NOT NULL,
          sell_price REAL NOT NULL,
          cost_price REAL NOT NULL,
          stock INTEGER NOT NULL DEFAULT 0,
          min_stock INTEGER NOT NULL DEFAULT 0,
          discount_percent REAL NOT NULL DEFAULT 0,
          is_active INTEGER NOT NULL DEFAULT 1,
          image_path TEXT,
          created_at TEXT NOT NULL,
          updated_at TEXT NOT NULL
        )
        ''');

        // transaction table
        await db.execute('''
          CREATE TABLE transactions (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            invoice_number TEXT UNIQUE NOT NULL,
            subtotal REAL NOT NULL,
            discount_amount REAL NOT NULL DEFAULT 0,
            tax_amount REAL NOT NULL DEFAULT 0,
            grand_total REAL NOT NULL,
            payment_method TEXT NOT NULL,
            amount_paid REAL NOT NULL,
            change_amount REAL NOT NULL DEFAULT 0,
            total_items INTEGER NOT NULL,
            created_at TEXT NOT NULL
          )
        ''');

        // transaction items table
        await db.execute('''
          CREATE TABLE transaction_items (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            transaction_id INTEGER NOT NULL,
            product_id INTEGER NOT NULL,
            product_name TEXT NOT NULL,
            product_price REAL NOT NULL,
            discount_percent REAL NOT NULL DEFAULT 0,
            quantity INTEGER NOT NULL,
            subtotal REAL NOT NULL,
            FOREIGN KEY (transaction_id) REFERENCES transactions (id) ON DELETE CASCADE,
            FOREIGN KEY (product_id) REFERENCES products (id)
          )
        ''');
      }
    );

    return database;
  }
}