class CategoryModel {
  final String id;
  final String name;
  final String iconUrl;
  final int productCount;

  const CategoryModel({
    required this.id,
    required this.name,
    required this.iconUrl,
    this.productCount = 0,
  });

  factory CategoryModel.fromMap(Map<String, dynamic> map, String id) {
    return CategoryModel(
      id: id,
      name: map['name'] ?? '',
      iconUrl: map['iconUrl'] ?? '',
      productCount: map['productCount'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'iconUrl': iconUrl,
      'productCount': productCount,
    };
  }
}
