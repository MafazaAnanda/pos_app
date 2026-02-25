import 'package:pos_app/models/product.dart';

class CartItem {
  final Product product;
  int quantity;

  CartItem ({
    required this.product,
    this.quantity = 1,
  });

  double get priceAfterDiscount {
    return product.sellPrice * (1 - product.discountPercent / 100);
  }
  double get subTotal {
    return priceAfterDiscount * quantity;
  }
}