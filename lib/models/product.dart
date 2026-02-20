class Product {
  final int? id;
  final String name, category;
  final double sellPrice, costPrice, discountPercent;
  final int stock, minStock, isActive;
  final String? imagePath, createdAt, updatedAt;

  Product({
    this.id,
    required this.name,
    required this.category,
    required this.sellPrice,
    required this.costPrice,
    required this.stock,
    this.minStock = 0,
    this.discountPercent = 0,
    this.isActive = 1,
    this.imagePath,
    this.createdAt,
    this.updatedAt,
  });

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'] as int?,
      name: map['name'] as String,
      category: map['category'] as String,
      sellPrice: (map['sell_price'] as num).toDouble(),
      costPrice: (map['cost_price'] as num).toDouble(),
      stock: map['stock'] as int,
      minStock: map['min_stock'] as int,
      discountPercent: (map['discount_percent'] as num).toDouble(),
      isActive: map['is_active'] as int,
      imagePath: map['image_path'] as String?,
      createdAt: map['created_at'] as String?,
      updatedAt: map['updated_at'] as String?,
    );
  }
  
  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'name': name,
      'category': category,
      'sell_price': sellPrice,
      'cost_price': costPrice,
      'stock': stock,
      'min_stock': minStock,
      'discount_percent': discountPercent,
      'is_active': isActive,
      'image_path': imagePath,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }

  Product copyWith({
    int? id,
    String? name,
    String? category,
    double? sellPrice,
    double? costPrice,
    int? stock,
    int? minStock,
    double? discountPercent,
    int? isActive,
    String? imagePath,
    String? createdAt,
    String? updatedAt,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      sellPrice: sellPrice ?? this.sellPrice,
      costPrice: costPrice ?? this.costPrice,
      stock: stock ?? this.stock,
      minStock: minStock ?? this.minStock,
      discountPercent: discountPercent ?? this.discountPercent,
      isActive: isActive ?? this.isActive,
      imagePath: imagePath ?? this.imagePath,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}