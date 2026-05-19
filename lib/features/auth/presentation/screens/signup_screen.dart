import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/extensions/context_extension.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/utils/validators.dart';
import '../../../../router/app_routes.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_text_field.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../providers/auth_controller.dart';
import '../widgets/social_login_button.dart';

class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({super.key});

  @override
  ConsumerState<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> {
  final _formKey = GlobalKey<FormState>();

  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _agreeToTerms = false;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
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

  String _getFirebaseAuthErrorMessage(Object error) {
    if (error is FirebaseAuthException) {
      switch (error.code) {
        case 'email-already-in-use':
          return 'This email is already registered. Please login instead.';
        case 'invalid-email':
          return 'Please enter a valid email address.';
        case 'weak-password':
          return 'Password is too weak. Please use a stronger password.';
        case 'network-request-failed':
          return 'Network error. Please check your internet connection.';
        default:
          return error.message ?? 'Signup failed. Please try again.';
      }
    }

    return 'Something went wrong. Please try again.';
  }

  Future<void> _onCreateAccountPressed() async {
    FocusScope.of(context).unfocus();

    if (!_agreeToTerms) {
      _showSnackBar(
        message: 'Please agree to Privacy Policy and Terms of use',
        backgroundColor: AppColors.error,
      );
      return;
    }

    if (!_formKey.currentState!.validate()) {
      return;
    }

    final success = await ref.read(authControllerProvider.notifier).signUp(
          firstName: _firstNameController.text.trim(),
          lastName: _lastNameController.text.trim(),
          email: _emailController.text.trim(),
          phone: _phoneController.text.trim(),
          password: _passwordController.text.trim(),
        );

    if (!mounted) return;

    if (success) {
      _showSnackBar(
        message: 'Account created successfully. Please login.',
        backgroundColor: Colors.green,
      );

      context.go(AppRoutes.login);
    } else {
      final authState = ref.read(authControllerProvider);

      authState.whenOrNull(
        error: (error, _) {
          _showSnackBar(
            message: _getFirebaseAuthErrorMessage(error),
            backgroundColor: AppColors.error,
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);
    final isLoading = authState.isLoading;

    final screenWidth = context.screenWidth;
    final screenHeight = context.screenHeight;
    final isTablet = context.isTablet;
    final horizontalPadding =
        isTablet ? screenWidth * 0.18 : AppSizes.screenPadding;
    final maxWidth = isTablet ? 640.0 : double.infinity;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            vertical: AppSizes.lg,
          ),
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: maxWidth,
                minHeight: screenHeight -
                    context.statusBarHeight -
                    context.bottomPadding,
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      IconButton(
                        onPressed: isLoading
                            ? null
                            : () => Navigator.of(context).pop(),
                        icon: const Icon(Icons.arrow_back),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                      SizedBox(height: screenHeight * 0.03),
                      Text(
                        "Let's Get You Registered",
                        style: AppTextStyles.headingLarge,
                      ),
                      SizedBox(height: screenHeight * 0.04),
                      Row(
                        children: [
                          Expanded(
                            child: AppTextField(
                              hintText: 'First Name',
                              controller: _firstNameController,
                              textInputAction: TextInputAction.next,
                              validator: Validators.validateFirstName,
                              prefixIcon: const Icon(
                                Icons.person_outline,
                                color: AppColors.textSecondary,
                                size: AppSizes.iconMd,
                              ),
                            ),
                          ),
                          const SizedBox(width: AppSizes.sm),
                          Expanded(
                            child: AppTextField(
                              hintText: 'Last Name',
                              controller: _lastNameController,
                              textInputAction: TextInputAction.next,
                              validator: Validators.validateLastName,
                              prefixIcon: const Icon(
                                Icons.person_outline,
                                color: AppColors.textSecondary,
                                size: AppSizes.iconMd,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSizes.md),
                      AppTextField(
                        hintText: 'Email',
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        validator: Validators.validateEmail,
                        prefixIcon: const Icon(
                          Icons.alternate_email,
                          color: AppColors.textSecondary,
                          size: AppSizes.iconMd,
                        ),
                      ),
                      const SizedBox(height: AppSizes.md),
                      AppTextField(
                        hintText: 'Phone Number',
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        textInputAction: TextInputAction.next,
                        validator: Validators.validatePhone,
                        prefixIcon: const Icon(
                          Icons.phone_outlined,
                          color: AppColors.textSecondary,
                          size: AppSizes.iconMd,
                        ),
                      ),
                      const SizedBox(height: AppSizes.md),
                      AppTextField(
                        hintText: 'Password',
                        controller: _passwordController,
                        isPassword: true,
                        textInputAction: TextInputAction.done,
                        validator: Validators.validatePassword,
                        prefixIcon: const Icon(
                          Icons.lock_outline,
                          color: AppColors.textSecondary,
                          size: AppSizes.iconMd,
                        ),
                      ),
                      const SizedBox(height: AppSizes.md),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Checkbox(
                            value: _agreeToTerms,
                            onChanged: isLoading
                                ? null
                                : (val) {
                                    setState(
                                        () => _agreeToTerms = val ?? false);
                                  },
                            activeColor: AppColors.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          Expanded(
                            child: RichText(
                              text: TextSpan(
                                style: AppTextStyles.bodySmall.copyWith(
                                  color: AppColors.textPrimary,
                                ),
                                children: [
                                  const TextSpan(text: 'I agree to '),
                                  TextSpan(
                                    text: 'Privacy Policy',
                                    style: AppTextStyles.bodySmall.copyWith(
                                      color: AppColors.primary,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const TextSpan(text: ' and '),
                                  TextSpan(
                                    text: 'Terms of use',
                                    style: AppTextStyles.bodySmall.copyWith(
                                      color: AppColors.primary,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSizes.md),
                      AppButton(
                        label: 'Create Account',
                        onPressed: isLoading ? null : _onCreateAccountPressed,
                        isLoading: isLoading,
                      ),
                      const SizedBox(height: AppSizes.xl),
                      SocialLoginRow(
                        label: 'Or Sign up With',
                        onGooglePressed: () {},
                        onFacebookPressed: () {},
                      ),
                      const SizedBox(height: AppSizes.lg),
                    ],
                  ),
                ).animate().fadeIn(duration: 350.ms, curve: Curves.easeOut),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
