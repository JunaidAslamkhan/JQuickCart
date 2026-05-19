import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors_premium.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../router/app_routes.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..forward();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Timer(const Duration(milliseconds: 1200), () {
        if (mounted) {
          context.go(AppRoutes.onboarding);
        }
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF1E40AF),
              Color(0xFF2563EB),
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ScaleTransition(
                  scale: CurvedAnimation(
                    parent: _controller,
                    curve: Curves.elasticOut,
                  ),
                  child: Container(
                    width: 108,
                    height: 108,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: AppColorsPremium.primaryGradient,
                      boxShadow: AppColorsPremium.highElevationShadow,
                    ),
                    child: const Icon(
                      Icons.shopping_bag_rounded,
                      color: Colors.white,
                      size: 52,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'JQuickCart',
                  style: AppTextStyles.displayLarge.copyWith(
                    color: AppColorsPremium.textWhite,
                    letterSpacing: 1.1,
                  ),
                ).animate().fadeIn(duration: 600.ms, delay: 200.ms),
                const SizedBox(height: 8),
                Text(
                  'Premium shopping for every device',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColorsPremium.textWhite.withAlpha(217),
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ).animate().fadeIn(duration: 600.ms, delay: 300.ms),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
