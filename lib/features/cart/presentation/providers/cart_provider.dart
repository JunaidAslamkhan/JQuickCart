import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/providers/dummy_products.dart' as organized;
import '../../data/models/cart_item_model.dart';
import '../../../products/data/models/product_model.dart';

class CartNotifier extends StateNotifier<List<CartItemModel>> {
  CartNotifier() : super([]);

  void addItem(
    ProductModel product, {
    String? color,
    String? size,
    String? storage,
    int quantity = 1,
  }) {
    final existingIndex = state.indexWhere(
      (item) =>
          item.product.id == product.id &&
          item.selectedColor == color &&
          item.selectedSize == size &&
          item.selectedStorage == storage,
    );

    if (existingIndex != -1) {
      final updated = List<CartItemModel>.from(state);

      updated[existingIndex] = updated[existingIndex].copyWith(
        quantity: updated[existingIndex].quantity + quantity,
      );

      state = updated;
      return;
    }

    state = [
      ...state,
      CartItemModel(
        id: '${product.id}_${color}_${size}_${storage}_${DateTime.now().millisecondsSinceEpoch}',
        product: product,
        quantity: quantity,
        selectedColor: color,
        selectedSize: size,
        selectedStorage: storage,
      ),
    ];
  }

  void addOrganizedItem(
    organized.ProductModel product, {
    String? color,
    String? size,
    String? storage,
    int quantity = 1,
  }) {
    final convertedProduct = _convertOrganizedProduct(product);

    addItem(
      convertedProduct,
      color: color,
      size: size,
      storage: storage,
      quantity: quantity,
    );
  }

  ProductModel _convertOrganizedProduct(organized.ProductModel product) {
    final hasDiscount =
        product.oldPrice != null && product.oldPrice! > product.price;

    final isElectronics = product.category.toLowerCase() == 'electronics';
    final isShoes = product.category.toLowerCase() == 'shoes';
    final isClothes = product.category.toLowerCase() == 'clothes';

    return ProductModel(
      id: product.id,
      name: product.name,
      brand: product.brand,
      price: hasDiscount ? product.oldPrice! : product.price,
      discountPrice: hasDiscount ? product.price : null,
      imageUrl: product.imageUrl,
      images: [product.imageUrl],
      category: product.category,
      categoryId: product.category.toLowerCase(),
      brandId: product.brand.toLowerCase(),
      inStock: true,
      rating: product.rating,
      reviewCount: product.reviews,
      description:
          '${product.name} by ${product.brand} is a premium ${product.category.toLowerCase()} product designed for style, comfort, and everyday use.',
      colors: const ['#000000', '#FFFFFF', '#2454D6'],
      sizes: isShoes
          ? const ['40', '41', '42', '43']
          : isClothes
              ? const ['S', 'M', 'L', 'XL']
              : const [],
      storageOptions:
          isElectronics ? const ['64GB', '128GB', '256GB'] : const [],
      discountPercent: product.discount,
    );
  }

  void removeItem(String itemId) {
    state = state.where((item) => item.id != itemId).toList();
  }

  void updateQuantity(String itemId, int quantity) {
    if (quantity <= 0) {
      removeItem(itemId);
      return;
    }

    state = state.map((item) {
      if (item.id == itemId) {
        return item.copyWith(quantity: quantity);
      }

      return item;
    }).toList();
  }

  void clearCart() {
    state = [];
  }
}

final cartProvider = StateNotifierProvider<CartNotifier, List<CartItemModel>>(
  (ref) => CartNotifier(),
);

final cartTotalProvider = Provider<double>((ref) {
  return ref.watch(cartProvider).fold(
        0,
        (sum, item) => sum + item.totalPrice,
      );
});

final cartItemCountProvider = Provider<int>((ref) {
  return ref.watch(cartProvider).fold(
        0,
        (sum, item) => sum + item.quantity,
      );
});
