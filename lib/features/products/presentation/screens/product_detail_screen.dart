import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_sizes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/providers/dummy_data.dart';
import '../../../../shared/providers/dummy_products.dart' as organized;
import '../../../../shared/widgets/app_button.dart';
import '../../../cart/presentation/providers/cart_provider.dart';
import '../../data/models/product_model.dart' as legacy;
import '../widgets/color_selector.dart';
import '../widgets/quantity_selector.dart';
import '../widgets/size_selector.dart';

class ProductDetailScreen extends ConsumerStatefulWidget {
  final String productId;

  const ProductDetailScreen({
    super.key,
    required this.productId,
  });

  @override
  ConsumerState<ProductDetailScreen> createState() =>
      _ProductDetailScreenState();
}

class _ProductDetailScreenState extends ConsumerState<ProductDetailScreen> {
  bool _isWishlisted = false;
  bool _isDescriptionExpanded = false;

  int _quantity = 1;
  String? _selectedColor;
  String? _selectedSize;
  String? _selectedStorage;

  legacy.ProductModel? get _legacyProduct {
    try {
      return DummyData.products.firstWhere(
        (product) => product.id == widget.productId,
      );
    } catch (_) {
      return null;
    }
  }

  organized.ProductModel? get _organizedProduct {
    try {
      return organized.dummyProducts.firstWhere(
        (product) => product.id == widget.productId,
      );
    } catch (_) {
      return null;
    }
  }

  _ProductViewData get _product {
    final legacyProduct = _legacyProduct;

    if (legacyProduct != null) {
      return _ProductViewData.fromLegacy(legacyProduct);
    }

    final organizedProduct = _organizedProduct;

    if (organizedProduct != null) {
      return _ProductViewData.fromOrganized(organizedProduct);
    }

    return _ProductViewData.fromLegacy(DummyData.products.first);
  }

  void _addToCart() {
    final legacyProduct = _legacyProduct;

    if (legacyProduct != null) {
      ref.read(cartProvider.notifier).addItem(
            legacyProduct,
            color: _selectedColor,
            size: _selectedSize,
            storage: _selectedStorage,
            quantity: _quantity,
          );

      _showSnackBar(
        message: 'Added to cart!',
        backgroundColor: AppColors.success,
      );
      return;
    }

    final organizedProduct = _organizedProduct;

    if (organizedProduct != null) {
      ref.read(cartProvider.notifier).addOrganizedItem(
            organizedProduct,
            color: _selectedColor,
            size: _selectedSize,
            storage: _selectedStorage,
            quantity: _quantity,
          );

      _showSnackBar(
        message: 'Added to cart!',
        backgroundColor: AppColors.success,
      );
      return;
    }

    _showSnackBar(
      message: 'Product not found.',
      backgroundColor: AppColors.error,
    );
  }

  void _showSnackBar({
    required String message,
    required Color backgroundColor,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: backgroundColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        ),
        margin: const EdgeInsets.all(AppSizes.md),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final product = _product;

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isTablet = screenWidth >= 600;

    final horizontalPadding =
        isTablet ? screenWidth * 0.08 : AppSizes.screenPadding;

    final imageHeight = isTablet ? screenHeight * 0.42 : screenHeight * 0.36;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          Expanded(
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverAppBar(
                  expandedHeight: imageHeight,
                  pinned: true,
                  backgroundColor: AppColors.background,
                  elevation: 1,
                  leading: Padding(
                    padding: const EdgeInsets.all(8),
                    child: GestureDetector(
                      onTap: () => context.pop(),
                      child: _circleIcon(Icons.arrow_back),
                    ),
                  ),
                  actions: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _isWishlisted = !_isWishlisted;
                        });
                      },
                      child: _circleIcon(
                        _isWishlisted ? Icons.favorite : Icons.favorite_outline,
                        color: _isWishlisted
                            ? AppColors.error
                            : AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: () {},
                      child: _circleIcon(Icons.share_outlined),
                    ),
                    const SizedBox(width: 8),
                  ],
                  flexibleSpace: FlexibleSpaceBar(
                    background: Container(
                      color: AppColors.surfaceLight,
                      child: product.isNetworkImage
                          ? Image.network(
                              product.imageUrl,
                              fit: BoxFit.contain,
                              errorBuilder: (_, __, ___) {
                                return const Center(
                                  child: Icon(
                                    Icons.image_outlined,
                                    size: 80,
                                    color: AppColors.textHint,
                                  ),
                                );
                              },
                            )
                          : Image.asset(
                              product.imageUrl,
                              fit: BoxFit.contain,
                              errorBuilder: (_, __, ___) {
                                return const Center(
                                  child: Icon(
                                    Icons.image_outlined,
                                    size: 80,
                                    color: AppColors.textHint,
                                  ),
                                );
                              },
                            ),
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(
                      horizontalPadding,
                      AppSizes.md,
                      horizontalPadding,
                      AppSizes.md,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildPriceRow(product, isTablet),
                        const SizedBox(height: AppSizes.sm),
                        Text(
                          product.name,
                          style: AppTextStyles.headingSmall.copyWith(
                            fontSize: isTablet ? 22 : 18,
                          ),
                        ),
                        const SizedBox(height: AppSizes.xs),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                product.brand,
                                style: AppTextStyles.bodyMedium.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(width: AppSizes.sm),
                            _stockBadge(product.inStock),
                          ],
                        ),
                        const SizedBox(height: AppSizes.sm),
                        _buildRatingRow(product, isTablet),
                        const Divider(height: AppSizes.xl),
                        if (product.colors.isNotEmpty) ...[
                          ColorSelector(
                            colors: product.colors,
                            selectedColor: _selectedColor,
                            onColorSelected: (color) {
                              setState(() {
                                _selectedColor = color;
                              });
                            },
                          ),
                          const SizedBox(height: AppSizes.md),
                        ],
                        if (product.storageOptions.isNotEmpty) ...[
                          SizeSelector(
                            sizes: product.storageOptions,
                            title: 'Storage',
                            selectedSize: _selectedStorage,
                            onSizeSelected: (storage) {
                              setState(() {
                                _selectedStorage = storage;
                              });
                            },
                          ),
                          const SizedBox(height: AppSizes.md),
                        ],
                        if (product.sizes.isNotEmpty) ...[
                          SizeSelector(
                            sizes: product.sizes,
                            title: 'Size',
                            selectedSize: _selectedSize,
                            onSizeSelected: (size) {
                              setState(() {
                                _selectedSize = size;
                              });
                            },
                          ),
                          const SizedBox(height: AppSizes.md),
                        ],
                        const Divider(height: AppSizes.xl),
                        Text(
                          'Description',
                          style: AppTextStyles.labelMedium,
                        ),
                        const SizedBox(height: AppSizes.sm),
                        Text(
                          product.description,
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.textSecondary,
                            height: 1.6,
                          ),
                          maxLines: _isDescriptionExpanded ? null : 3,
                          overflow: _isDescriptionExpanded
                              ? TextOverflow.visible
                              : TextOverflow.ellipsis,
                        ),
                        TextButton(
                          onPressed: () {
                            setState(() {
                              _isDescriptionExpanded = !_isDescriptionExpanded;
                            });
                          },
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: Text(
                            _isDescriptionExpanded ? 'show less' : 'show more',
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(height: AppSizes.xl),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(
              horizontalPadding,
              AppSizes.md,
              horizontalPadding,
              AppSizes.md + MediaQuery.of(context).padding.bottom,
            ),
            decoration: const BoxDecoration(
              color: AppColors.background,
              border: Border(
                top: BorderSide(color: AppColors.border),
              ),
            ),
            child: Row(
              children: [
                QuantitySelector(
                  initialQuantity: _quantity,
                  onQuantityChanged: (quantity) {
                    setState(() {
                      _quantity = quantity;
                    });
                  },
                ),
                const SizedBox(width: AppSizes.md),
                Expanded(
                  child: AppButton(
                    label: 'Add To Cart',
                    onPressed: _addToCart,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceRow(_ProductViewData product, bool isTablet) {
    return Row(
      children: [
        if (product.oldPrice != null) ...[
          Text(
            '\$${product.oldPrice!.toStringAsFixed(1)}',
            style: AppTextStyles.priceStrikethrough,
          ),
          const SizedBox(width: AppSizes.sm),
        ],
        Text(
          '\$${product.price.toStringAsFixed(1)}',
          style: AppTextStyles.priceStyle.copyWith(
            fontSize: isTablet ? 24 : 20,
          ),
        ),
      ],
    );
  }

  Widget _buildRatingRow(_ProductViewData product, bool isTablet) {
    return Row(
      children: [
        ...List.generate(
          5,
          (index) => Icon(
            index < product.rating.floor() ? Icons.star : Icons.star_border,
            color: Colors.amber,
            size: isTablet ? 20 : 16,
          ),
        ),
        const SizedBox(width: AppSizes.xs),
        Expanded(
          child: Text(
            '${product.rating.toStringAsFixed(1)} (${product.reviewCount} reviews)',
            style: AppTextStyles.caption,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _circleIcon(IconData icon, {Color? color}) {
    return Container(
      padding: const EdgeInsets.all(AppSizes.xs),
      decoration: BoxDecoration(
        color: AppColors.background,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 8,
          ),
        ],
      ),
      child: Icon(
        icon,
        color: color ?? AppColors.textPrimary,
        size: AppSizes.iconMd,
      ),
    );
  }

  Widget _stockBadge(bool inStock) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.sm,
        vertical: AppSizes.xs,
      ),
      decoration: BoxDecoration(
        color: inStock
            ? AppColors.success.withValues(alpha: 0.1)
            : AppColors.error.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppSizes.radiusXs),
      ),
      child: Text(
        inStock ? 'In Stock' : 'Out of Stock',
        style: AppTextStyles.caption.copyWith(
          color: inStock ? AppColors.success : AppColors.error,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _ProductViewData {
  const _ProductViewData({
    required this.id,
    required this.name,
    required this.brand,
    required this.imageUrl,
    required this.price,
    required this.oldPrice,
    required this.rating,
    required this.reviewCount,
    required this.inStock,
    required this.description,
    required this.colors,
    required this.sizes,
    required this.storageOptions,
    required this.isNetworkImage,
  });

  final String id;
  final String name;
  final String brand;
  final String imageUrl;
  final double price;
  final double? oldPrice;
  final double rating;
  final int reviewCount;
  final bool inStock;
  final String description;
  final List<String> colors;
  final List<String> sizes;
  final List<String> storageOptions;
  final bool isNetworkImage;

  factory _ProductViewData.fromLegacy(legacy.ProductModel product) {
    return _ProductViewData(
      id: product.id,
      name: product.name,
      brand: product.brand,
      imageUrl: product.imageUrl,
      price: product.discountPrice ?? product.price,
      oldPrice: product.discountPrice != null ? product.price : null,
      rating: product.rating,
      reviewCount: product.reviewCount,
      inStock: product.inStock,
      description: product.description ?? 'No description available.',
      colors: product.colors,
      sizes: product.sizes,
      storageOptions: product.storageOptions,
      isNetworkImage: product.imageUrl.startsWith('http'),
    );
  }

  factory _ProductViewData.fromOrganized(organized.ProductModel product) {
    final category = product.category.toLowerCase();

    final isElectronics = category == 'electronics';
    final isShoes = category == 'shoes';
    final isClothes = category == 'clothes';

    return _ProductViewData(
      id: product.id,
      name: product.name,
      brand: product.brand,
      imageUrl: product.imageUrl,
      price: product.price,
      oldPrice: product.oldPrice,
      rating: product.rating,
      reviewCount: product.reviews,
      inStock: true,
      description:
          '${product.name} by ${product.brand} is a premium ${product.category.toLowerCase()} product designed for style, comfort, and everyday use. It offers reliable quality, modern design, and great value for shoppers.',
      colors: const ['#000000', '#FFFFFF', '#2454D6'],
      sizes: isShoes
          ? const ['40', '41', '42', '43']
          : isClothes
              ? const ['S', 'M', 'L', 'XL']
              : const [],
      storageOptions:
          isElectronics ? const ['64GB', '128GB', '256GB'] : const [],
      isNetworkImage: true,
    );
  }
}
