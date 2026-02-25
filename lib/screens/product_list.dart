import 'package:flutter/material.dart';
import 'package:pos_app/database/product_dao.dart';
import 'package:pos_app/formatter/currency_formatter.dart';
import 'package:pos_app/models/product.dart';
import 'package:pos_app/widgets/app_drawer.dart';

class ProductList extends StatefulWidget {
  const ProductList({super.key});

  @override
  State<ProductList> createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  final ProductDao _productDao = ProductDao();
  List<Product> _products = [];

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    final products = await _productDao.getAllProducts();
    setState(() {
      _products = products;
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Menu'),
      ),

      drawer: const AppDrawer(),
      body: _products.isEmpty
          ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.inventory_2_outlined),
                Text('No Menu Yet!')
              ],
            ),
          )
          : ListView.builder(
            itemCount: _products.length,
            itemBuilder: (context, index) {
              final product = _products[index];
              return Card(
                margin: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 7,
                ),
                child: ListTile(
                  leading: product.isFavorite == 1
                      ? const Icon(Icons.favorite, color: Colors.red)
                      : const Icon(Icons.favorite_border),
                  title: Text(product.name),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(product.category),
                      if (product.description.isNotEmpty)
                        Text(
                          product.description,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                    ],
                  ),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        CurrencyFormatter.convertToIdr(product.sellPrice, 0),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        product.stock > 0 ? 'Available' : 'Not Available',
                        style: TextStyle(
                          color: product.stock > 0 ? Colors.green : Colors.red,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),

          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.pushNamed(context, 'product_form').then((_) {
                _loadProducts();
              });
            },
            child: const Icon(Icons.add),
          ),
    );
  }
}