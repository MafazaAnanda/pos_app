class TransactionItem {
  final int? id;
  final int transactionId;
  final int productId;
  final String productName;
  final double productPrice;
  final double discountPercent;
  final int quantity;
  final double subtotal;

  TransactionItem({
    this.id,
    required this.transactionId,
    required this.productId,
    required this.productName,
    required this.productPrice,
    this.discountPercent = 0,
    required this.quantity,
    required this.subtotal,
  });

  factory TransactionItem.fromMap(Map<String, dynamic> map) {
    return TransactionItem(
      id: map['id'] as int?,
      transactionId: map['transaction_id'] as int,
      productId: map['product_id'] as int,
      productName: map['product_name'] as String,
      productPrice: (map['product_price'] as num).toDouble(),
      discountPercent: (map['discount_percent'] as num).toDouble(),
      quantity: map['quantity'] as int,
      subtotal: (map['subtotal'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'transaction_id': transactionId,
      'product_id': productId,
      'product_name': productName,
      'product_price': productPrice,
      'discount_percent': discountPercent,
      'quantity': quantity,
      'subtotal': subtotal,
    };
  }

  TransactionItem copyWith({
    int? id,
    int? transactionId,
    int? productId,
    String? productName,
    double? productPrice,
    double? discountPercent,
    int? quantity,
    double? subtotal,
  }) {
    return TransactionItem(
      id: id ?? this.id,
      transactionId: transactionId ?? this.transactionId,
      productId: productId ?? this.productId,
      productName: productName ?? this.productName,
      productPrice: productPrice ?? this.productPrice,
      discountPercent: discountPercent ?? this.discountPercent,
      quantity: quantity ?? this.quantity,
      subtotal: subtotal ?? this.subtotal,
    );
  }
}
