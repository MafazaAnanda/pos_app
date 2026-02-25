import 'package:pos_app/database/database_service.dart';
import 'package:pos_app/models/product.dart';

class ProductDao {
  final DatabaseService _db = DatabaseService.instance;

  Future<int> createProduct(Product product) async {
    final box = _db.productsBox;
    final timeNow = DateTime.now().toIso8601String();
    final map = product.toMap();
    map['created_at'] = timeNow;
    map['updated_at'] = timeNow;

    final key = await box.add(map);
    map['id'] = key;
    await box.put(key, map);
    return key;
  }

  Future<List<Product>> getAllProducts() async {
    final box = _db.productsBox;
    return box.keys.map((key) {
      final map = Map<String, dynamic>.from(box.get(key) as Map);
      map['id'] = key;
      return Product.fromMap(map);
    }).toList()
      ..sort((a, b) {
        final aDate = a.createdAt ?? '';
        final bDate = b.createdAt ?? '';
        return bDate.compareTo(aDate); 
      });
  }

  Future<List<Product>> getActiveProducts() async {
    final all = await getAllProducts();
    return all
        .where((p) => p.isActive == 1 && p.stock > 0)
        .toList()
      ..sort((a, b) => a.name.compareTo(b.name));
  }

  Future<Product?> getProductById(int id) async {
    final box = _db.productsBox;
    final raw = box.get(id);
    if (raw == null) {
      return null;
    }

    final map = Map<String, dynamic>.from(raw as Map);
    map['id'] = id;
    return Product.fromMap(map);
  }

  Future<List<Product>> getProductByName(String name) async {
    final all = await getAllProducts();
    return all
        .where((p) => p.name.toLowerCase().contains(name.toLowerCase()))
        .toList()
      ..sort((a, b) => a.name.compareTo(b.name));
  }

  Future<List<Product>> getLowStockProducts() async {
    final all = await getAllProducts();
    return all
        .where((p) => p.stock <= p.minStock && p.isActive == 1)
        .toList()
      ..sort((a, b) => a.stock.compareTo(b.stock));
  }

  Future<int> updateProduct(int id, Product product) async {
    final box = _db.productsBox;
    final map = product.toMap();
    map['id'] = id;
    map['updated_at'] = DateTime.now().toIso8601String();
    await box.put(id, map);
    return 1;
  }

  Future<int> reduceStock(int id, int quantity) async {
    final product = await getProductById(id);
    if (product == null || product.stock < quantity) {
      return 0;
    }
    
    final updated = product.copyWith(stock: product.stock - quantity);
    return updateProduct(id, updated);
  }

  Future<int> getProductCount() async {
    return _db.productsBox.length;
  }

  Future<int> deleteProduct(int id) async {
    await _db.productsBox.delete(id);
    return 1;
  }
}