import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../../../core/extensions/context_extension.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../router/app_routes.dart';
import '../widgets/onboarding_page.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, String>> _pages = [
    {
      'image': 'assets/images/On Boarding 1.gif',
      'title': 'Welcome to JQuickCart',
      'subtitle':
          'Your one-stop destination for effortless and enjoyable shopping',
    },
    {
      'image': 'assets/images/On Boarding 2.gif',
      'title': 'Shop Everything You Love!',
      'subtitle':
          'Discover top-quality products at the best prices with a seamless shopping experience',
    },
    {
      'image': 'assets/images/On Boarding 3.gif',
      'title': 'Fast & Reliable Delivery!',
      'subtitle':
          'Get your favorite items delivered to your doorstep, anytime, anywhere',
    },
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onNextPressed() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 360),
        curve: Curves.easeOutCubic,
      );
    } else {
      context.go(AppRoutes.login);
    }
  }

  void _onSkipPressed() {
    context.go(AppRoutes.login);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = context.screenWidth;
    final screenHeight = context.screenHeight;
    final maxWidth = screenWidth > 760 ? 760.0 : screenWidth;
    final isLastPage = _currentPage == _pages.length - 1;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Skip Button
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.only(
                  top: AppSizes.sm,
                  right: AppSizes.md,
                ),
                child: TextButton(
                  onPressed: _onSkipPressed,
                  child: Text(
                    'Skip',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),

            // Page View
            Expanded(
              child: Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: maxWidth),
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: _pages.length,
                    onPageChanged: (index) {
                      setState(() => _currentPage = index);
                    },
                    itemBuilder: (context, index) {
                      return OnboardingPage(
                        imagePath: _pages[index]['image']!,
                        title: _pages[index]['title']!,
                        subtitle: _pages[index]['subtitle']!,
                      );
                    },
                  ).animate().fadeIn(duration: 500.ms),
                ),
              ),
            ),

            // Page Indicator
            SmoothPageIndicator(
              controller: _pageController,
              count: _pages.length,
              effect: const ExpandingDotsEffect(
                activeDotColor: AppColors.primary,
                dotColor: AppColors.border,
                dotHeight: 8,
                dotWidth: 8,
                expansionFactor: 3,
              ),
            ).animate().fadeIn(duration: 450.ms),

            const SizedBox(height: AppSizes.xl),

            // Next / Get Started Button
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSizes.screenPadding,
              ),
              child: SizedBox(
                width: double.infinity,
                height: AppSizes.buttonHeight,
                child: ElevatedButton(
                  onPressed: _onNextPressed,
                  child: Text(
                    isLastPage ? 'Get Started' : 'Next',
                    style: AppTextStyles.buttonText,
                  ),
                ),
              ).animate().fadeIn(duration: 450.ms, delay: 120.ms),
            ),

            SizedBox(height: AppSizes.lg + screenHeight * 0.02),
          ],
        ),
      ),
    );
  }
}
