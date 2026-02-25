import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pos_app/database/product_dao.dart';
import 'package:pos_app/models/product.dart';
import 'package:pos_app/widgets/app_drawer.dart';

class ProductForm extends StatefulWidget {
  const ProductForm({super.key});

  @override
  State<ProductForm> createState() => _ProductFormState();
}

class _ProductFormState extends State<ProductForm> {
  final _formKey = GlobalKey<FormState>();
  final ProductDao _productDao = ProductDao();
  final ImagePicker _imagePicker = ImagePicker();
  
  String _name = "";
  String _category = "";
  double _sellPrice = 0;
  double _costPrice = 0;
  int _stock = 0;
  int _minStock = 0;
  double _discountPercent = 0;
  String? _imagePath = "";
  Uint8List? _imageBytes;
  bool _isFavorite = true;
  String _description = "";
  final List<String> _categories = [
    'Appetizer',
    'Main Course',
    'Dessert',
    'Beverages',
    'Snack',
    'Deals',
  ];

  Future<void> _pickImage() async {
    final XFile? pickedFile = await _imagePicker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 512,
    );

    if (pickedFile != null) {
      if (kIsWeb) {
        final bytes = await pickedFile.readAsBytes();
        setState(() {
          _imageBytes = bytes;
          _imagePath = pickedFile.name;
        });
      } else {
        setState(() {
          _imagePath = pickedFile.path;
          _imageBytes = null;
        });
      }
    }
  }

  Widget _buildImagePreview() {
    if (kIsWeb && _imageBytes != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(6),
        child: Image.memory(_imageBytes!, fit: BoxFit.cover, width: double.infinity),
      );
    } else if (!kIsWeb && _imagePath != null && _imagePath!.isNotEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(6),
        child: Image.file(File(_imagePath!), fit: BoxFit.cover, width: double.infinity),
      );
    }
    return const Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.add_a_photo, size: 40, color: Colors.grey),
        Text('Tap to add product image', style: TextStyle(color: Colors.grey)),
      ],
    );
  }

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

              // product photo input
              Padding(
                padding: const EdgeInsets.all(8),
                child: GestureDetector(
                  onTap: _pickImage,
                  child: Container(
                    height: 150,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(6),
                    ),

                    child: _buildImagePreview(),
                  ),
                ),
              ),
              
              // product name input
              Padding(
                padding: const EdgeInsets.all(8),
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Product Name',
                    hintText: 'Enter product name...',
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

              // product description input
              Padding(
                padding: const EdgeInsets.all(8),
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Description',
                    hintText: 'Enter your product description...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  
                  maxLines: 3,
                  onChanged: (String? value) {
                    setState(() {
                      _description = value!;
                    });
                  },

                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return "Product description can't be empty!";
                    } 

                    return null;
                  },
                ),
              ),

              // product category input
              Padding(
                padding: const EdgeInsets.all(8),
                child: DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: 'Category',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),

                  items: _categories.map((String category) {
                    return DropdownMenuItem<String>(
                      value: category,
                      child: Text(category),
                    );
                  }).toList(),
                  onChanged: (String? value) {
                    setState(() {
                      _category = value!;
                    });
                  },

                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return "Please select a category!";
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
                    labelText: 'Sell Price',
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
                    labelText: 'Cost Price',
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

              // product stock input 
              Padding(
                padding: const EdgeInsets.all(8),
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Stock',
                    hintText: 'Enter your product stock amount...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),

                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  onChanged: (String? value) {
                    setState(() {
                      _stock = int.tryParse(value ?? '0') ?? 0;
                    });
                  },

                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return "Product stock can't be empty!";
                    } 

                    final intValue = int.tryParse(value);
                    if (intValue == null || intValue < 0) {
                      return "Product stock can't be negative!";
                    }

                    return null;
                  },
                ),
              ),

              // product min stock input 
              Padding(
                padding: const EdgeInsets.all(8),
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Min Stock',
                    hintText: 'Enter your product min stock amount...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),

                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  onChanged: (String? value) {
                    setState(() {
                      _minStock = int.tryParse(value ?? '0') ?? 0;
                    });
                  },

                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return "Product min stock can't be empty!";
                    } 

                    final intValue = int.tryParse(value);
                    if (intValue == null || intValue < 0) {
                      return "Product min stock can't be negative!";
                    }

                    return null;
                  },
                ),
              ),

              // product discount percent input 
              Padding(
                padding: const EdgeInsets.all(8),
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Discount Percent',
                    hintText: 'Enter your product discount percent...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),

                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  onChanged: (String? value) {
                    setState(() {
                      _discountPercent = double.tryParse(value ?? '0') ?? 0.0;
                    });
                  },

                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return "Product discount percent can't be empty!";
                    } 

                    final doubleValue = double.tryParse(value);
                    if (doubleValue == null || doubleValue < 0) {
                      return "Product discount percent can't be negative!";
                    }

                    return null;
                  },
                ),
              ),

              // product is favorite input 
              Padding(
                padding: const EdgeInsets.all(8),
                child: SwitchListTile(
                  title: const Text('Favorite'),
                  subtitle: const Text('Mark this product as favorite'),
                  value: _isFavorite,
                  onChanged: (bool value) {
                    setState(() {
                      _isFavorite = value;
                    });
                  },
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(8),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6)),
                    ),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        final product = Product(
                          name: _name,
                          category: _category,
                          sellPrice: _sellPrice,
                          costPrice: _costPrice,
                          stock: _stock,
                          minStock: _minStock,
                          discountPercent: _discountPercent,
                          isFavorite: _isFavorite ? 1 : 0,
                          isActive: 1,
                          description: _description,
                          imagePath: _imagePath, 
                          createdAt: DateTime.now().toIso8601String(),
                        );

                        try {
                          await _productDao.createProduct(product);
                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Product successfully added!')),
                            );
                            Navigator.pop(context);
                          }
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Error: $e')),
                          );
                        }
                      }
                    },

                    child: const Text('SAVE PRODUCT',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}