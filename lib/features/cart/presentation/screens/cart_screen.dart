import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../router/app_routes.dart';
import '../../../../shared/widgets/app_button.dart';
import '../providers/cart_provider.dart';
import '../widgets/cart_item_tile.dart';

class CartScreen extends ConsumerWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartItems = ref.watch(cartProvider);
    final cartTotal = ref.watch(cartTotalProvider);
    final sw = MediaQuery.of(context).size.width;
    final isTablet = sw >= 600;
    final hp = isTablet ? sw * 0.08 : AppSizes.screenPadding;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
        ),
        title: Text('Cart', style: AppTextStyles.headingSmall),
        actions: [
          if (cartItems.isNotEmpty)
            TextButton(
              onPressed: () => ref.read(cartProvider.notifier).clearCart(),
              child: Text(
                'Clear All',
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.error,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],
      ),
      body: cartItems.isEmpty
          ? _buildEmptyCart(context)
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: EdgeInsets.symmetric(
                      horizontal: hp,
                      vertical: AppSizes.md,
                    ),
                    physics: const BouncingScrollPhysics(),
                    itemCount: cartItems.length,
                    itemBuilder: (context, index) {
                      final item = cartItems[index];
                      return CartItemTile(
                        item: item,
                        onQuantityChanged: (qty) => ref
                            .read(cartProvider.notifier)
                            .updateQuantity(item.id, qty),
                        onRemove: () =>
                            ref.read(cartProvider.notifier).removeItem(item.id),
                      );
                    },
                  ),
                ),

                // Bottom Summary
                Container(
                  padding: EdgeInsets.fromLTRB(
                    hp,
                    AppSizes.md,
                    hp,
                    AppSizes.md + MediaQuery.of(context).padding.bottom,
                  ),
                  decoration: const BoxDecoration(
                    color: AppColors.background,
                    border: Border(top: BorderSide(color: AppColors.border)),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.shadow,
                        blurRadius: 10,
                        offset: Offset(0, -4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      _summaryRow(
                          'Subtotal', '\$${cartTotal.toStringAsFixed(0)}'),
                      const SizedBox(height: AppSizes.xs),
                      _summaryRow('Shipping Fee', '\$12'),
                      const Divider(height: AppSizes.lg),
                      _summaryRow(
                        'Order Total',
                        '\$${(cartTotal + 12).toStringAsFixed(0)}',
                        isBold: true,
                        isTablet: isTablet,
                      ),
                      const SizedBox(height: AppSizes.md),
                      AppButton(
                        label:
                            'Checkout \$${(cartTotal + 12).toStringAsFixed(0)}',
                        onPressed: () => context.push(AppRoutes.checkout),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  Widget _summaryRow(String label, String value,
      {bool isBold = false, bool isTablet = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: isBold
              ? AppTextStyles.labelMedium
              : AppTextStyles.bodyMedium
                  .copyWith(color: AppColors.textSecondary),
        ),
        Text(
          value,
          style: isBold
              ? AppTextStyles.priceStyle.copyWith(fontSize: isTablet ? 20 : 18)
              : AppTextStyles.labelMedium,
        ),
      ],
    );
  }

  Widget _buildEmptyCart(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.shopping_cart_outlined,
              size: 80, color: AppColors.textHint),
          const SizedBox(height: AppSizes.md),
          Text('Your cart is empty',
              style: AppTextStyles.headingSmall
                  .copyWith(color: AppColors.textSecondary)),
          const SizedBox(height: AppSizes.sm),
          Text('Add items to get started',
              style:
                  AppTextStyles.bodyMedium.copyWith(color: AppColors.textHint)),
          const SizedBox(height: AppSizes.xl),
          AppButton(
            label: 'Start Shopping',
            onPressed: () => context.go(AppRoutes.home),
            width: 200,
          ),
        ],
      ),
    );
  }
}
