class Product {
  final int? id;
  final String name, category, description;
  final double sellPrice, costPrice, discountPercent;
  final int stock, minStock, isActive, isFavorite;
  final String? imagePath, createdAt, updatedAt;
  final List<int>? imageBytes;

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
    this.isFavorite = 1,
    this.description = '',
    this.imagePath,
    this.imageBytes,
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
      isFavorite: map['is_favorite'] as int,
      description: map['description'] as String,
      imagePath: map['image_path'] as String?,
      imageBytes: map['image_bytes'] != null
          ? List<int>.from(map['image_bytes'] as List)
          : null,
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
      'is_favorite': isFavorite,
      'description': description,
      'image_path': imagePath,
      if (imageBytes != null) 'image_bytes': imageBytes,
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
    int? isFavorite,
    String? description,
    String? imagePath,
    List<int>? imageBytes,
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
      isFavorite: isFavorite ?? this.isFavorite,
      description: description ?? this.description,
      imagePath: imagePath ?? this.imagePath,
      imageBytes: imageBytes ?? this.imageBytes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}