import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../router/app_routes.dart';
import '../../../../shared/widgets/app_button.dart';
import '../providers/cart_provider.dart';

class CheckoutScreen extends ConsumerStatefulWidget {
  const CheckoutScreen({super.key});

  @override
  ConsumerState<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends ConsumerState<CheckoutScreen> {
  final _promoController = TextEditingController();
  String _selectedPayment = 'Master Card';
  bool _isLoading = false;

  final List<Map<String, dynamic>> _paymentMethods = [
    {'name': 'Cash on Delivery', 'icon': Icons.money},
    {'name': 'Visa', 'icon': Icons.credit_card},
    {'name': 'Master Card', 'icon': Icons.credit_card},
    {'name': 'Paypal', 'icon': Icons.paypal},
    {'name': 'Easypay', 'icon': Icons.payment},
  ];

  final Map<String, String> _address = {
    'name': 'Unknown Pro',
    'phone': '+923001234567',
    'address': 'House No 399, Hyderabad, Sindh, Pakistan',
  };

  @override
  void dispose() {
    _promoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cartItems = ref.watch(cartProvider);
    final cartTotal = ref.watch(cartTotalProvider);
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
        title: Text('Order Review', style: AppTextStyles.headingSmall),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: hp,
                vertical: AppSizes.md,
              ),
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Order Items
                  ...cartItems.map((item) => Container(
                        margin: const EdgeInsets.only(bottom: AppSizes.sm),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius:
                                  BorderRadius.circular(AppSizes.radiusSm),
                              child: Image.asset(
                                item.product.imageUrl,
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
                            const SizedBox(width: AppSizes.sm),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(item.product.name,
                                      style: AppTextStyles.labelMedium),
                                  if (item.selectedColor != null)
                                    Text('Color: ${item.selectedColor}',
                                        style: AppTextStyles.caption),
                                  if (item.selectedSize != null)
                                    Text('Size: ${item.selectedSize}',
                                        style: AppTextStyles.caption),
                                  if (item.selectedStorage != null)
                                    Text('Storage: ${item.selectedStorage}',
                                        style: AppTextStyles.caption),
                                ],
                              ),
                            ),
                            Text(
                              '\$${item.totalPrice.toStringAsFixed(0)}',
                              style: AppTextStyles.priceStyle
                                  .copyWith(fontSize: 14),
                            ),
                          ],
                        ),
                      )),

                  const Divider(height: AppSizes.xl),

                  // Promo Code
                  Text('Promo Code', style: AppTextStyles.labelMedium),
                  const SizedBox(height: AppSizes.sm),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _promoController,
                          style: AppTextStyles.bodyMedium,
                          decoration: InputDecoration(
                            hintText: 'Promo code',
                            hintStyle: AppTextStyles.bodyMedium
                                .copyWith(color: AppColors.textHint),
                            filled: true,
                            fillColor: AppColors.surfaceLight,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: AppSizes.md,
                              vertical: AppSizes.sm,
                            ),
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.circular(AppSizes.radiusMd),
                              borderSide:
                                  const BorderSide(color: AppColors.border),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.circular(AppSizes.radiusMd),
                              borderSide:
                                  const BorderSide(color: AppColors.border),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.circular(AppSizes.radiusMd),
                              borderSide: const BorderSide(
                                  color: AppColors.primary, width: 1.5),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: AppSizes.sm),
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSizes.md,
                            vertical: AppSizes.sm + 2,
                          ),
                          minimumSize: Size.zero,
                        ),
                        child: Text('Apply',
                            style: AppTextStyles.labelMedium
                                .copyWith(color: AppColors.textWhite)),
                      ),
                    ],
                  ),

                  const Divider(height: AppSizes.xl),

                  // Order Summary
                  _summaryRow('Subtotal', '\$${cartTotal.toStringAsFixed(0)}'),
                  const SizedBox(height: AppSizes.xs),
                  _summaryRow('Shipping Fee', '\$12'),
                  const SizedBox(height: AppSizes.xs),
                  _summaryRow('Tax Fee', '\$5'),
                  const Divider(height: AppSizes.lg),
                  _summaryRow(
                    'Order Total',
                    '\$${(cartTotal + 17).toStringAsFixed(0)}',
                    isBold: true,
                  ),

                  const Divider(height: AppSizes.xl),

                  // Payment Method
                  Text('Payment Method', style: AppTextStyles.labelMedium),
                  const SizedBox(height: AppSizes.sm),
                  ...(_paymentMethods.map((method) => GestureDetector(
                        onTap: () =>
                            setState(() => _selectedPayment = method['name']),
                        child: Container(
                          margin: const EdgeInsets.only(bottom: AppSizes.sm),
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSizes.md,
                            vertical: AppSizes.sm,
                          ),
                          decoration: BoxDecoration(
                            color: _selectedPayment == method['name']
                                ? AppColors.primary.withOpacity(0.05)
                                : AppColors.background,
                            borderRadius:
                                BorderRadius.circular(AppSizes.radiusMd),
                            border: Border.all(
                              color: _selectedPayment == method['name']
                                  ? AppColors.primary
                                  : AppColors.border,
                              width:
                                  _selectedPayment == method['name'] ? 1.5 : 1,
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(method['icon'] as IconData,
                                  color: AppColors.primary, size: 24),
                              const SizedBox(width: AppSizes.md),
                              Expanded(
                                child: Text(method['name'],
                                    style: AppTextStyles.bodyMedium),
                              ),
                              if (_selectedPayment == method['name'])
                                const Icon(Icons.check_circle,
                                    color: AppColors.primary, size: 20),
                            ],
                          ),
                        ),
                      ))),

                  const Divider(height: AppSizes.xl),

                  // Shipping Address
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Shipping Address',
                          style: AppTextStyles.labelMedium),
                      TextButton(
                        onPressed: () => context.push(AppRoutes.addresses),
                        child: Text('Change',
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w600,
                            )),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSizes.sm),
                  Container(
                    padding: const EdgeInsets.all(AppSizes.md),
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.border),
                      borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(_address['name']!,
                            style: AppTextStyles.labelMedium),
                        const SizedBox(height: AppSizes.xs),
                        Text(_address['phone']!,
                            style: AppTextStyles.bodySmall),
                        const SizedBox(height: AppSizes.xs),
                        Text(_address['address']!,
                            style: AppTextStyles.bodySmall
                                .copyWith(color: AppColors.textSecondary)),
                      ],
                    ),
                  ),

                  const SizedBox(height: AppSizes.xl),
                ],
              ),
            ),
          ),

          // Checkout Button
          Container(
            padding: EdgeInsets.fromLTRB(
              hp,
              AppSizes.md,
              hp,
              AppSizes.md + MediaQuery.of(context).padding.bottom,
            ),
            decoration: const BoxDecoration(
              color: AppColors.background,
              border: Border(top: BorderSide(color: AppColors.border)),
            ),
            child: AppButton(
              label: 'Checkout \$${(cartTotal + 17).toStringAsFixed(0)}',
              isLoading: _isLoading,
              onPressed: () async {
                setState(() => _isLoading = true);
                await Future.delayed(const Duration(seconds: 2));
                setState(() => _isLoading = false);
                if (mounted) {
                  ref.read(cartProvider.notifier).clearCart();
                  context.go(AppRoutes.paymentSuccess);
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _summaryRow(String label, String value, {bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: isBold
              ? AppTextStyles.labelMedium
              : AppTextStyles.bodyMedium
                  .copyWith(color: AppColors.textSecondary),
        ),
        Text(
          value,
          style: isBold ? AppTextStyles.priceStyle : AppTextStyles.labelMedium,
        ),
      ],
    );
  }
}
