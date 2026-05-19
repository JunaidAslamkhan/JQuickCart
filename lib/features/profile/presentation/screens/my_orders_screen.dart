import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_constants.dart';

class MyOrdersScreen extends StatelessWidget {
  const MyOrdersScreen({super.key});

  final List<Map<String, dynamic>> _dummyOrders = const [
    {
      'id': 'GYS324',
      'date': '30 Jan 2025',
      'status': 'Processing',
      'image': 'assets/images/iphone.png',
    },
    {
      'id': 'GYS325',
      'date': '30 Jan 2025',
      'status': 'Processing',
      'image': 'assets/images/nike_shoes.png',
    },
    {
      'id': 'GYS326',
      'date': '01 Jan 2025',
      'status': 'Processing',
      'image': 'assets/images/blue_shoes.png',
    },
    {
      'id': 'GYS327',
      'date': '01 Jan 2025',
      'status': 'Delivered',
      'image': 'assets/images/beta_shoes.png',
    },
  ];

  Color _statusColor(String status) {
    switch (status) {
      case AppConstants.orderStatusProcessing:
        return AppColors.warning;
      case AppConstants.orderStatusShipped:
        return AppColors.info;
      case AppConstants.orderStatusDelivered:
        return AppColors.success;
      case AppConstants.orderStatusCancelled:
        return AppColors.error;
      default:
        return AppColors.textSecondary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final sw = MediaQuery.of(context).size.width;
    final isTablet = sw >= 600;
    final hp = isTablet ? sw * 0.08 : AppSizes.screenPadding;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
        ),
        title: Text('My Orders', style: AppTextStyles.headingSmall),
      ),
      body: _dummyOrders.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.receipt_long_outlined,
                      size: 80, color: AppColors.textHint),
                  const SizedBox(height: AppSizes.md),
                  Text(
                    'No orders yet',
                    style: AppTextStyles.headingSmall
                        .copyWith(color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: AppSizes.sm),
                  Text(
                    'Your orders will appear here',
                    style: AppTextStyles.bodyMedium
                        .copyWith(color: AppColors.textHint),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: EdgeInsets.symmetric(
                horizontal: hp,
                vertical: AppSizes.md,
              ),
              physics: const BouncingScrollPhysics(),
              itemCount: _dummyOrders.length,
              itemBuilder: (context, index) {
                final order = _dummyOrders[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: AppSizes.md),
                  padding: const EdgeInsets.all(AppSizes.md),
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                    border: Border.all(color: AppColors.border),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.shadow,
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      // Product Image
                      ClipRRect(
                        borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                        child: Image.asset(
                          order['image'],
                          width: 60,
                          height: 60,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            width: 60,
                            height: 60,
                            color: AppColors.surfaceLight,
                            child: const Icon(Icons.image_outlined,
                                color: AppColors.textHint),
                          ),
                        ),
                      ),

                      const SizedBox(width: AppSizes.md),

                      // Order Info
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '#${order['id']}',
                                  style: AppTextStyles.labelMedium,
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: AppSizes.sm,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: _statusColor(order['status'])
                                        .withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(
                                        AppSizes.radiusXs),
                                  ),
                                  child: Text(
                                    order['status'],
                                    style: AppTextStyles.caption.copyWith(
                                      color: _statusColor(order['status']),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: AppSizes.xs),
                            Row(
                              children: [
                                const Icon(
                                  Icons.calendar_today_outlined,
                                  size: 12,
                                  color: AppColors.textSecondary,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  order['date'],
                                  style: AppTextStyles.caption,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      // Arrow
                      const Icon(
                        Icons.arrow_forward_ios,
                        size: 14,
                        color: AppColors.textSecondary,
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
