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

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _rememberMe = false;

  @override
  void dispose() {
    _emailController.dispose();
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
        case 'invalid-email':
          return 'Please enter a valid email address.';
        case 'user-not-found':
          return 'No account found with this email. Please create an account first.';
        case 'wrong-password':
          return 'Incorrect password. Please try again.';
        case 'invalid-credential':
          return 'Invalid email or password. Please check your details.';
        case 'user-disabled':
          return 'This account has been disabled. Please contact support.';
        case 'too-many-requests':
          return 'Too many login attempts. Please try again later.';
        case 'network-request-failed':
          return 'Network error. Please check your internet connection.';
        default:
          return error.message ?? 'Login failed. Please try again.';
      }
    }

    return 'Something went wrong. Please try again.';
  }

  Future<void> _onSignInPressed() async {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) {
      return;
    }

    final success = await ref.read(authControllerProvider.notifier).login(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );

    if (!mounted) return;

    if (success) {
      context.go(AppRoutes.home);
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
    final maxWidth = isTablet ? 560.0 : double.infinity;

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
                      SizedBox(height: screenHeight * 0.06),
                      Text(
                        'Shop Smarter',
                        style: AppTextStyles.displayMedium,
                      ),
                      const SizedBox(height: AppSizes.xs),
                      Text(
                        'Log In to Access Exclusive Deals and Simplify Your Shopping Experience',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.05),
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
                      const SizedBox(height: AppSizes.sm),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Checkbox(
                                value: _rememberMe,
                                onChanged: isLoading
                                    ? null
                                    : (val) {
                                        setState(() {
                                          _rememberMe = val ?? false;
                                        });
                                      },
                                activeColor: AppColors.primary,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                              Text(
                                'Remember Me',
                                style: AppTextStyles.bodySmall.copyWith(
                                  color: AppColors.textPrimary,
                                ),
                              ),
                            ],
                          ),
                          TextButton(
                            onPressed: isLoading
                                ? null
                                : () => context.push(AppRoutes.forgotPassword),
                            child: Text(
                              'Forgot Password?',
                              style: AppTextStyles.bodySmall.copyWith(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSizes.md),
                      AppButton(
                        label: 'Sign In',
                        onPressed: isLoading ? null : _onSignInPressed,
                        isLoading: isLoading,
                      ),
                      const SizedBox(height: AppSizes.md),
                      AppButton(
                        label: 'Create Account',
                        onPressed: isLoading
                            ? null
                            : () => context.push(AppRoutes.signup),
                        type: ButtonType.outlined,
                      ),
                      const SizedBox(height: AppSizes.xl),
                      SocialLoginRow(
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
