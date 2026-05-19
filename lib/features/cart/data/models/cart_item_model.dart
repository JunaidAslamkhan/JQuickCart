import '../../../products/data/models/product_model.dart';

class CartItemModel {
  final String id;
  final ProductModel product;
  int quantity;
  final String? selectedColor;
  final String? selectedSize;
  final String? selectedStorage;

  CartItemModel({
    required this.id,
    required this.product,
    this.quantity = 1,
    this.selectedColor,
    this.selectedSize,
    this.selectedStorage,
  });

  double get totalPrice => (product.discountPrice ?? product.price) * quantity;

  CartItemModel copyWith({
    String? id,
    ProductModel? product,
    int? quantity,
    String? selectedColor,
    String? selectedSize,
    String? selectedStorage,
  }) {
    return CartItemModel(
      id: id ?? this.id,
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
      selectedColor: selectedColor ?? this.selectedColor,
      selectedSize: selectedSize ?? this.selectedSize,
      selectedStorage: selectedStorage ?? this.selectedStorage,
    );
  }
}
