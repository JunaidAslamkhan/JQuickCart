import 'package:flutter/material.dart';
import '../../core/theme/app_colors_premium.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/constants/app_sizes.dart';

enum PremiumButtonType { primary, secondary, outlined, ghost }

class PremiumButton extends StatefulWidget {
  final String label;
  final VoidCallback? onPressed;
  final PremiumButtonType type;
  final bool isLoading;
  final double? width;
  final double? height;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool isFullWidth;

  const PremiumButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.type = PremiumButtonType.primary,
    this.isLoading = false,
    this.width,
    this.height,
    this.prefixIcon,
    this.suffixIcon,
    this.isFullWidth = true,
  });

  @override
  State<PremiumButton> createState() => _PremiumButtonState();
}

class _PremiumButtonState extends State<PremiumButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final buttonHeight = widget.height ?? AppSizes.buttonHeight;
    final buttonWidth = widget.isFullWidth
        ? widget.width ?? double.infinity
        : widget.width ?? 150;

    return GestureDetector(
      onTapDown: (_) {
        if (widget.onPressed != null && !widget.isLoading) {
          setState(() => _isPressed = true);
        }
      },
      onTapUp: (_) {
        setState(() => _isPressed = false);
      },
      onTapCancel: () {
        setState(() => _isPressed = false);
      },
      child: AnimatedScale(
        scale: _isPressed ? 0.95 : 1.0,
        duration: const Duration(milliseconds: 150),
        child: _buildButton(buttonWidth, buttonHeight),
      ),
    );
  }

  Widget _buildButton(double width, double height) {
    switch (widget.type) {
      case PremiumButtonType.primary:
        return _PrimaryButton(
          width: width,
          height: height,
          label: widget.label,
          onPressed: widget.onPressed,
          isLoading: widget.isLoading,
          prefixIcon: widget.prefixIcon,
          suffixIcon: widget.suffixIcon,
        );

      case PremiumButtonType.secondary:
        return _SecondaryButton(
          width: width,
          height: height,
          label: widget.label,
          onPressed: widget.onPressed,
          isLoading: widget.isLoading,
          prefixIcon: widget.prefixIcon,
          suffixIcon: widget.suffixIcon,
        );

      case PremiumButtonType.outlined:
        return _OutlinedButton(
          width: width,
          height: height,
          label: widget.label,
          onPressed: widget.onPressed,
          isLoading: widget.isLoading,
          prefixIcon: widget.prefixIcon,
          suffixIcon: widget.suffixIcon,
        );

      case PremiumButtonType.ghost:
        return _GhostButton(
          width: width,
          height: height,
          label: widget.label,
          onPressed: widget.onPressed,
          isLoading: widget.isLoading,
          prefixIcon: widget.prefixIcon,
          suffixIcon: widget.suffixIcon,
        );
    }
  }
}

class _PrimaryButton extends StatelessWidget {
  final double width;
  final double height;
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final Widget? prefixIcon;
  final Widget? suffixIcon;

  const _PrimaryButton({
    required this.width,
    required this.height,
    required this.label,
    required this.onPressed,
    required this.isLoading,
    this.prefixIcon,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        gradient: AppColorsPremium.primaryGradient,
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        boxShadow: isLoading ? [] : AppColorsPremium.elevatedShadow,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isLoading ? null : onPressed,
          borderRadius: BorderRadius.circular(AppSizes.radiusMd),
          splashColor: AppColorsPremium.textWhite.withValues(alpha: 0.2),
          highlightColor: AppColorsPremium.textWhite.withValues(alpha: 0.1),
          child: Center(
            child: isLoading
                ? SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        AppColorsPremium.textWhite,
                      ),
                      strokeWidth: 2.5,
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (prefixIcon != null) ...[
                        prefixIcon!,
                        const SizedBox(width: AppSizes.sm),
                      ],
                      Text(
                        label,
                        style: AppTextStyles.buttonText.copyWith(
                          color: AppColorsPremium.textWhite,
                          letterSpacing: 0.5,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      if (suffixIcon != null) ...[
                        const SizedBox(width: AppSizes.sm),
                        suffixIcon!,
                      ],
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}

class _SecondaryButton extends StatelessWidget {
  final double width;
  final double height;
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final Widget? prefixIcon;
  final Widget? suffixIcon;

  const _SecondaryButton({
    required this.width,
    required this.height,
    required this.label,
    required this.onPressed,
    required this.isLoading,
    this.prefixIcon,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: AppColorsPremium.secondary,
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        boxShadow: isLoading ? [] : AppColorsPremium.premiumShadow,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isLoading ? null : onPressed,
          borderRadius: BorderRadius.circular(AppSizes.radiusMd),
          splashColor: AppColorsPremium.textWhite.withValues(alpha: 0.2),
          child: Center(
            child: isLoading
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      valueColor:
                          AlwaysStoppedAnimation<Color>(Colors.white),
                      strokeWidth: 2.5,
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (prefixIcon != null) ...[
                        prefixIcon!,
                        const SizedBox(width: AppSizes.sm),
                      ],
                      Text(
                        label,
                        style: AppTextStyles.buttonText.copyWith(
                          color: AppColorsPremium.textWhite,
                          letterSpacing: 0.5,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      if (suffixIcon != null) ...[
                        const SizedBox(width: AppSizes.sm),
                        suffixIcon!,
                      ],
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}

class _OutlinedButton extends StatelessWidget {
  final double width;
  final double height;
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final Widget? prefixIcon;
  final Widget? suffixIcon;

  const _OutlinedButton({
    required this.width,
    required this.height,
    required this.label,
    required this.onPressed,
    required this.isLoading,
    this.prefixIcon,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.transparent,
        border: Border.all(
          color: AppColorsPremium.primary,
          width: 1.5,
        ),
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isLoading ? null : onPressed,
          borderRadius: BorderRadius.circular(AppSizes.radiusMd),
          splashColor: AppColorsPremium.primary.withValues(alpha: 0.1),
          child: Center(
            child: isLoading
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        AppColorsPremium.primary,
                      ),
                      strokeWidth: 2.5,
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (prefixIcon != null) ...[
                        prefixIcon!,
                        const SizedBox(width: AppSizes.sm),
                      ],
                      Text(
                        label,
                        style: AppTextStyles.labelMedium.copyWith(
                          color: AppColorsPremium.primary,
                          letterSpacing: 0.5,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      if (suffixIcon != null) ...[
                        const SizedBox(width: AppSizes.sm),
                        suffixIcon!,
                      ],
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}

class _GhostButton extends StatelessWidget {
  final double width;
  final double height;
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final Widget? prefixIcon;
  final Widget? suffixIcon;

  const _GhostButton({
    required this.width,
    required this.height,
    required this.label,
    required this.onPressed,
    required this.isLoading,
    this.prefixIcon,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: AppColorsPremium.surfaceLight,
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isLoading ? null : onPressed,
          borderRadius: BorderRadius.circular(AppSizes.radiusMd),
          splashColor: AppColorsPremium.primary.withOpacity(0.1),
          child: Center(
            child: isLoading
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        AppColorsPremium.primary,
                      ),
                      strokeWidth: 2.5,
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (prefixIcon != null) ...[
                        prefixIcon!,
                        const SizedBox(width: AppSizes.sm),
                      ],
                      Text(
                        label,
                        style: AppTextStyles.labelMedium.copyWith(
                          color: AppColorsPremium.primary,
                          letterSpacing: 0.5,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      if (suffixIcon != null) ...[
                        const SizedBox(width: AppSizes.sm),
                        suffixIcon!,
                      ],
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
