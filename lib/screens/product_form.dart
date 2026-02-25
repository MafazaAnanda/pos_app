import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pos_app/widgets/app_drawer.dart';

class ProductForm extends StatefulWidget {
  const ProductForm({super.key});

  @override
  State<ProductForm> createState() => _ProductFormState();
}

class _ProductFormState extends State<ProductForm> {
  final _formKey = GlobalKey<FormState>();
  String _name = "";
  String _category = "";
  double _sellPrice = 0;
  double _costPrice = 0;
  int _stock = 0;
  int _minStock = 0;
  double _discountPercent = 0;
  String? _imagePath = ""; 

  final List<String> _categories = [
    'Appetizer',
    'Main Course',
    'Dessert',
    'Beverages',
    'Snack',
    'Deals',
  ];

  @override
  Widget build(BuildContext context) {
    Color primaryColor = Theme.of(context).primaryColor;

    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text('Add Product Form'),
        ),

        backgroundColor: Colors.white,
        foregroundColor: primaryColor,
      ),

      drawer: AppDrawer(),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // product name input
              Padding(
                padding: const EdgeInsets.all(8),
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Product Name',
                    hintText: 'Enter your product name...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),

                  onChanged: (String? value) {
                    setState(() {
                      _name = value!;
                    });
                  },

                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return "Product name can't be empty!";
                    } 

                    return null;
                  },
                ),
              ),

              // product sell price input
              Padding(
                padding: const EdgeInsets.all(8),
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Product Sell Price',
                    hintText: 'Enter your product sell price...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),

                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  onChanged: (String? value) {
                    setState(() {
                      _sellPrice = double.tryParse(value ?? '0') ?? 0.0;
                    });
                  },

                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return "Product sell price can't be empty!";
                    } 

                    final doubleValue = double.tryParse(value);
                    if (doubleValue == null || doubleValue <= 0) {
                      return "Product sell price can't be negative or zero!";
                    }

                    return null;
                  },
                ),
              ),

              // product cost price input
              Padding(
                padding: const EdgeInsets.all(8),
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Product Cost Price',
                    hintText: 'Enter your product cost price...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),

                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  onChanged: (String? value) {
                    setState(() {
                      _costPrice = double.tryParse(value ?? '0') ?? 0.0;
                    });
                  },

                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return "Product cost price can't be empty!";
                    } 

                    final doubleValue = double.tryParse(value);
                    if (doubleValue == null || doubleValue <= 0) {
                      return "Product cost price can't be negative or zero!";
                    }

                    return null;
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}