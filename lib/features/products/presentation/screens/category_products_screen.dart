import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_sizes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../router/app_routes.dart';
import '../../../../shared/providers/dummy_products.dart';

class CategoryProductsScreen extends StatefulWidget {
  const CategoryProductsScreen({
    super.key,
    required this.categoryId,
  });

  final String categoryId;

  @override
  State<CategoryProductsScreen> createState() => _CategoryProductsScreenState();
}

class _CategoryProductsScreenState extends State<CategoryProductsScreen> {
  String _sortBy = 'Popular';

  final List<String> _sortOptions = const [
    'Popular',
    'Price: Low to High',
    'Price: High to Low',
    'Discount',
    'Rating',
  ];

  String get categoryName {
    switch (widget.categoryId.toLowerCase()) {
      case 'furniture':
      case '0':
      case 'cat_0':
      case 'category_0':
        return 'Furniture';

      case 'electronics':
      case 'electronic':
      case '1':
      case 'cat_1':
      case 'category_1':
        return 'Electronics';

      case 'clothes':
      case 'cloth':
      case '2':
      case 'cat_2':
      case 'category_2':
        return 'Clothes';

      case 'shoes':
      case 'shoe':
      case '3':
      case 'cat_3':
      case 'category_3':
        return 'Shoes';

      default:
        return widget.categoryId;
    }
  }

  List<ProductModel> _getSortedProducts(List<ProductModel> products) {
    final sortedProducts = [...products];

    switch (_sortBy) {
      case 'Price: Low to High':
        sortedProducts.sort((a, b) => a.price.compareTo(b.price));
        break;

      case 'Price: High to Low':
        sortedProducts.sort((a, b) => b.price.compareTo(a.price));
        break;

      case 'Discount':
        sortedProducts.sort((a, b) => b.discount.compareTo(a.discount));
        break;

      case 'Rating':
        sortedProducts.sort((a, b) => b.rating.compareTo(a.rating));
        break;

      case 'Popular':
      default:
        sortedProducts.sort((a, b) => b.reviews.compareTo(a.reviews));
        break;
    }

    return sortedProducts;
  }

  @override
  Widget build(BuildContext context) {
    final categoryProducts = productsByCategory(categoryName);
    final products = _getSortedProducts(categoryProducts);

    final sw = MediaQuery.of(context).size.width;
    final isTablet = sw >= 600;
    final hp = isTablet ? sw * 0.05 : AppSizes.screenPadding;
    final crossAxisCount = isTablet ? 3 : 2;

    // Smaller aspect ratio = taller cards, helps avoid RenderFlex overflow.
    final childAspectRatio = isTablet ? 0.68 : 0.54;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(
            Icons.arrow_back,
            color: AppColors.textPrimary,
          ),
        ),
        title: Text(
          categoryName,
          style: AppTextStyles.headingSmall,
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: hp,
              vertical: AppSizes.md,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${products.length} Products',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSizes.md,
                    vertical: AppSizes.xs,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.border),
                    borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _sortBy,
                      isDense: true,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textPrimary,
                      ),
                      icon: const Icon(
                        Icons.keyboard_arrow_down,
                        size: 18,
                        color: AppColors.textSecondary,
                      ),
                      items: _sortOptions.map((option) {
                        return DropdownMenuItem(
                          value: option,
                          child: Text(option),
                        );
                      }).toList(),
                      onChanged: (value) {
                        if (value == null) return;

                        setState(() {
                          _sortBy = value;
                        });
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: products.isEmpty
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(AppSizes.xl),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.inventory_2_outlined,
                            size: 80,
                            color: AppColors.textHint,
                          ),
                          const SizedBox(height: AppSizes.md),
                          Text(
                            'No products found',
                            style: AppTextStyles.headingSmall.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                          const SizedBox(height: AppSizes.sm),
                          Text(
                            'No products available in $categoryName.',
                            textAlign: TextAlign.center,
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : GridView.builder(
                    padding: EdgeInsets.symmetric(
                      horizontal: hp,
                      vertical: AppSizes.sm,
                    ),
                    physics: const BouncingScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      crossAxisSpacing: AppSizes.md,
                      mainAxisSpacing: AppSizes.md,
                      childAspectRatio: childAspectRatio,
                    ),
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      return _CategoryProductCard(
                        product: products[index],
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class _CategoryProductCard extends StatelessWidget {
  const _CategoryProductCard({
    required this.product,
  });

  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    final hasOldPrice =
        product.oldPrice != null && product.oldPrice! > product.price;

    return InkWell(
      onTap: () {
        context.push(AppRoutes.productDetailPath(product.id));
      },
      borderRadius: BorderRadius.circular(AppSizes.radiusMd),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(AppSizes.radiusMd),
          border: Border.all(color: AppColors.border),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Image.network(
                  product.imageUrl,
                  height: 145,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 145,
                      width: double.infinity,
                      color: Colors.grey.shade200,
                      child: const Icon(
                        Icons.image_not_supported_outlined,
                        color: AppColors.textSecondary,
                      ),
                    );
                  },
                ),
                if (product.discount > 0)
                  Positioned(
                    top: AppSizes.sm,
                    left: AppSizes.sm,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSizes.sm,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.error,
                        borderRadius: BorderRadius.circular(
                          AppSizes.radiusSm,
                        ),
                      ),
                      child: Text(
                        '-${product.discount}%',
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.textWhite,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                Positioned(
                  top: AppSizes.sm,
                  right: AppSizes.sm,
                  child: InkWell(
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('${product.name} added to wishlist'),
                          backgroundColor: AppColors.primary,
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              AppSizes.radiusMd,
                            ),
                          ),
                          margin: const EdgeInsets.all(AppSizes.md),
                        ),
                      );
                    },
                    borderRadius: BorderRadius.circular(100),
                    child: Container(
                      width: 34,
                      height: 34,
                      decoration: BoxDecoration(
                        color: AppColors.background.withValues(alpha: 0.9),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.favorite_border,
                        size: 20,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(AppSizes.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      style: AppTextStyles.labelMedium,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      product.brand,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: AppSizes.sm),
                    Row(
                      children: [
                        Text(
                          '\$${product.price.toStringAsFixed(1)}',
                          style: AppTextStyles.headingSmall.copyWith(
                            color: AppColors.primary,
                          ),
                        ),
                        if (hasOldPrice) ...[
                          const SizedBox(width: AppSizes.xs),
                          Expanded(
                            child: Text(
                              '\$${product.oldPrice!.toStringAsFixed(1)}',
                              style: AppTextStyles.bodySmall.copyWith(
                                color: AppColors.textSecondary,
                                decoration: TextDecoration.lineThrough,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ],
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        const Icon(
                          Icons.star,
                          size: 16,
                          color: Colors.amber,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          product.rating.toStringAsFixed(1),
                          style: AppTextStyles.caption,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            '(${product.reviews})',
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.textSecondary,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
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
  }
}
