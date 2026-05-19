import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../features/auth/presentation/screens/login_screen.dart';
import '../features/auth/presentation/screens/signup_screen.dart';
import '../features/auth/presentation/screens/forgot_password_screen.dart';
import '../features/auth/presentation/screens/email_sent_screen.dart';
import '../features/auth/presentation/screens/verify_email_screen.dart';
import '../features/auth/presentation/screens/account_created_screen.dart';
import '../features/onboarding/presentation/screens/onboarding_screen.dart';
import '../features/onboarding/presentation/screens/splash_screen.dart';
import '../features/home/presentation/screens/home_screen.dart';
import '../features/store/presentation/screens/store_screen.dart';
import '../features/wishlist/presentation/screens/wishlist_screen.dart';
import '../features/profile/presentation/screens/profile_screen.dart';
import '../features/profile/presentation/screens/edit_profile_screen.dart';
import '../features/profile/presentation/screens/addresses_screen.dart';
import '../features/profile/presentation/screens/add_address_screen.dart';
import '../features/profile/presentation/screens/my_orders_screen.dart';
import '../features/products/presentation/screens/product_detail_screen.dart';
import '../features/products/presentation/screens/category_products_screen.dart';
import '../features/products/presentation/screens/brand_products_screen.dart';
import '../features/cart/presentation/screens/cart_screen.dart';
import '../features/cart/presentation/screens/checkout_screen.dart';
import '../features/cart/presentation/screens/payment_success_screen.dart';
import '../shared/widgets/main_shell.dart';
import 'app_routes.dart';

// ─────────────────────────────────────────────────────────────────────────────
// STANDARD PAGE TRANSITION — used for push navigation (non-tab screens)
// Subtle fade + tiny slide. Fast and premium feel.
// ─────────────────────────────────────────────────────────────────────────────
Page<dynamic> _buildPage(
    BuildContext context, GoRouterState state, Widget child) {
  return CustomTransitionPage<dynamic>(
    key: state.pageKey,
    child: child,
    transitionDuration: const Duration(milliseconds: 220),
    reverseTransitionDuration: const Duration(milliseconds: 180),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final opacity = CurvedAnimation(
        parent: animation,
        curve: Curves.easeOut,
      );
      final offset = Tween<Offset>(
        begin: const Offset(0.03, 0.0),
        end: Offset.zero,
      ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOut));

      return FadeTransition(
        opacity: opacity,
        child: SlideTransition(position: offset, child: child),
      );
    },
  );
}

// ─────────────────────────────────────────────────────────────────────────────
// INSTANT TAB PAGE — zero duration, no animation for bottom nav tab switching
// This makes Home → Store → Wishlist → Profile feel INSTANT like Instagram
// ─────────────────────────────────────────────────────────────────────────────
Page<dynamic> _buildTabPage(
    BuildContext context, GoRouterState state, Widget child) {
  return CustomTransitionPage<dynamic>(
    key: state.pageKey,
    child: child,
    transitionDuration: Duration.zero,
    reverseTransitionDuration: Duration.zero,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return child; // pure instant switch — no animation at all
    },
  );
}

// ─────────────────────────────────────────────────────────────────────────────
// SHELL PAGE — also instant, shell itself should never animate
// ─────────────────────────────────────────────────────────────────────────────
Page<dynamic> _buildShellPage(
    BuildContext context, GoRouterState state, Widget child) {
  return NoTransitionPage<dynamic>(
    key: state.pageKey,
    child: child,
  );
}

// ─────────────────────────────────────────────────────────────────────────────
// ROUTER
// ─────────────────────────────────────────────────────────────────────────────
final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: AppRoutes.splash,
    debugLogDiagnostics: false,
    routes: [
      // ── Auth & Onboarding (use smooth transition) ──────────────────────
      GoRoute(
        path: AppRoutes.splash,
        pageBuilder: (context, state) =>
            _buildPage(context, state, const SplashScreen()),
      ),
      GoRoute(
        path: AppRoutes.onboarding,
        pageBuilder: (context, state) =>
            _buildPage(context, state, const OnboardingScreen()),
      ),
      GoRoute(
        path: AppRoutes.login,
        pageBuilder: (context, state) =>
            _buildPage(context, state, const LoginScreen()),
      ),
      GoRoute(
        path: AppRoutes.signup,
        pageBuilder: (context, state) =>
            _buildPage(context, state, const SignupScreen()),
      ),
      GoRoute(
        path: AppRoutes.forgotPassword,
        pageBuilder: (context, state) =>
            _buildPage(context, state, const ForgotPasswordScreen()),
      ),
      GoRoute(
        path: AppRoutes.emailSent,
        pageBuilder: (context, state) => _buildPage(
          context,
          state,
          EmailSentScreen(email: state.extra as String? ?? ''),
        ),
      ),
      GoRoute(
        path: AppRoutes.verifyEmail,
        pageBuilder: (context, state) => _buildPage(
          context,
          state,
          VerifyEmailScreen(email: state.extra as String? ?? ''),
        ),
      ),
      GoRoute(
        path: AppRoutes.accountCreated,
        pageBuilder: (context, state) =>
            _buildPage(context, state, const AccountCreatedScreen()),
      ),

      // ── Product / Cart / Profile sub-screens (smooth transition) ───────
      GoRoute(
        path: AppRoutes.productDetail,
        pageBuilder: (context, state) => _buildPage(
          context,
          state,
          ProductDetailScreen(productId: state.pathParameters['id'] ?? ''),
        ),
      ),
      GoRoute(
        path: AppRoutes.categoryProducts,
        pageBuilder: (context, state) => _buildPage(
          context,
          state,
          CategoryProductsScreen(categoryId: state.pathParameters['id'] ?? ''),
        ),
      ),
      GoRoute(
        path: AppRoutes.brandProducts,
        pageBuilder: (context, state) => _buildPage(
          context,
          state,
          BrandProductsScreen(brandId: state.pathParameters['id'] ?? ''),
        ),
      ),
      GoRoute(
        path: AppRoutes.cart,
        pageBuilder: (context, state) =>
            _buildPage(context, state, const CartScreen()),
      ),
      GoRoute(
        path: AppRoutes.checkout,
        pageBuilder: (context, state) =>
            _buildPage(context, state, const CheckoutScreen()),
      ),
      GoRoute(
        path: AppRoutes.paymentSuccess,
        pageBuilder: (context, state) =>
            _buildPage(context, state, const PaymentSuccessScreen()),
      ),
      GoRoute(
        path: AppRoutes.editProfile,
        pageBuilder: (context, state) =>
            _buildPage(context, state, const EditProfileScreen()),
      ),
      GoRoute(
        path: AppRoutes.addresses,
        pageBuilder: (context, state) =>
            _buildPage(context, state, const AddressesScreen()),
      ),
      GoRoute(
        path: AppRoutes.addAddress,
        pageBuilder: (context, state) =>
            _buildPage(context, state, const AddAddressScreen()),
      ),
      GoRoute(
        path: AppRoutes.myOrders,
        pageBuilder: (context, state) =>
            _buildPage(context, state, const MyOrdersScreen()),
      ),

      // ── Shell (Bottom Nav) — INSTANT, no transition ────────────────────
      ShellRoute(
        pageBuilder: (context, state, child) =>
            _buildShellPage(context, state, MainShell(child: child)),
        routes: [
          GoRoute(
            path: AppRoutes.home,
            pageBuilder: (context, state) =>
                _buildTabPage(context, state, const HomeScreen()),
          ),
          GoRoute(
            path: AppRoutes.store,
            pageBuilder: (context, state) =>
                _buildTabPage(context, state, const StoreScreen()),
          ),
          GoRoute(
            path: AppRoutes.wishlist,
            pageBuilder: (context, state) =>
                _buildTabPage(context, state, const WishlistScreen()),
          ),
          GoRoute(
            path: AppRoutes.profile,
            pageBuilder: (context, state) =>
                _buildTabPage(context, state, const ProfileScreen()),
          ),
        ],
      ),
    ],
  );
});
