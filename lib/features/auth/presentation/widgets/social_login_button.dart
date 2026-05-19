import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/constants/app_sizes.dart';

class SocialLoginButton extends StatelessWidget {
  final String iconPath;
  final VoidCallback onPressed;

  const SocialLoginButton({
    super.key,
    required this.iconPath,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final buttonSize = screenWidth >= 600 ? 64.0 : 52.0;

    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(AppSizes.radiusRound),
      child: Container(
        width: buttonSize,
        height: buttonSize,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.border, width: 1.5),
          color: AppColors.background,
        ),
        child: Center(
          child: Image.asset(
            iconPath,
            width: buttonSize * 0.5,
            height: buttonSize * 0.5,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}

class SocialLoginRow extends StatelessWidget {
  final VoidCallback onGooglePressed;
  final VoidCallback onFacebookPressed;
  final String label;

  const SocialLoginRow({
    super.key,
    required this.onGooglePressed,
    required this.onFacebookPressed,
    this.label = 'Or Sign In With',
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Divider with text
        Row(
          children: [
            const Expanded(
              child: Divider(color: AppColors.border, thickness: 1),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSizes.md),
              child: Text(
                label,
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ),
            const Expanded(
              child: Divider(color: AppColors.border, thickness: 1),
            ),
          ],
        ),

        const SizedBox(height: AppSizes.lg),

        // Social Buttons
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SocialLoginButton(
              iconPath: 'assets/icons/google.png',
              onPressed: onGooglePressed,
            ),
            const SizedBox(width: AppSizes.lg),
            SocialLoginButton(
              iconPath: 'assets/icons/facebook.png',
              onPressed: onFacebookPressed,
            ),
          ],
        ),
      ],
    );
  }
}
