import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_sizes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/providers/dummy_products.dart';

class BrandProductsScreen extends StatefulWidget {
  const BrandProductsScreen({
    super.key,
    required this.brandId,
  });

  final String brandId;

  @override
  State<BrandProductsScreen> createState() => _BrandProductsScreenState();
}

class _BrandProductsScreenState extends State<BrandProductsScreen> {
  String _sortBy = 'Popular';

  final List<String> _sortOptions = const [
    'Popular',
    'Price: Low to High',
    'Price: High to Low',
    'Discount',
    'Rating',
  ];

  String get brandName {
    switch (widget.brandId.toLowerCase()) {
      case 'brand_0':
      case 'beta':
        return 'Beta';

      case 'brand_1':
      case 'nike':
        return 'Nike';

      case 'brand_2':
      case 'hike':
        return 'Hike';

      case 'brand_3':
      case 'adidas':
        return 'Adidas';

      case 'apple':
        return 'Apple';

      case 'puma':
        return 'Puma';

      case 'zara':
        return 'Zara';

      case 'sony':
        return 'Sony';

      case 'samsung':
        return 'Samsung';

      default:
        return widget.brandId;
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
    final brandProducts = dummyProducts.where((product) {
      return product.brand.toLowerCase() == brandName.toLowerCase();
    }).toList();

    final products = _getSortedProducts(brandProducts);

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
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(
            Icons.arrow_back,
            color: AppColors.textPrimary,
          ),
        ),
        title: Text(
          brandName,
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
                            'No products available for $brandName.',
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
                      return _BrandProductCard(
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

class _BrandProductCard extends StatelessWidget {
  const _BrandProductCard({
    required this.product,
  });

  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    final hasOldPrice =
        product.oldPrice != null && product.oldPrice! > product.price;

    return Container(
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
                      borderRadius: BorderRadius.circular(AppSizes.radiusSm),
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
    );
  }
}
