import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../router/app_routes.dart';
import '../providers/profile_provider.dart';

class AddressesScreen extends ConsumerWidget {
  const AddressesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final addresses = ref.watch(addressProvider);
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
        title: Text('Addresses', style: AppTextStyles.headingSmall),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: hp,
          vertical: AppSizes.md,
        ),
        child: Column(
          children: [
            // Address List
            Expanded(
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: addresses.length,
                itemBuilder: (context, index) {
                  final address = addresses[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: AppSizes.md),
                    padding: const EdgeInsets.all(AppSizes.md),
                    decoration: BoxDecoration(
                      color: AppColors.background,
                      borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                      border: Border.all(
                        color: address.isDefault
                            ? AppColors.primary
                            : AppColors.border,
                        width: address.isDefault ? 1.5 : 1,
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Radio
                        GestureDetector(
                          onTap: () => ref
                              .read(addressProvider.notifier)
                              .setDefault(address.id),
                          child: Container(
                            width: 22,
                            height: 22,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: address.isDefault
                                    ? AppColors.primary
                                    : AppColors.border,
                                width: 2,
                              ),
                            ),
                            child: address.isDefault
                                ? Center(
                                    child: Container(
                                      width: 12,
                                      height: 12,
                                      decoration: const BoxDecoration(
                                        color: AppColors.primary,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                  )
                                : null,
                          ),
                        ),

                        const SizedBox(width: AppSizes.md),

                        // Address Info
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(address.name,
                                      style: AppTextStyles.labelMedium),
                                  if (address.isDefault)
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: AppSizes.sm,
                                        vertical: 2,
                                      ),
                                      decoration: BoxDecoration(
                                        color:
                                            AppColors.primary.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(
                                            AppSizes.radiusXs),
                                      ),
                                      child: Text(
                                        'Default',
                                        style: AppTextStyles.caption.copyWith(
                                          color: AppColors.primary,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                              const SizedBox(height: AppSizes.xs),
                              Text(address.phone,
                                  style: AppTextStyles.bodySmall),
                              const SizedBox(height: AppSizes.xs),
                              Text(
                                address.fullAddress,
                                style: AppTextStyles.bodySmall
                                    .copyWith(color: AppColors.textSecondary),
                              ),
                            ],
                          ),
                        ),

                        // Delete
                        IconButton(
                          onPressed: () => ref
                              .read(addressProvider.notifier)
                              .removeAddress(address.id),
                          icon: const Icon(
                            Icons.delete_outline,
                            color: AppColors.error,
                            size: 20,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            // Add New Address Button
            SizedBox(
              width: double.infinity,
              height: AppSizes.buttonHeight,
              child: OutlinedButton.icon(
                onPressed: () => context.push(AppRoutes.addAddress),
                icon: const Icon(Icons.add, color: AppColors.primary),
                label: Text(
                  'Add New Address',
                  style: AppTextStyles.buttonTextOutlined,
                ),
              ),
            ),
            const SizedBox(height: AppSizes.md),
          ],
        ),
      ),
    );
  }
}
