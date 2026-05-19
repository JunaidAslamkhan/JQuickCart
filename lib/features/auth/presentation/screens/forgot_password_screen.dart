import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/utils/validators.dart';
import '../../../../router/app_routes.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_text_field.dart';
import '../providers/auth_controller.dart';

class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState<ForgotPasswordScreen> createState() =>
      _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
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
        case 'invalid-email':
          return 'Please enter a valid email address.';
        case 'user-not-found':
          return 'No account found with this email.';
        case 'network-request-failed':
          return 'Network error. Please check your internet connection.';
        case 'too-many-requests':
          return 'Too many requests. Please try again later.';
        default:
          return error.message ?? 'Password reset failed. Please try again.';
      }
    }

    return 'Something went wrong. Please try again.';
  }

  Future<void> _onSubmitPressed() async {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) {
      return;
    }

    final success =
        await ref.read(authControllerProvider.notifier).sendPasswordResetEmail(
              email: _emailController.text.trim(),
            );

    if (!mounted) return;

    if (success) {
      context.push(
        AppRoutes.emailSent,
        extra: _emailController.text.trim(),
      );
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

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isTablet = screenWidth >= 600;
    final horizontalPadding =
        isTablet ? screenWidth * 0.15 : AppSizes.screenPadding;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: horizontalPadding,
            vertical: AppSizes.lg,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(
                  onPressed: isLoading ? null : () => context.pop(),
                  icon: const Icon(Icons.arrow_back),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
                SizedBox(height: screenHeight * 0.05),
                Text(
                  'Forget Password',
                  style: AppTextStyles.headingLarge,
                ),
                const SizedBox(height: AppSizes.sm),
                Text(
                  "No worries! Enter your registered email address and we'll send you a password reset link.",
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                SizedBox(height: screenHeight * 0.05),
                AppTextField(
                  hintText: 'Email',
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.done,
                  validator: Validators.validateEmail,
                  prefixIcon: const Icon(
                    Icons.alternate_email,
                    color: AppColors.textSecondary,
                    size: AppSizes.iconMd,
                  ),
                ),
                SizedBox(height: screenHeight * 0.04),
                AppButton(
                  label: 'Send Reset Link',
                  onPressed: isLoading ? null : _onSubmitPressed,
                  isLoading: isLoading,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
