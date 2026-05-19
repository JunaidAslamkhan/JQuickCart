class ProductModel {
  final String id;
  final String name;
  final String brand;
  final double price;
  final double? discountPrice;
  final String imageUrl;
  final List<String> images;
  final String category;
  final String? categoryId;
  final String? brandId;
  final bool inStock;
  final double rating;
  final int reviewCount;
  final String? description;
  final List<String> colors;
  final List<String> sizes;
  final List<String> storageOptions;
  final int? discountPercent;

  const ProductModel({
    required this.id,
    required this.name,
    required this.brand,
    required this.price,
    this.discountPrice,
    required this.imageUrl,
    this.images = const [],
    required this.category,
    this.categoryId,
    this.brandId,
    this.inStock = true,
    this.rating = 0.0,
    this.reviewCount = 0,
    this.description,
    this.colors = const [],
    this.sizes = const [],
    this.storageOptions = const [],
    this.discountPercent,
  });

  factory ProductModel.fromMap(Map<String, dynamic> map, String id) {
    return ProductModel(
      id: id,
      name: map['name'] ?? '',
      brand: map['brand'] ?? '',
      price: (map['price'] ?? 0).toDouble(),
      discountPrice: map['discountPrice'] != null
          ? (map['discountPrice']).toDouble()
          : null,
      imageUrl: map['imageUrl'] ?? '',
      images: List<String>.from(map['images'] ?? []),
      category: map['category'] ?? '',
      categoryId: map['categoryId'],
      brandId: map['brandId'],
      inStock: map['inStock'] ?? true,
      rating: (map['rating'] ?? 0).toDouble(),
      reviewCount: map['reviewCount'] ?? 0,
      description: map['description'],
      colors: List<String>.from(map['colors'] ?? []),
      sizes: List<String>.from(map['sizes'] ?? []),
      storageOptions: List<String>.from(map['storageOptions'] ?? []),
      discountPercent: map['discountPercent'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'brand': brand,
      'price': price,
      'discountPrice': discountPrice,
      'imageUrl': imageUrl,
      'images': images,
      'category': category,
      'categoryId': categoryId,
      'brandId': brandId,
      'inStock': inStock,
      'rating': rating,
      'reviewCount': reviewCount,
      'description': description,
      'colors': colors,
      'sizes': sizes,
      'storageOptions': storageOptions,
      'discountPercent': discountPercent,
    };
  }

  ProductModel copyWith({
    String? id,
    String? name,
    String? brand,
    double? price,
    double? discountPrice,
    String? imageUrl,
    List<String>? images,
    String? category,
    String? categoryId,
    String? brandId,
    bool? inStock,
    double? rating,
    int? reviewCount,
    String? description,
    List<String>? colors,
    List<String>? sizes,
    List<String>? storageOptions,
    int? discountPercent,
  }) {
    return ProductModel(
      id: id ?? this.id,
      name: name ?? this.name,
      brand: brand ?? this.brand,
      price: price ?? this.price,
      discountPrice: discountPrice ?? this.discountPrice,
      imageUrl: imageUrl ?? this.imageUrl,
      images: images ?? this.images,
      category: category ?? this.category,
      categoryId: categoryId ?? this.categoryId,
      brandId: brandId ?? this.brandId,
      inStock: inStock ?? this.inStock,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      description: description ?? this.description,
      colors: colors ?? this.colors,
      sizes: sizes ?? this.sizes,
      storageOptions: storageOptions ?? this.storageOptions,
      discountPercent: discountPercent ?? this.discountPercent,
    );
  }
}
