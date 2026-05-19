import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors_premium.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/constants/app_sizes.dart';
import '../../features/products/data/models/product_model.dart';
import '../../features/wishlist/presentation/providers/wishlist_provider.dart';
import '../../router/app_routes.dart';

class ProductCard extends ConsumerStatefulWidget {
  final ProductModel product;
  final bool isWishlisted;
  final VoidCallback? onWishlistToggle;

  const ProductCard({
    super.key,
    required this.product,
    this.isWishlisted = false,
    this.onWishlistToggle,
  });

  @override
  ConsumerState<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends ConsumerState<ProductCard> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final isWishlistedState =
        ref.watch(isWishlistedProvider(widget.product.id));
    final sw = MediaQuery.of(context).size.width;
    final isTablet = sw >= 600;
    final imageHeight = isTablet ? 160.0 : AppSizes.productImageHeight;
    final salePrice = widget.product.discountPrice ?? widget.product.price;
    final hasDiscount = widget.product.discountPrice != null &&
        widget.product.discountPrice! < widget.product.price;

    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      onTap: () => context.push(AppRoutes.productDetailPath(widget.product.id)),
      child: AnimatedScale(
        scale: _isPressed ? 0.975 : 1.0,
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeOut,
        child: Container(
          decoration: BoxDecoration(
            color: AppColorsPremium.surfaceLight,
            borderRadius: BorderRadius.circular(AppSizes.radiusMd),
            border: Border.all(
              color: AppColorsPremium.divider,
              width: 1,
            ),
            boxShadow: AppColorsPremium.elevatedShadow,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(AppSizes.radiusMd),
                  topRight: Radius.circular(AppSizes.radiusMd),
                ),
                child: Stack(
                  children: [
                    SizedBox(
                      height: imageHeight,
                      width: double.infinity,
                      child: Image.asset(
                        widget.product.imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          color: AppColorsPremium.background,
                          child: const Center(
                            child: Icon(
                              Icons.image_outlined,
                              color: AppColorsPremium.textHint,
                              size: 40,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              AppColorsPremium.background.withAlpha(64),
                            ],
                          ),
                        ),
                      ),
                    ),
                    if (widget.product.discountPercent != null)
                      Positioned(
                        top: AppSizes.xs,
                        left: AppSizes.xs,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: AppSizes.sm, vertical: AppSizes.xs),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Color(0xFFEF4444),
                                Color(0xFFDC2626),
                              ],
                            ),
                            borderRadius:
                                BorderRadius.circular(AppSizes.radiusXs),
                            boxShadow: AppColorsPremium.premiumShadow,
                          ),
                          child: Text(
                            '-${widget.product.discountPercent}% ',
                            style: AppTextStyles.caption.copyWith(
                              color: AppColorsPremium.textWhite,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    Positioned(
                      top: AppSizes.xs,
                      right: AppSizes.xs,
                      child: GestureDetector(
                        onTap: () {
                          ref
                              .read(wishlistProvider.notifier)
                              .toggleWishlist(widget.product);
                          widget.onWishlistToggle?.call();
                        },
                        child: AnimatedScale(
                          scale: isWishlistedState ? 1.05 : 1.0,
                          duration: const Duration(milliseconds: 200),
                          child: Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              color: AppColorsPremium.background,
                              borderRadius:
                                  BorderRadius.circular(AppSizes.radiusRound),
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
              ),
              Padding(
                padding: const EdgeInsets.all(AppSizes.sm),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.product.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColorsPremium.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: AppSizes.xs),
                    Text(
                      widget.product.brand,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColorsPremium.textSecondary,
                      ),
                    ),
                    const SizedBox(height: AppSizes.sm),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '\$${salePrice.toStringAsFixed(2)}',
                          style: AppTextStyles.priceStyle.copyWith(
                            color: AppColorsPremium.primary,
                            fontSize: isTablet ? 18 : 16,
                          ),
                        ),
                        if (hasDiscount) ...[
                          const SizedBox(width: AppSizes.sm),
                          Text(
                            '\$${widget.product.price.toStringAsFixed(2)}',
                            style: AppTextStyles.priceStrikethrough.copyWith(
                              fontSize: isTablet ? 12 : 10,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ).animate().fadeIn(duration: 450.ms);
  }
}
