import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors_premium.dart';
import '../../router/app_routes.dart';
import 'premium_bottom_navigation.dart';

class MainShell extends StatelessWidget {
  final Widget child;

  const MainShell({super.key, required this.child});

  int _currentIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    if (location.startsWith(AppRoutes.store)) return 1;
    if (location.startsWith(AppRoutes.wishlist)) return 2;
    if (location.startsWith(AppRoutes.profile)) return 3;
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final currentIndex = _currentIndex(context);

    return Scaffold(
      backgroundColor: AppColorsPremium.background,
      extendBody: true,
      body: child,
      bottomNavigationBar: PremiumBottomNavigation(
        currentIndex: currentIndex,
        onTap: (index) {
          switch (index) {
            case 0:
              context.go(AppRoutes.home);
              break;
            case 1:
              context.go(AppRoutes.store);
              break;
            case 2:
              context.go(AppRoutes.wishlist);
              break;
            case 3:
              context.go(AppRoutes.profile);
              break;
          }
        },
        items: const [
          PremiumNavItem(
            icon: Icons.home_outlined,
            activeIcon: Icons.home_rounded,
            label: 'Home',
          ),
          PremiumNavItem(
            icon: Icons.storefront_outlined,
            activeIcon: Icons.storefront_rounded,
            label: 'Store',
          ),
          PremiumNavItem(
            icon: Icons.favorite_outline_rounded,
            activeIcon: Icons.favorite_rounded,
            label: 'Wishlist',
          ),
          PremiumNavItem(
            icon: Icons.person_outline_rounded,
            activeIcon: Icons.person_rounded,
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
