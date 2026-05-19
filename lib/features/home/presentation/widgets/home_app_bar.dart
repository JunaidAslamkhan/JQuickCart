import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../router/app_routes.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String userName;

  const HomeAppBar({super.key, this.userName = 'Unknown Pro'});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth >= 600;

    return AppBar(
      backgroundColor: AppColors.primary,
      elevation: 0,
      automaticallyImplyLeading: false,
      titleSpacing: AppSizes.sm,
      title: Row(
        children: [
          // App Logo
          Container(
            width: isTablet ? 48 : 40,
            height: isTablet ? 48 : 40,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppSizes.radiusMd),
              color: AppColors.textWhite.withOpacity(0.1),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(AppSizes.radiusMd),
              child: Image.asset(
                'assets/icons/jquickcart_icon.png',
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: AppSizes.sm),
          // Brand Name & Greeting
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Good Morning',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textWhite.withOpacity(0.8),
                    fontSize: isTablet ? 12 : 10,
                  ),
                ),
                Text(
                  userName,
                  style: AppTextStyles.headingSmall.copyWith(
                    color: AppColors.textWhite,
                    fontSize: isTablet ? 16 : 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      actions: [
        // Notification Icon
        IconButton(
          onPressed: () {},
          icon: Stack(
            children: [
              const Icon(
                Icons.notifications_outlined,
                color: AppColors.textWhite,
                size: AppSizes.iconMd,
              ),
              Positioned(
                right: 0,
                top: 0,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: AppColors.error,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
        ),
        // Cart Icon
        IconButton(
          onPressed: () => context.push(AppRoutes.cart),
          icon: Stack(
            children: [
              const Icon(
                Icons.shopping_cart_outlined,
                color: AppColors.textWhite,
                size: AppSizes.iconMd,
              ),
              Positioned(
                right: 0,
                top: 0,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: AppColors.error,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: AppSizes.sm),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(AppSizes.appBarHeight);
}
