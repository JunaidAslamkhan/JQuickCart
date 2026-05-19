import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';

class BannerCarousel extends StatefulWidget {
  final List<String> banners;

  const BannerCarousel({super.key, required this.banners});

  @override
  State<BannerCarousel> createState() => _BannerCarouselState();
}

class _BannerCarouselState extends State<BannerCarousel> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final bannerHeight = screenWidth >= 600 ? 220.0 : 160.0;

    return Column(
      children: [
        // Carousel
        CarouselSlider.builder(
          itemCount: widget.banners.length,
          itemBuilder: (context, index, realIndex) {
            return Container(
              width: double.infinity,
              margin: const EdgeInsets.symmetric(
                horizontal: AppSizes.xs,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppSizes.radiusLg),
                color: AppColors.surfaceLight,
              ),
              clipBehavior: Clip.antiAlias,
              child: Image.asset(
                widget.banners[index],
                fit: BoxFit.cover,
                width: double.infinity,
                errorBuilder: (context, error, stackTrace) => Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(AppSizes.radiusLg),
                    gradient: const LinearGradient(
                      colors: [AppColors.primary, AppColors.primaryLight],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: const Center(
                    child: Text(
                      'Autumn brings\nnew outfits',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textWhite,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            );
          },
          options: CarouselOptions(
            height: bannerHeight,
            viewportFraction: 0.92,
            autoPlay: true,
            autoPlayInterval: const Duration(seconds: 4),
            autoPlayAnimationDuration: const Duration(milliseconds: 600),
            autoPlayCurve: Curves.fastOutSlowIn,
            enlargeCenterPage: true,
            onPageChanged: (index, reason) {
              setState(() => _currentIndex = index);
            },
          ),
        ),

        const SizedBox(height: AppSizes.md),

        // Page Indicator
        AnimatedSmoothIndicator(
          activeIndex: _currentIndex,
          count: widget.banners.length,
          effect: ExpandingDotsEffect(
            activeDotColor: AppColors.primary,
            dotColor: AppColors.border,
            dotHeight: 6,
            dotWidth: 6,
            expansionFactor: 3,
          ),
        ),
      ],
    );
  }
}
