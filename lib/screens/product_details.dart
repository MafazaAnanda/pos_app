import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pos_app/formatter/currency_formatter.dart';
import 'package:pos_app/models/product.dart';

class ProductDetails extends StatelessWidget {
  final Product product;

  const ProductDetails({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(product.name),
      ),

      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Gambar produk
            _buildHeroImage(),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          product.name,
                          style: primaryColor.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                      if (product.isFavorite == 1)
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.red[50],
                            borderRadius: BorderRadius.circular(20),
                          ),

                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.favorite,
                                  color: Colors.red, size: 14),
                              const SizedBox(width: 4),
                              Text('Favorite',
                                  style: TextStyle(
                                      color: Colors.red[700], fontSize: 12)),
                            ],
                          ),
                        ),
                    ],
                  ),
                  
                  const SizedBox(height: 4),

                  // Kategori
                  Row(
                    children: [
                      Icon(Icons.category_outlined,
                          size: 14, color: Colors.grey[500]),
                      const SizedBox(width: 4),
                      Text(product.category,
                          style: TextStyle(color: Colors.grey[600])),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Deskripsi
                  if (product.description.isNotEmpty) ...[
                    Text('Description',
                        style: primaryColor.textTheme.titleSmall
                            ?.copyWith(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 6),
                    Text(
                      product.description,
                      style: TextStyle(color: Colors.grey[700], height: 1.5),
                    ),
                    const SizedBox(height: 20),
                  ],

                  // Info harga & stok
                  const Divider(),
                  const SizedBox(height: 12),
                  _infoRow(
                    icon: Icons.sell_outlined,
                    label: 'Sell Price',
                    value: CurrencyFormatter.convertToIdr(product.sellPrice, 0),
                    valueColor: Colors.indigo,
                    bold: true,
                  ),

                  const SizedBox(height: 10),
                  _infoRow(
                    icon: Icons.shopping_cart_outlined,
                    label: 'Cost Price',
                    value: CurrencyFormatter.convertToIdr(product.costPrice, 0),
                  ),

                  if (product.discountPercent > 0) ...[
                    const SizedBox(height: 10),
                    _infoRow(
                      icon: Icons.discount_outlined,
                      label: 'Discount',
                      value: '${product.discountPercent.toStringAsFixed(0)}%',
                      valueColor: Colors.orange,
                    ),
                  ],

                  const SizedBox(height: 10),
                  _infoRow(
                    icon: Icons.inventory_2_outlined,
                    label: 'Stock',
                    value: '${product.stock} pcs',
                    valueColor: product.stock > product.minStock
                        ? Colors.green
                        : Colors.red,
                  ),

                  const SizedBox(height: 10),
                  _infoRow(
                    icon: Icons.warning_amber_outlined,
                    label: 'Min Stock',
                    value: '${product.minStock} pcs',
                  ),

                  const SizedBox(height: 10),
                  _infoRow(
                    icon: Icons.circle,
                    label: 'Status',
                    value: product.isActive == 1 ? 'Active' : 'Inactive',
                    valueColor:
                        product.isActive == 1 ? Colors.green : Colors.grey,
                    iconColor:
                        product.isActive == 1 ? Colors.green : Colors.grey,
                  ),

                  const SizedBox(height: 24),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroImage() {
    Widget imageWidget;

    if (kIsWeb && product.imageBytes != null && product.imageBytes!.isNotEmpty) {
      imageWidget = Image.memory(
        Uint8List.fromList(product.imageBytes!),
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _imageFallback(),
      );
    } else if (!kIsWeb &&
        product.imagePath != null &&
        product.imagePath!.isNotEmpty) {
      imageWidget = Image.file(
        File(product.imagePath!),
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _imageFallback(),
      );
    } else {
      imageWidget = _imageFallback();
    }

    return Container(
      height: 250,
      width: double.infinity,
      color: Colors.grey[100],
      child: imageWidget,
    );
  }

  Widget _imageFallback() {
    return Container(
      height: 250,
      color: Colors.grey[100],
      child: const Center(
        child: Icon(Icons.fastfood, size: 80, color: Colors.grey),
      ),
    );
  }

  Widget _infoRow({
    required IconData icon,
    required String label,
    required String value,
    Color? valueColor,
    Color? iconColor,
    bool bold = false,
  }) {
    return Row(
      children: [
        Icon(icon, size: 18, color: iconColor ?? Colors.grey[500]),
        const SizedBox(width: 10),
        Expanded(
          child: Text(label, style: TextStyle(color: Colors.grey[600])),
        ),
        Text(
          value,
          style: TextStyle(
            color: valueColor,
            fontWeight: bold ? FontWeight.bold : FontWeight.normal,
            fontSize: bold ? 16 : 14,
          ),
        ),
      ],
    );
  }
}
