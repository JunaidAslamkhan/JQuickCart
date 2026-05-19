import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../router/app_routes.dart';
import '../../../../shared/widgets/app_button.dart';

class EmailSentScreen extends StatelessWidget {
  final String email;

  const EmailSentScreen({super.key, required this.email});

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
        child: Stack(
          children: [
            // Close Button
            Positioned(
              top: AppSizes.sm,
              right: AppSizes.sm,
              child: IconButton(
                onPressed: () => context.go(AppRoutes.login),
                icon: const Icon(Icons.close),
                color: AppColors.textPrimary,
              ),
            ),

            // Content
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: horizontalPadding,
                vertical: AppSizes.lg,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Illustration
                  Image.asset(
                    'assets/images/email_sent.png',
                    height: screenHeight * 0.28,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) => Icon(
                      Icons.mark_email_read_outlined,
                      size: screenHeight * 0.2,
                      color: AppColors.primary,
                    ),
                  ),

                  SizedBox(height: screenHeight * 0.04),

                  // Title
                  Text(
                    'Password Reset Email Sent',
                    style: AppTextStyles.headingMedium,
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: AppSizes.md),

                  // Email
                  Text(
                    email,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: AppSizes.sm),

                  Text(
                    "We've sent a password reset link to your email. Please check your inbox and follow the instructions to reset your password",
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  SizedBox(height: screenHeight * 0.05),

                  // Done Button
                  AppButton(
                    label: 'Done',
                    onPressed: () => context.go(AppRoutes.login),
                  ),

                  const SizedBox(height: AppSizes.md),

                  // Resend Email
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      'Resend Email',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
