import 'package:pos_app/database/database_service.dart';
import 'package:pos_app/database/product_dao.dart';
import 'package:pos_app/models/transaction.dart';
import 'package:pos_app/models/transaction_item.dart';

class TransactionDao {
  final DatabaseService _db = DatabaseService.instance;
  final ProductDao _productDao = ProductDao();

  Future<List<SaleTransaction>> getAllTransaction() async {
    final box = _db.transactionsBox;
    return box.keys.map((key) {
      final map = Map<String, dynamic>.from(box.get(key) as Map);
      map['id'] = key;
      return SaleTransaction.fromMap(map);
    }).toList()
      ..sort((a, b) {
        final aDate = a.createdAt ?? '';
        final bDate = b.createdAt ?? '';
        return bDate.compareTo(aDate); 
      });
  }

  Future<SaleTransaction?> getTransactionById(int id) async {
    final box = _db.transactionsBox;
    final raw = box.get(id);
    if (raw == null) {
      return null;
    }
    
    final map = Map<String, dynamic>.from(raw as Map);
    map['id'] = id;
    return SaleTransaction.fromMap(map);
  }

  Future<List<TransactionItem>> getTransactionItemsByTransactionId(int id) async {
    final box = _db.transactionItemsBox;
    return box.keys
        .where((key) {
          final raw = box.get(key);
          if (raw == null) {
            return false;
          }

          final map = Map<String, dynamic>.from(raw as Map);
          return map['transaction_id'] == id;
        })

        .map((key) {
          final map = Map<String, dynamic>.from(box.get(key) as Map);
          map['id'] = key;
          return TransactionItem.fromMap(map);
        })

        .toList();
  }

  Future<SaleTransaction?> getTransactionWithItems(int id) async {
    final transaction = await getTransactionById(id);
    if (transaction == null) {
      return null;
    }
    
    final items = await getTransactionItemsByTransactionId(id);
    return transaction.copyWith(items: items);
  }

  Future<int> getTransactionCount() async {
    return _db.transactionsBox.length;
  }

  Future<double> getDailyRevenue() async {
    final today = DateTime.now().toIso8601String().substring(0, 10);
    final all = await getAllTransaction();
    return all
        .where((t) => (t.createdAt ?? '').startsWith(today))
        .fold(0.0, (sum, t) => sum + t.grandTotal);
  }

  Future<int> getDailyTransactionCount() async {
    final today = DateTime.now().toIso8601String().substring(0, 10);
    final all = await getAllTransaction();
    return all.where((t) => (t.createdAt ?? '').startsWith(today)).length;
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
    final txnBox = _db.transactionsBox;
    final itemBox = _db.transactionItemsBox;
    final timeNow = DateTime.now().toIso8601String();

    // Simpan transaksi
    final transactionMap = {
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
    };
    final transactionKey = await txnBox.add(transactionMap);
    transactionMap['id'] = transactionKey;
    await txnBox.put(transactionKey, transactionMap);

    // Simpan item & kurangi stok
    for (final item in items) {
      final itemMap = {
        'transaction_id': transactionKey,
        'product_id': item.productId,
        'product_name': item.productName,
        'product_price': item.productPrice,
        'discount_percent': item.discountPercent,
        'quantity': item.quantity,
        'subtotal': item.subtotal,
      };
      final itemKey = await itemBox.add(itemMap);
      itemMap['id'] = itemKey;
      await itemBox.put(itemKey, itemMap);

      // Kurangi stok produk
      await _productDao.reduceStock(item.productId, item.quantity);
    }

    return transactionKey;
  }

  Future<String> generateInvoiceNumber() async {
    final today = DateTime.now().toIso8601String().substring(0, 10);
    final todayFormatted = today.replaceAll('-', '');
    final count = (await getDailyTransactionCount()) + 1;
    final number = count.toString().padLeft(3, '0');
    return 'INV-$todayFormatted-$number';
  }
}