import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/constants/app_sizes.dart';

class OnboardingPage extends StatelessWidget {
  final String imagePath;
  final String title;
  final String subtitle;

  const OnboardingPage({
    super.key,
    required this.imagePath,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.screenPadding),
      child: Column(
        children: [
          // Image Section
          Expanded(
            flex: 6,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: AppSizes.xl),
              child: Image.asset(
                imagePath,
                fit: BoxFit.contain,
                width: size.width * 0.8,
              ).animate().fadeIn(duration: 500.ms),
            ),
          ),

          // Text Section
          Expanded(
            flex: 4,
            child: Column(
              children: [
                Text(
                  title,
                  style: AppTextStyles.headingLarge,
                  textAlign: TextAlign.center,
                ).animate().fadeIn(duration: 450.ms, delay: 100.ms),
                const SizedBox(height: AppSizes.sm),
                Text(
                  subtitle,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ).animate().fadeIn(duration: 450.ms, delay: 150.ms),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
