import 'package:flutter/material.dart';

import '../../../../core/constants/app_sizes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../data/models/cart_item_model.dart';

class CartItemTile extends StatelessWidget {
  final CartItemModel item;
  final Function(int) onQuantityChanged;
  final VoidCallback onRemove;

  const CartItemTile({
    super.key,
    required this.item,
    required this.onQuantityChanged,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final sw = MediaQuery.of(context).size.width;
    final isTablet = sw >= 600;
    final imageSize = isTablet ? 100.0 : 80.0;

    final unitPrice = item.product.discountPrice ?? item.product.price;
    final isNetworkImage = item.product.imageUrl.startsWith('http');

    return Container(
      margin: const EdgeInsets.only(bottom: AppSizes.md),
      padding: const EdgeInsets.all(AppSizes.sm),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(AppSizes.radiusSm),
            child: isNetworkImage
                ? Image.network(
                    item.product.imageUrl,
                    width: imageSize,
                    height: imageSize,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => _imagePlaceholder(imageSize),
                  )
                : Image.asset(
                    item.product.imageUrl,
                    width: imageSize,
                    height: imageSize,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => _imagePlaceholder(imageSize),
                  ),
          ),
          const SizedBox(width: AppSizes.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        item.product.name,
                        style: AppTextStyles.labelMedium.copyWith(
                          fontSize: isTablet ? 15 : 13,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    GestureDetector(
                      onTap: onRemove,
                      child: const Icon(
                        Icons.delete_outline,
                        color: AppColors.error,
                        size: 20,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSizes.xs),
                if (item.selectedColor != null)
                  Text(
                    'Color: ${item.selectedColor}',
                    style: AppTextStyles.caption,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                if (item.selectedSize != null)
                  Text(
                    'Size: ${item.selectedSize}',
                    style: AppTextStyles.caption,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                if (item.selectedStorage != null)
                  Text(
                    'Storage: ${item.selectedStorage}',
                    style: AppTextStyles.caption,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                const SizedBox(height: AppSizes.sm),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '\$${unitPrice.toStringAsFixed(0)}',
                      style: AppTextStyles.priceStyle.copyWith(
                        fontSize: isTablet ? 16 : 14,
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.border),
                        borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                      ),
                      child: Row(
                        children: [
                          _qtyButton(
                            icon: Icons.remove,
                            onTap: () => onQuantityChanged(item.quantity - 1),
                            isActive: item.quantity > 1,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSizes.sm,
                            ),
                            child: Text(
                              item.quantity.toString(),
                              style: AppTextStyles.labelMedium,
                            ),
                          ),
                          _qtyButton(
                            icon: Icons.add,
                            onTap: () => onQuantityChanged(item.quantity + 1),
                            isActive: true,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _imagePlaceholder(double imageSize) {
    return Container(
      width: imageSize,
      height: imageSize,
      color: AppColors.surfaceLight,
      child: const Icon(
        Icons.image_outlined,
        color: AppColors.textHint,
      ),
    );
  }

  Widget _qtyButton({
    required IconData icon,
    required VoidCallback onTap,
    required bool isActive,
  }) {
    return GestureDetector(
      onTap: isActive ? onTap : null,
      child: Container(
        padding: const EdgeInsets.all(AppSizes.xs),
        decoration: BoxDecoration(
          color: isActive ? AppColors.primary : AppColors.surfaceLight,
          borderRadius: BorderRadius.circular(AppSizes.radiusXs),
        ),
        child: Icon(
          icon,
          size: 14,
          color: isActive ? AppColors.textWhite : AppColors.textHint,
        ),
      ),
    );
  }
}
