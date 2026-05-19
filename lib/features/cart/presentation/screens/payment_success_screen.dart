import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../router/app_routes.dart';
import '../../../../shared/widgets/app_button.dart';

class PaymentSuccessScreen extends StatelessWidget {
  const PaymentSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final sw = MediaQuery.of(context).size.width;
    final sh = MediaQuery.of(context).size.height;
    final isTablet = sw >= 600;
    final hp = isTablet ? sw * 0.15 : AppSizes.screenPadding;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: hp),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),

              // Success Icon
              Container(
                width: sh * 0.18,
                height: sh * 0.18,
                decoration: BoxDecoration(
                  color: AppColors.success.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.check_circle_rounded,
                  color: AppColors.success,
                  size: sh * 0.12,
                ),
              ),

              SizedBox(height: sh * 0.04),

              // Title
              Text(
                'Payment Success!',
                style: AppTextStyles.headingLarge.copyWith(
                  fontSize: isTablet ? 28 : 24,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: AppSizes.md),

              Text(
                'Your order has been placed successfully. You will receive a confirmation email shortly.',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                  height: 1.6,
                ),
                textAlign: TextAlign.center,
              ),

              const Spacer(),

              // Continue Shopping Button
              AppButton(
                label: 'Continue Shopping',
                onPressed: () => context.go(AppRoutes.home),
              ),

              const SizedBox(height: AppSizes.md),

              // View Orders Button
              AppButton(
                label: 'View My Orders',
                type: ButtonType.outlined,
                onPressed: () => context.go(AppRoutes.myOrders),
              ),

              const SizedBox(height: AppSizes.xl),
            ],
          ),
        ),
      ),
    );
  }
}
