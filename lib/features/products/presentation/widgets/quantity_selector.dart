import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/constants/app_sizes.dart';

class QuantitySelector extends StatefulWidget {
  final int initialQuantity;
  final int minQuantity;
  final int maxQuantity;
  final Function(int) onQuantityChanged;

  const QuantitySelector({
    super.key,
    this.initialQuantity = 1,
    this.minQuantity = 1,
    this.maxQuantity = 99,
    required this.onQuantityChanged,
  });

  @override
  State<QuantitySelector> createState() => _QuantitySelectorState();
}

class _QuantitySelectorState extends State<QuantitySelector> {
  late int _quantity;

  @override
  void initState() {
    super.initState();
    _quantity = widget.initialQuantity;
  }

  void _increment() {
    if (_quantity < widget.maxQuantity) {
      setState(() => _quantity++);
      widget.onQuantityChanged(_quantity);
    }
  }

  void _decrement() {
    if (_quantity > widget.minQuantity) {
      setState(() => _quantity--);
      widget.onQuantityChanged(_quantity);
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth >= 600;
    final buttonSize = isTablet ? 36.0 : 30.0;
    final fontSize = isTablet ? 18.0 : 16.0;

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.border, width: 1.5),
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Decrement Button
          GestureDetector(
            onTap: _decrement,
            child: Container(
              width: buttonSize,
              height: buttonSize,
              decoration: BoxDecoration(
                color: _quantity <= widget.minQuantity
                    ? AppColors.surfaceLight
                    : AppColors.primary,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(AppSizes.radiusMd - 2),
                  bottomLeft: Radius.circular(AppSizes.radiusMd - 2),
                ),
              ),
              child: Icon(
                Icons.remove,
                size: 16,
                color: _quantity <= widget.minQuantity
                    ? AppColors.textHint
                    : AppColors.textWhite,
              ),
            ),
          ),

          // Quantity Display
          Container(
            width: buttonSize + 8,
            height: buttonSize,
            color: AppColors.background,
            child: Center(
              child: Text(
                _quantity.toString(),
                style: AppTextStyles.labelMedium.copyWith(
                  fontSize: fontSize,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
          ),

          // Increment Button
          GestureDetector(
            onTap: _increment,
            child: Container(
              width: buttonSize,
              height: buttonSize,
              decoration: BoxDecoration(
                color: _quantity >= widget.maxQuantity
                    ? AppColors.surfaceLight
                    : AppColors.primary,
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(AppSizes.radiusMd - 2),
                  bottomRight: Radius.circular(AppSizes.radiusMd - 2),
                ),
              ),
              child: Icon(
                Icons.add,
                size: 16,
                color: _quantity >= widget.maxQuantity
                    ? AppColors.textHint
                    : AppColors.textWhite,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
