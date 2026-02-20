import 'package:sqflite/sqflite.dart';
import 'package:pos_app/database/database_service.dart';
import 'package:pos_app/database/product_dao.dart';
import 'package:pos_app/models/product.dart';
import 'package:pos_app/models/transaction.dart';
import 'package:pos_app/models/transaction_item.dart';

class TransactionDao {
  final DatabaseService _databaseService = DatabaseService.instance;

  Future<List<SaleTransaction>> getAllTransaction() async {
    final db = await _databaseService.database;
    final data = await db.query(
      'transactions',
      orderBy: 'created_at DESC'
    );

    return data.map((map) => SaleTransaction.fromMap(map)).toList();
  }

  Future<SaleTransaction?> getTransactionById(int id) async {
    final db = await _databaseService.database;
    final data = await db.query(
      'transactions',
      where: 'id = ?',
      whereArgs: [id],
    );

    return data.isNotEmpty ? SaleTransaction.fromMap(data.first) : null;
  }

  Future<List<TransactionItem>> getTransactionItemsByTransactionId(int id) async {
    final db = await _databaseService.database;
    final data = await db.query(
      'transactions',
      where: 'id = ?',
      whereArgs: [id],
    );

    return data.map((map) => TransactionItem.fromMap(map)).toList();
  }

  Future<SaleTransaction?> getTransactionWithItems(int id) async {
    final db = await _databaseService.database;
    final transactionData = await db.query(
      'transactions',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (transactionData.isEmpty) {
      return null;
    }

    final itemsData = await db.query(
      'transaction_items',
      where: 'transaction_id = ?',
      whereArgs: [id],
    );

    final items = itemsData.map((map) => TransactionItem.fromMap(map)).toList();
    final transaction = SaleTransaction.fromMap(transactionData.first);

    return transaction.copyWith(items: items);
  }

  Future<int> getTransactionCount() async {
    final db = await _databaseService.database;
    final data = await db.rawQuery(
      'SELECT COUNT(*) as count FROM transactions'
    );

    return Sqflite.firstIntValue(data) ?? 0;
  }

  Future<double> getDailyRevenue() async {
    final db = await _databaseService.database;
    final today = DateTime.now().toIso8601String().substring(0, 10);
    final data = await db.rawQuery(
      'SELECT SUM(grand_total) as revenue FROM transactions WHERE created_at LIKE ?' ,
      ['$today%'],
    );

    final revenue = data.first['revenue'];
    return revenue != null ? (revenue as num).toDouble() : 0.0;
  }

  Future<int> getDailyTransactionCount() async {
    final db = await _databaseService.database;
    final today = DateTime.now().toIso8601String().substring(0, 10);
    final data = await db.rawQuery(
      'SELECT COUNT(*) as count FROM transactions WHERE created_at LIKE ?',
      ['$today%'],
    );

    return Sqflite.firstIntValue(data) ?? 0;
  }

  Future<int> checkoutProccess({
    required String invoiceNumber,
    required double subtotal,
    required double discountAmount,
    required double taxAmount,
    required double grandTotal,
    required String paymentMethod,
    required double amountPaid,
    required double changeAmount,
    required int totalItems,
    required List<TransactionItem> items,
  }) async {

    final db = await _databaseService.database;
    final timeNow = DateTime.now().toIso8601String();

    return await db.transaction((txn) async {
      final transactionId = await txn.insert('transactions', {
        'invoice_number': invoiceNumber,
        'subtotal': subtotal,
        'discount_amount': discountAmount,
        'tax_amount': taxAmount,
        'grand_total': grandTotal,
        'payment_method': paymentMethod,
        'amount_paid': amountPaid,
        'change_amount': changeAmount,
        'total_items': totalItems,
        'created_at': timeNow,
      });

      for (final item in items) {
        await txn.insert('transaction_items', {
          'transaction_id': transactionId,
          'product_id': item.productId,
          'product_name': item.productName,
          'product_price': item.productPrice,
          'discount_percent': item.discountPercent,
          'quantity': item.quantity,
          'subtotal': item.subtotal,
        });

        await txn.rawUpdate(
          'UPDATE products SET stock = stock - ?, updated_at = ? WHERE id = ? AND stock >= ?',
          [item.quantity, timeNow, item.productId, item.quantity],
        );
      }

      return transactionId;
    });
  }

  Future<String> generateInvoiceNumber() async {
    final db = await _databaseService.database;
    final today = DateTime.now().toIso8601String().substring(0, 10).replaceAll('-', '');
    final data = await db.rawQuery(
      'SELECT COUNT(*) as count FROM transactions WHERE created_at LIKE ?',
      ['${DateTime.now().toIso8601String().substring(0, 10)}%'],
    );

    final count = (Sqflite.firstIntValue(data) ?? 0) + 1;
    final number = count.toString().padLeft(3, '0');

    return 'INV-$today-$number';
  }
}