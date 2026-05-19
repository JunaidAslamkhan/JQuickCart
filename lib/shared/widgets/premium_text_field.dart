import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/theme/app_colors_premium.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/constants/app_sizes.dart';

/// Premium TextFormField with animations and micro-interactions
class PremiumTextField extends StatefulWidget {
  final String hintText;
  final TextEditingController? controller;
  final bool isPassword;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool readOnly;
  final VoidCallback? onTap;
  final void Function(String)? onChanged;
  final int? maxLines;
  final TextInputAction? textInputAction;
  final FocusNode? focusNode;
  final String? labelText;
  final bool showLabel;

  const PremiumTextField({
    super.key,
    required this.hintText,
    this.controller,
    this.isPassword = false,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.prefixIcon,
    this.suffixIcon,
    this.readOnly = false,
    this.onTap,
    this.onChanged,
    this.maxLines = 1,
    this.textInputAction,
    this.focusNode,
    this.labelText,
    this.showLabel = false,
  });

  @override
  State<PremiumTextField> createState() => _PremiumTextFieldState();
}

class _PremiumTextFieldState extends State<PremiumTextField> {
  bool _obscureText = true;
  bool _isFocused = false;
  late FocusNode _internalFocusNode;

  @override
  void initState() {
    super.initState();
    _internalFocusNode = widget.focusNode ?? FocusNode();
    _internalFocusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    if (widget.focusNode == null) {
      _internalFocusNode.dispose();
    } else {
      _internalFocusNode.removeListener(_onFocusChange);
    }
    super.dispose();
  }

  void _onFocusChange() {
    setState(() {
      _isFocused = _internalFocusNode.hasFocus;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.showLabel) ...[
          Text(
            widget.labelText ?? widget.hintText,
            style: AppTextStyles.labelMedium.copyWith(
              color: _isFocused
                  ? AppColorsPremium.primary
                  : AppColorsPremium.textSecondary,
              fontWeight: FontWeight.w600,
            ),
          ).animate().fadeIn(duration: 200.ms),
          const SizedBox(height: AppSizes.sm),
        ],
        Material(
          color: Colors.transparent,
          child: TextFormField(
            controller: widget.controller,
            obscureText: widget.isPassword ? _obscureText : false,
            keyboardType: widget.keyboardType,
            validator: widget.validator,
            readOnly: widget.readOnly,
            onTap: widget.onTap,
            onChanged: widget.onChanged,
            maxLines: widget.isPassword ? 1 : widget.maxLines,
            textInputAction: widget.textInputAction,
            focusNode: _internalFocusNode,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColorsPremium.textPrimary,
              letterSpacing: 0.3,
            ),
            decoration: InputDecoration(
              hintText: widget.hintText,
              hintStyle: AppTextStyles.bodyMedium.copyWith(
                color: AppColorsPremium.textHint,
                letterSpacing: 0.2,
              ),
              prefixIcon: widget.prefixIcon != null
                  ? Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSizes.sm,
                      ),
                      child: AnimatedScale(
                        scale: _isFocused ? 1.1 : 1.0,
                        duration: const Duration(milliseconds: 200),
                        child: widget.prefixIcon,
                      ),
                    )
                  : null,
              prefixIconConstraints: const BoxConstraints(
                minWidth: 48,
                minHeight: 48,
              ),
              suffixIcon: widget.isPassword
                  ? Padding(
                      padding: const EdgeInsets.only(right: AppSizes.sm),
                      child: GestureDetector(
                        onTap: () {
                          setState(() => _obscureText = !_obscureText);
                        },
                        child: AnimatedScale(
                          scale: 1.0,
                          duration: const Duration(milliseconds: 200),
                          child: Icon(
                            _obscureText
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            color: _isFocused
                                ? AppColorsPremium.primary
                                : AppColorsPremium.textSecondary,
                            size: AppSizes.iconMd,
                          ),
                        ),
                      ),
                    )
                  : widget.suffixIcon,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: AppSizes.md,
                vertical: AppSizes.md,
              ),
              filled: true,
              fillColor: _isFocused
                  ? AppColorsPremium.primaryLighter
                  : AppColorsPremium.surfaceLight,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                borderSide: BorderSide(
                  color: AppColorsPremium.border,
                  width: 1.5,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                borderSide: BorderSide(
                  color: AppColorsPremium.divider,
                  width: 1,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                borderSide: const BorderSide(
                  color: AppColorsPremium.primary,
                  width: 2,
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                borderSide: const BorderSide(
                  color: AppColorsPremium.error,
                  width: 1.5,
                ),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                borderSide: const BorderSide(
                  color: AppColorsPremium.error,
                  width: 2,
                ),
              ),
              errorStyle: AppTextStyles.labelMedium.copyWith(
                color: AppColorsPremium.error,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
