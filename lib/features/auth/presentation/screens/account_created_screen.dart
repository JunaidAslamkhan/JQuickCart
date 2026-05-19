import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../router/app_routes.dart';
import '../../../../shared/widgets/app_button.dart';

class AccountCreatedScreen extends StatelessWidget {
  const AccountCreatedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isTablet = screenWidth >= 600;
    final horizontalPadding =
        isTablet ? screenWidth * 0.15 : AppSizes.screenPadding;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: horizontalPadding,
            vertical: AppSizes.lg,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),

              // Illustration
              Image.asset(
                'assets/images/account_created.png',
                height: screenHeight * 0.28,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) => Icon(
                  Icons.check_circle_outline,
                  size: screenHeight * 0.2,
                  color: AppColors.success,
                ),
              ),

              SizedBox(height: screenHeight * 0.04),

              // Title
              Text(
                'Your account successfully created',
                style: AppTextStyles.headingMedium,
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: AppSizes.md),

              Text(
                "Congratulations! Your account has been successfully created. You can now explore all the amazing features, start personalizing your experience, and enjoy seamless access to our services. Let's get started!",
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),

              const Spacer(),

              // Continue Button
              AppButton(
                label: 'Continue',
                onPressed: () => context.go(AppRoutes.home),
              ),

              const SizedBox(height: AppSizes.lg),
            ],
          ),
        ),
      ),
    );
  }
}
