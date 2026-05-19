import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../router/app_routes.dart';
import '../../../auth/presentation/providers/auth_controller.dart';
import '../providers/profile_provider.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(currentUserProfileProvider);

    final sw = MediaQuery.of(context).size.width;
    final isTablet = sw >= 600;
    final hp = isTablet ? sw * 0.08 : AppSizes.screenPadding;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: profileAsync.when(
        loading: () {
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
        error: (error, stackTrace) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(AppSizes.lg),
              child: Text(
                'Failed to load profile. Please try again.',
                textAlign: TextAlign.center,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.error,
                ),
              ),
            ),
          );
        },
        data: (profile) {
          if (profile == null) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(AppSizes.lg),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.person_off_outlined,
                      size: 60,
                      color: AppColors.textSecondary,
                    ),
                    const SizedBox(height: AppSizes.md),
                    Text(
                      'No profile found. Please login again.',
                      textAlign: TextAlign.center,
                      style: AppTextStyles.bodyMedium,
                    ),
                    const SizedBox(height: AppSizes.md),
                    ElevatedButton(
                      onPressed: () => context.go(AppRoutes.login),
                      child: const Text('Go to Login'),
                    ),
                  ],
                ),
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(currentUserProfileProvider);
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    color: AppColors.primary,
                    padding: EdgeInsets.only(
                      top: MediaQuery.of(context).padding.top + AppSizes.md,
                      bottom: AppSizes.xl,
                      left: hp,
                      right: hp,
                    ),
                    child: Column(
                      children: [
                        Stack(
                          children: [
                            Container(
                              width: AppSizes.avatarXl,
                              height: AppSizes.avatarXl,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.primaryLight,
                                border: Border.all(
                                  color: AppColors.textWhite,
                                  width: 3,
                                ),
                              ),
                              child: const Icon(
                                Icons.person,
                                size: 50,
                                color: AppColors.textWhite,
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: GestureDetector(
                                onTap: () =>
                                    context.push(AppRoutes.editProfile),
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: const BoxDecoration(
                                    color: AppColors.background,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.edit,
                                    size: 16,
                                    color: AppColors.primary,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSizes.sm),
                        Text(
                          profile.fullName,
                          style: AppTextStyles.headingSmall.copyWith(
                            color: AppColors.textWhite,
                          ),
                        ),
                        const SizedBox(height: AppSizes.xs),
                        Text(
                          profile.email,
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.textWhite.withValues(alpha: 0.8),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSizes.md),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: hp),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Account Settings',
                          style: AppTextStyles.labelMedium.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: AppSizes.sm),
                        _menuTile(
                          icon: Icons.location_on_outlined,
                          title: 'My Addresses',
                          subtitle: 'Manage your delivery addresses',
                          onTap: () => context.push(AppRoutes.addresses),
                        ),
                        _menuTile(
                          icon: Icons.shopping_cart_outlined,
                          title: 'My Cart',
                          subtitle: 'View items in your cart',
                          onTap: () => context.push(AppRoutes.cart),
                        ),
                        _menuTile(
                          icon: Icons.receipt_long_outlined,
                          title: 'My Orders',
                          subtitle: 'Track your orders',
                          onTap: () => context.push(AppRoutes.myOrders),
                        ),
                        const SizedBox(height: AppSizes.md),
                        Text(
                          'Profile Settings',
                          style: AppTextStyles.labelMedium.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: AppSizes.sm),
                        _menuTile(
                          icon: Icons.person_outline,
                          title: 'Edit Profile',
                          subtitle: profile.fullName,
                          onTap: () => context.push(AppRoutes.editProfile),
                        ),
                        _menuTile(
                          icon: Icons.email_outlined,
                          title: 'Email Address',
                          subtitle: profile.email,
                          onTap: () {},
                        ),
                        _menuTile(
                          icon: Icons.phone_outlined,
                          title: 'Phone Number',
                          subtitle: profile.phone.isEmpty
                              ? 'No phone number added'
                              : profile.phone,
                          onTap: () {},
                        ),
                        _menuTile(
                          icon: Icons.verified_user_outlined,
                          title: 'Account Type',
                          subtitle: profile.role,
                          onTap: () {},
                        ),
                        const SizedBox(height: AppSizes.xl),
                        SizedBox(
                          width: double.infinity,
                          height: AppSizes.buttonHeight,
                          child: OutlinedButton.icon(
                            onPressed: () => _showLogoutDialog(context, ref),
                            icon: const Icon(
                              Icons.logout,
                              color: AppColors.error,
                            ),
                            label: Text(
                              'Logout',
                              style: AppTextStyles.buttonTextOutlined.copyWith(
                                color: AppColors.error,
                              ),
                            ),
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: AppColors.error),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  AppSizes.radiusMd,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: AppSizes.xl),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _menuTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: AppSizes.sm),
        padding: const EdgeInsets.all(AppSizes.md),
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(AppSizes.radiusMd),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(AppSizes.sm),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppSizes.radiusSm),
              ),
              child: Icon(
                icon,
                color: AppColors.primary,
                size: AppSizes.iconMd,
              ),
            ),
            const SizedBox(width: AppSizes.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppTextStyles.labelMedium),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: AppTextStyles.caption,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              size: 14,
              color: AppColors.textSecondary,
            ),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusLg),
        ),
        title: Text(
          'Logout',
          style: AppTextStyles.headingSmall,
        ),
        content: Text(
          'Are you sure you want to logout?',
          style: AppTextStyles.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(
              'Cancel',
              style: AppTextStyles.labelMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(dialogContext);

              await ref.read(authControllerProvider.notifier).logout();

              if (context.mounted) {
                context.go(AppRoutes.login);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              minimumSize: Size.zero,
              padding: const EdgeInsets.symmetric(
                horizontal: AppSizes.lg,
                vertical: AppSizes.sm,
              ),
            ),
            child: Text(
              'Logout',
              style: AppTextStyles.buttonText,
            ),
          ),
        ],
      ),
    );
  }
}
