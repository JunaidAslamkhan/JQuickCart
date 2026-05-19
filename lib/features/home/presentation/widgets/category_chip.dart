import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../products/data/models/category_model.dart';

// ignore: must_be_immutable
class CategoryChipWidget extends StatelessWidget {
  final CategoryModel category;
  final bool isSelected;
  final VoidCallback onTap;

  const CategoryChipWidget({
    super.key,
    required this.category,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth >= 600;
    final chipSize = isTablet ? 72.0 : 60.0;
    final iconSize = isTablet ? 36.0 : 30.0;
    final fontSize = isTablet ? 13.0 : 11.0;

    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Icon Container
          Container(
            width: chipSize,
            height: chipSize,
            decoration: BoxDecoration(
              color: isSelected ? AppColors.primary : AppColors.surfaceLight,
              borderRadius: BorderRadius.circular(AppSizes.radiusMd),
              border: Border.all(
                color: isSelected ? AppColors.primary : AppColors.border,
                width: 1,
              ),
            ),
            child: Center(
              child: Image.asset(
                category.iconUrl,
                width: iconSize,
                height: iconSize,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) => Icon(
                  Icons.category_outlined,
                  size: iconSize,
                  color: isSelected
                      ? AppColors.textWhite
                      : AppColors.textSecondary,
                ),
              ),
            ),
          ),
          const SizedBox(height: AppSizes.xs),
          // Category Name
          Text(
            category.name,
            style: AppTextStyles.caption.copyWith(
              fontSize: fontSize,
              color: isSelected
                  ? AppColors.primary
                  : const Color.fromARGB(255, 248, 248, 248),
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
