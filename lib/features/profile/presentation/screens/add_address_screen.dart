import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_text_field.dart';
import '../../data/models/address_model.dart';
import '../providers/profile_provider.dart';

class AddAddressScreen extends ConsumerStatefulWidget {
  const AddAddressScreen({super.key});

  @override
  ConsumerState<AddAddressScreen> createState() => _AddAddressScreenState();
}

class _AddAddressScreenState extends ConsumerState<AddAddressScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _streetController = TextEditingController();
  final _postalCodeController = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  final _countryController = TextEditingController();

  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _streetController.dispose();
    _postalCodeController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _countryController.dispose();
    super.dispose();
  }

  void _showSnackBar({
    required String message,
    required Color backgroundColor,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: backgroundColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        ),
        margin: const EdgeInsets.all(AppSizes.md),
      ),
    );
  }

  Future<void> _onSavePressed() async {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) {
      return;
    }

    final firebaseUser = FirebaseAuth.instance.currentUser;

    if (firebaseUser == null) {
      _showSnackBar(
        message: 'Session expired. Please login again.',
        backgroundColor: AppColors.error,
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final now = DateTime.now();
      final addressId = now.millisecondsSinceEpoch.toString();

      final address = AddressModel(
        id: addressId,
        name: _nameController.text.trim(),
        phone: _phoneController.text.trim(),
        street: _streetController.text.trim(),
        city: _cityController.text.trim(),
        state: _stateController.text.trim(),
        postalCode: _postalCodeController.text.trim(),
        country: _countryController.text.trim(),
        isDefault: false,
        createdAt: now,
        updatedAt: now,
      );

      final addressService = ref.read(addressFirestoreServiceProvider);

      await addressService.addAddress(
        uid: firebaseUser.uid,
        address: address,
      );

      ref.invalidate(currentUserAddressesProvider);

      if (!mounted) return;

      _showSnackBar(
        message: 'Address added successfully.',
        backgroundColor: AppColors.success,
      );

      context.pop();
    } catch (error) {
      if (!mounted) return;

      _showSnackBar(
        message: 'Failed to add address. Please try again.',
        backgroundColor: AppColors.error,
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  String? _requiredValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Required';
    }

    return null;
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
          onPressed: _isLoading ? null : () => context.pop(),
          icon: const Icon(
            Icons.arrow_back,
            color: AppColors.textPrimary,
          ),
        ),
        title: Text(
          'Add New Address',
          style: AppTextStyles.headingSmall,
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: hp,
          vertical: AppSizes.lg,
        ),
        physics: const BouncingScrollPhysics(),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              AppTextField(
                hintText: 'Full Name',
                controller: _nameController,
                textInputAction: TextInputAction.next,
                validator: _requiredValidator,
                prefixIcon: const Icon(
                  Icons.person_outline,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: AppSizes.md),
              AppTextField(
                hintText: 'Phone Number',
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                textInputAction: TextInputAction.next,
                validator: _requiredValidator,
                prefixIcon: const Icon(
                  Icons.phone_outlined,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: AppSizes.md),
              AppTextField(
                hintText: 'Street Address',
                controller: _streetController,
                textInputAction: TextInputAction.next,
                validator: _requiredValidator,
                prefixIcon: const Icon(
                  Icons.home_outlined,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: AppSizes.md),
              Row(
                children: [
                  Expanded(
                    child: AppTextField(
                      hintText: 'City',
                      controller: _cityController,
                      textInputAction: TextInputAction.next,
                      validator: _requiredValidator,
                    ),
                  ),
                  const SizedBox(width: AppSizes.sm),
                  Expanded(
                    child: AppTextField(
                      hintText: 'Postal Code',
                      controller: _postalCodeController,
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                      validator: _requiredValidator,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSizes.md),
              Row(
                children: [
                  Expanded(
                    child: AppTextField(
                      hintText: 'State',
                      controller: _stateController,
                      textInputAction: TextInputAction.next,
                      validator: _requiredValidator,
                    ),
                  ),
                  const SizedBox(width: AppSizes.sm),
                  Expanded(
                    child: AppTextField(
                      hintText: 'Country',
                      controller: _countryController,
                      textInputAction: TextInputAction.done,
                      validator: _requiredValidator,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSizes.xl),
              AppButton(
                label: 'Save Address',
                onPressed: _isLoading ? null : _onSavePressed,
                isLoading: _isLoading,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
