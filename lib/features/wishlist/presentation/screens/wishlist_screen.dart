import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../router/app_routes.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/product_card.dart';
import '../providers/wishlist_provider.dart';

class WishlistScreen extends ConsumerWidget {
  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wishlistItems = ref.watch(wishlistProvider);
    final sw = MediaQuery.of(context).size.width;
    final isTablet = sw >= 600;
    final hp = isTablet ? sw * 0.05 : AppSizes.screenPadding;
    final crossAxisCount = isTablet ? 3 : 2;
    final childAspectRatio = isTablet ? 0.70 : 0.62;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text('Wishlist', style: AppTextStyles.headingSmall),
        actions: [
          if (wishlistItems.isNotEmpty)
            TextButton(
              onPressed: () =>
                  ref.read(wishlistProvider.notifier).clearWishlist(),
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
      body: wishlistItems.isEmpty
          ? _buildEmptyWishlist(context)
          : Padding(
              padding: EdgeInsets.symmetric(
                horizontal: hp,
                vertical: AppSizes.md,
              ),
              child: GridView.builder(
                physics: const BouncingScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  crossAxisSpacing: AppSizes.md,
                  mainAxisSpacing: AppSizes.md,
                  childAspectRatio: childAspectRatio,
                ),
                itemCount: wishlistItems.length,
                itemBuilder: (context, index) {
                  final product = wishlistItems[index];
                  return ProductCard(
                    product: product,
                    isWishlisted: true,
                    onWishlistToggle: () => ref
                        .read(wishlistProvider.notifier)
                        .removeItem(product.id),
                  );
                },
              ),
            ),
    );
  }

  Widget _buildEmptyWishlist(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.favorite_outline,
              size: 80, color: AppColors.textHint),
          const SizedBox(height: AppSizes.md),
          Text(
            'Your wishlist is empty',
            style: AppTextStyles.headingSmall
                .copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: AppSizes.sm),
          Text(
            'Save items you love here',
            style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textHint),
          ),
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
