import 'package:hive_flutter/hive_flutter.dart';

class DatabaseService {
  static final DatabaseService instance = DatabaseService._constructor();
  DatabaseService._constructor();

  Box? _productsBox;
  Box? _transactionsBox;
  Box? _transactionItemsBox;

  Box get productsBox => _productsBox!;
  Box get transactionsBox => _transactionsBox!;
  Box get transactionItemsBox => _transactionItemsBox!;

  Future<void> init() async {
    await Hive.initFlutter();
    _productsBox = await Hive.openBox('products');
    _transactionsBox = await Hive.openBox('transactions');
    _transactionItemsBox = await Hive.openBox('transaction_items');
  }
}