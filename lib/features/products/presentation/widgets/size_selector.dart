import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/constants/app_sizes.dart';

class SizeSelector extends StatefulWidget {
  final List<String> sizes;
  final String title;
  final String? selectedSize;
  final Function(String) onSizeSelected;

  const SizeSelector({
    super.key,
    required this.sizes,
    this.title = 'Size',
    this.selectedSize,
    required this.onSizeSelected,
  });

  @override
  State<SizeSelector> createState() => _SizeSelectorState();
}

class _SizeSelectorState extends State<SizeSelector> {
  late String? _selectedSize;

  @override
  void initState() {
    super.initState();
    _selectedSize = widget.selectedSize ??
        (widget.sizes.isNotEmpty ? widget.sizes.first : null);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth >= 600;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.title,
          style: AppTextStyles.labelMedium,
        ),
        const SizedBox(height: AppSizes.sm),
        Wrap(
          spacing: AppSizes.sm,
          runSpacing: AppSizes.sm,
          children: widget.sizes.map((size) {
            final isSelected = _selectedSize == size;
            return GestureDetector(
              onTap: () {
                setState(() => _selectedSize = size);
                widget.onSizeSelected(size);
              },
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: isTablet ? AppSizes.md : AppSizes.sm + 4,
                  vertical: isTablet ? AppSizes.sm : AppSizes.xs + 2,
                ),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primary : AppColors.background,
                  borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                  border: Border.all(
                    color: isSelected ? AppColors.primary : AppColors.border,
                    width: 1.5,
                  ),
                ),
                child: Text(
                  size,
                  style: AppTextStyles.labelSmall.copyWith(
                    color: isSelected
                        ? AppColors.textWhite
                        : AppColors.textPrimary,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                    fontSize: isTablet ? 14 : 12,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
