import 'package:pos_app/models/transaction_item.dart';

class SaleTransaction {
  final int? id;
  final String invoiceNumber;
  final double subtotal;
  final double discountAmount;
  final double taxAmount;
  final double grandTotal;
  final String paymentMethod;
  final double amountPaid;
  final double changeAmount;
  final int totalItems;
  final String? createdAt;
  final List<TransactionItem>? items; 

  SaleTransaction({
    this.id,
    required this.invoiceNumber,
    required this.subtotal,
    this.discountAmount = 0,
    this.taxAmount = 0,
    required this.grandTotal,
    required this.paymentMethod,
    required this.amountPaid,
    this.changeAmount = 0,
    required this.totalItems,
    this.createdAt,
    this.items,
  });

  factory SaleTransaction.fromMap(Map<String, dynamic> map) {
    return SaleTransaction(
      id: map['id'] as int?,
      invoiceNumber: map['invoice_number'] as String,
      subtotal: (map['subtotal'] as num).toDouble(),
      discountAmount: (map['discount_amount'] as num).toDouble(),
      taxAmount: (map['tax_amount'] as num).toDouble(),
      grandTotal: (map['grand_total'] as num).toDouble(),
      paymentMethod: map['payment_method'] as String,
      amountPaid: (map['amount_paid'] as num).toDouble(),
      changeAmount: (map['change_amount'] as num).toDouble(),
      totalItems: map['total_items'] as int,
      createdAt: map['created_at'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'invoice_number': invoiceNumber,
      'subtotal': subtotal,
      'discount_amount': discountAmount,
      'tax_amount': taxAmount,
      'grand_total': grandTotal,
      'payment_method': paymentMethod,
      'amount_paid': amountPaid,
      'change_amount': changeAmount,
      'total_items': totalItems,
      'created_at': createdAt,
    };
  }

  SaleTransaction copyWith({
    int? id,
    String? invoiceNumber,
    double? subtotal,
    double? discountAmount,
    double? taxAmount,
    double? grandTotal,
    String? paymentMethod,
    double? amountPaid,
    double? changeAmount,
    int? totalItems,
    String? createdAt,
    List<TransactionItem>? items,
  }) {
    return SaleTransaction(
      id: id ?? this.id,
      invoiceNumber: invoiceNumber ?? this.invoiceNumber,
      subtotal: subtotal ?? this.subtotal,
      discountAmount: discountAmount ?? this.discountAmount,
      taxAmount: taxAmount ?? this.taxAmount,
      grandTotal: grandTotal ?? this.grandTotal,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      amountPaid: amountPaid ?? this.amountPaid,
      changeAmount: changeAmount ?? this.changeAmount,
      totalItems: totalItems ?? this.totalItems,
      createdAt: createdAt ?? this.createdAt,
      items: items ?? this.items,
    );
  }
}
