import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../products/data/models/product_model.dart';

class WishlistNotifier extends StateNotifier<List<ProductModel>> {
  WishlistNotifier() : super([]);

  void toggleWishlist(ProductModel product) {
    final exists = state.any((p) => p.id == product.id);
    if (exists) {
      state = state.where((p) => p.id != product.id).toList();
    } else {
      state = [...state, product];
    }
  }

  void removeItem(String productId) {
    state = state.where((p) => p.id != productId).toList();
  }

  void clearWishlist() => state = [];
}

final wishlistProvider =
    StateNotifierProvider<WishlistNotifier, List<ProductModel>>(
  (ref) => WishlistNotifier(),
);

final isWishlistedProvider = Provider.family<bool, String>((ref, productId) {
  return ref.watch(wishlistProvider).any((p) => p.id == productId);
});
