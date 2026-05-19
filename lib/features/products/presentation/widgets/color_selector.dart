import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/constants/app_sizes.dart';

class ColorSelector extends StatefulWidget {
  final List<String> colors;
  final String? selectedColor;
  final Function(String) onColorSelected;

  const ColorSelector({
    super.key,
    required this.colors,
    this.selectedColor,
    required this.onColorSelected,
  });

  @override
  State<ColorSelector> createState() => _ColorSelectorState();
}

class _ColorSelectorState extends State<ColorSelector> {
  late String? _selectedColor;

  final Map<String, Color> _colorMap = {
    'Black': Colors.black,
    'White': Colors.white,
    'Blue': const Color(0xFF1D4ED8),
    'Red': Colors.red,
    'Green': Colors.green,
    'Yellow': Colors.yellow,
    'Pink': Colors.pink,
    'Purple': Colors.purple,
    'Orange': Colors.orange,
    'Grey': Colors.grey,
    'Brown': Colors.brown,
  };

  @override
  void initState() {
    super.initState();
    _selectedColor = widget.selectedColor ??
        (widget.colors.isNotEmpty ? widget.colors.first : null);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Color',
          style: AppTextStyles.labelMedium,
        ),
        const SizedBox(height: AppSizes.sm),
        Wrap(
          spacing: AppSizes.sm,
          children: widget.colors.map((color) {
            final isSelected = _selectedColor == color;
            final colorValue = _colorMap[color] ?? AppColors.primary;

            return GestureDetector(
              onTap: () {
                setState(() => _selectedColor = color);
                widget.onColorSelected(color);
              },
              child: Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: colorValue,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected ? AppColors.primary : AppColors.border,
                    width: isSelected ? 2.5 : 1,
                  ),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: AppColors.primary.withOpacity(0.3),
                            blurRadius: 6,
                            spreadRadius: 1,
                          )
                        ]
                      : null,
                ),
                child: isSelected
                    ? Icon(
                        Icons.check,
                        size: 16,
                        color: color == 'White'
                            ? AppColors.textPrimary
                            : AppColors.textWhite,
                      )
                    : null,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
