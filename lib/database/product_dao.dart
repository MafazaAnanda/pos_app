import 'package:sqflite/sqflite.dart';
import 'package:pos_app/database/database_service.dart';
import 'package:pos_app/models/product.dart';

class ProductDao {
  final DatabaseService _databaseService = DatabaseService.instance;

  Future<int> createProduct(Product product) async {
    final db = await _databaseService.database;
    final timeNow = DateTime.now().toIso8601String();

    final map = product.toMap();
    map['created_at'] = timeNow;
    map['updated_at'] = timeNow;

    return await db.insert('products', map);
  }

  Future<List<Product>> getAllProducts() async {
    final db = await _databaseService.database;
    final data = await db.query(
      'products',
      orderBy: 'created_at DESC',
    );

    return data.map((map) => Product.fromMap(map)).toList();
  }

  Future<List<Product>> getActiveProducts() async {
    final db = await _databaseService.database;
    final data = await db.query(
      'products',
      where: 'is_active = ? AND stock > ?',
      whereArgs: [1, 0],
      orderBy: 'name ASC',
    );

    return data.map((map) => Product.fromMap(map)).toList();
  }

  Future<Product?> getProductById(int id) async {
    final db = await _databaseService.database;
    final data = await db.query(
      'products',
      where: 'id = ?',
      whereArgs: [id],
    );

    return data.isNotEmpty ? Product.fromMap(data.first): null;
  }

  Future<List<Product>> getProductByName(String name) async {
    final db = await _databaseService.database;
    final data = await db.query(
      'products',
      where: 'name LIKE  ?',
      whereArgs: ['%$name%'],
      orderBy: 'name ASC',
    );

    return data.map((map) => Product.fromMap(map)).toList(); 
  }

  Future<List<Product>> getLowStockProducts() async {
    final db = await _databaseService.database;
    final data = await db.rawQuery(
      'SELECT * FROM products WHERE stock <= min_stock AND is_active = 1 ORDER BY stock ASC',
    ); 

    return data.map((map) => Product.fromMap(map)).toList(); 
  }

  Future<int> updateProduct(int id, Product product) async {
    final db = await _databaseService.database;

    final map = product.toMap();
    map['updated_at'] = DateTime.now().toIso8601String();
    
    return await db.update(
      'products',
      map,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> reduceStock(int id, int quantity) async {
    final db = await _databaseService.database;

    return await db.rawUpdate(
      'UPDATE products SET stock = stock - ?, updated_at = ? WHERE id = ? AND stock >= ?',
      [quantity, DateTime.now().toIso8601String(), id, 0],
    );
  }

  Future<int> getProductCount() async {
    final db = await _databaseService.database;
    final data = await db.rawQuery(
      'SELECT COUNT(*) as count FROM products'
    );
    return Sqflite.firstIntValue(data) ?? 0;
  }

  Future<int> deleteProduct(int id) async {
    final db = await _databaseService.database;

    return await db.delete(
      'products',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}