import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors_premium.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/constants/app_sizes.dart';
import '../../features/products/data/models/product_model.dart';
import '../../features/wishlist/presentation/providers/wishlist_provider.dart';
import '../../router/app_routes.dart';

/// Premium product card with animations, shadows, and modern styling
class PremiumProductCard extends ConsumerStatefulWidget {
  final ProductModel product;
  final bool isWishlisted;
  final VoidCallback? onWishlistToggle;

  const PremiumProductCard({
    super.key,
    required this.product,
    this.isWishlisted = false,
    this.onWishlistToggle,
  });

  @override
  ConsumerState<PremiumProductCard> createState() => _PremiumProductCardState();
}

class _PremiumProductCardState extends ConsumerState<PremiumProductCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _hoverController;

  @override
  void initState() {
    super.initState();
    _hoverController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _hoverController.dispose();
    super.dispose();
  }

  void _onHover(bool isHovered) {
    isHovered ? _hoverController.forward() : _hoverController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final isWishlistedState =
        ref.watch(isWishlistedProvider(widget.product.id));
    final sw = MediaQuery.of(context).size.width;
    final isTablet = sw >= 600;
    final imageHeight = isTablet ? 150.0 : AppSizes.productImageHeight;

    final salePrice = widget.product.discountPrice ?? widget.product.price;
    final hasDiscount = widget.product.discountPrice != null &&
        widget.product.discountPrice! < widget.product.price;

    return GestureDetector(
      onTap: () => context.push(AppRoutes.productDetailPath(widget.product.id)),
      child: MouseRegion(
        onEnter: (_) => _onHover(true),
        onExit: (_) => _onHover(false),
        child: AnimatedBuilder(
          animation: _hoverController,
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(0, -8 * _hoverController.value),
              child: Container(
                decoration: BoxDecoration(
                  color: AppColorsPremium.background,
                  borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                  boxShadow: [
                    BoxShadow(
                      color: AppColorsPremium.textPrimary.withAlpha(
                        (20 + (20 * _hoverController.value)).round(),
                      ),
                      blurRadius: 8 + (8 * _hoverController.value),
                      offset: Offset(0, 2 + (4 * _hoverController.value)),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Product Image Stack
                    Stack(
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(AppSizes.radiusMd),
                            topRight: Radius.circular(AppSizes.radiusMd),
                          ),
                          child: Container(
                            height: imageHeight,
                            width: double.infinity,
                            color: AppColorsPremium.surfaceLight,
                            child: Image.asset(
                              widget.product.imageUrl,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => const Center(
                                child: Icon(
                                  Icons.image_outlined,
                                  color: AppColorsPremium.textHint,
                                  size: 40,
                                ),
                              ),
                            ),
                          ),
                        ),

                        // Discount Badge - Premium styling
                        if (widget.product.discountPercent != null)
                          Positioned(
                            top: AppSizes.xs,
                            left: AppSizes.xs,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    AppColorsPremium.error,
                                    AppColorsPremium.error
                                        .withValues(alpha: 204),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(
                                  AppSizes.radiusSm,
                                ),
                                boxShadow: AppColorsPremium.premiumShadow,
                              ),
                              child: Text(
                                '-${widget.product.discountPercent}%',
                                style: AppTextStyles.labelMedium.copyWith(
                                  color: AppColorsPremium.textWhite,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),

                        // Wishlist Button - Animated
                        Positioned(
                          top: AppSizes.xs,
                          right: AppSizes.xs,
                          child: GestureDetector(
                            onTap: widget.onWishlistToggle,
                            child: AnimatedScale(
                              scale: isWishlistedState ? 1.15 : 1.0,
                              duration: const Duration(milliseconds: 300),
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: const BoxDecoration(
                                  color: AppColorsPremium.textWhite,
                                  shape: BoxShape.circle,
                                  boxShadow: AppColorsPremium.premiumShadow,
                                ),
                                child: Icon(
                                  isWishlistedState
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  color: isWishlistedState
                                      ? AppColorsPremium.error
                                      : AppColorsPremium.textSecondary,
                                  size: 18,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    // Product Info
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(AppSizes.md),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Brand/Category
                            Text(
                              widget.product.brand,
                              style: AppTextStyles.labelMedium.copyWith(
                                color: AppColorsPremium.textSecondary,
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(height: 4),

                            // Product Name
                            Text(
                              widget.product.name,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: AppTextStyles.labelMedium.copyWith(
                                color: AppColorsPremium.textPrimary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const Spacer(),

                            // Rating
                            if (widget.product.rating > 0) ...[
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.star_rounded,
                                    color: AppColorsPremium.warning,
                                    size: 16,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    '${widget.product.rating}',
                                    style: AppTextStyles.labelMedium.copyWith(
                                      color: AppColorsPremium.textPrimary,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ],

                            // Price
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Text(
                                  '\$${salePrice.toStringAsFixed(2)}',
                                  style: AppTextStyles.labelMedium.copyWith(
                                    color: AppColorsPremium.primary,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 14,
                                  ),
                                ),
                                if (hasDiscount) ...[
                                  const SizedBox(width: 6),
                                  Text(
                                    '\$${widget.product.price.toStringAsFixed(2)}',
                                    style: AppTextStyles.labelMedium.copyWith(
                                      color: AppColorsPremium.textSecondary,
                                      decoration: TextDecoration.lineThrough,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
