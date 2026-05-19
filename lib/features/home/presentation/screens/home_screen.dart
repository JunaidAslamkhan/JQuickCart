import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../router/app_routes.dart';
import '../../../../shared/providers/dummy_data.dart';
import '../../../../shared/widgets/product_card.dart';
import '../widgets/banner_carousel.dart';
import '../widgets/home_app_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedCategoryIndex = 0;
  final _searchController = TextEditingController();

  final List<_HomeCategory> _categories = const [
    _HomeCategory(
      id: 'furniture',
      title: 'Furniture',
      icon: '🛋️',
    ),
    _HomeCategory(
      id: 'electronics',
      title: 'Electronics',
      icon: '🎮',
    ),
    _HomeCategory(
      id: 'clothes',
      title: 'Clothes',
      icon: '👕',
    ),
    _HomeCategory(
      id: 'shoes',
      title: 'Shoes',
      icon: '👟',
    ),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _openCategory(int index) {
    setState(() {
      _selectedCategoryIndex = index;
    });

    context.push(
      AppRoutes.categoryProductsPath(_categories[index].id),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth >= 600;

    final horizontalPadding =
        isTablet ? screenWidth * 0.05 : AppSizes.screenPadding;

    final gridCrossAxisCount = isTablet ? 3 : 2;
    final gridChildAspectRatio = isTablet ? 0.75 : 0.64;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const HomeAppBar(userName: 'JQuickCart'),
      body: SafeArea(
        top: false,
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: Container(
                width: double.infinity,
                color: AppColors.primary,
                padding: EdgeInsets.fromLTRB(
                  horizontalPadding,
                  AppSizes.md,
                  horizontalPadding,
                  AppSizes.xl,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Popular Categories',
                      style: AppTextStyles.headingSmall.copyWith(
                        color: AppColors.textWhite,
                        fontSize: isTablet ? 20 : 18,
                      ),
                    ),
                    const SizedBox(height: AppSizes.md),
                    SizedBox(
                      height: isTablet ? 120 : 108,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        itemCount: _categories.length,
                        separatorBuilder: (_, __) =>
                            const SizedBox(width: AppSizes.md),
                        itemBuilder: (context, index) {
                          final category = _categories[index];
                          final isSelected = _selectedCategoryIndex == index;

                          return _HomeCategoryCard(
                            category: category,
                            isSelected: isSelected,
                            onTap: () => _openCategory(index),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  horizontalPadding,
                  AppSizes.lg,
                  horizontalPadding,
                  AppSizes.md,
                ),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search in Store',
                    hintStyle: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                    prefixIcon: const Icon(
                      Icons.search,
                      color: AppColors.textSecondary,
                    ),
                    filled: true,
                    fillColor: AppColors.surfaceLight,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: AppSizes.md,
                      vertical: AppSizes.md,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppSizes.radiusLg),
                      borderSide: const BorderSide(color: AppColors.border),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppSizes.radiusLg),
                      borderSide: const BorderSide(color: AppColors.border),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppSizes.radiusLg),
                      borderSide: const BorderSide(
                        color: AppColors.primary,
                        width: 1.5,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                child: BannerCarousel(banners: DummyData.banners),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  horizontalPadding,
                  AppSizes.xl,
                  horizontalPadding,
                  AppSizes.sm,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Popular Products',
                      style: AppTextStyles.headingSmall.copyWith(
                        fontSize: isTablet ? 22 : 18,
                      ),
                    ),
                    TextButton(
                      onPressed: () => context.push(AppRoutes.store),
                      child: Text(
                        'View All',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding: EdgeInsets.fromLTRB(
                horizontalPadding,
                AppSizes.sm,
                horizontalPadding,
                MediaQuery.of(context).padding.bottom +
                    AppSizes.bottomNavHeight +
                    AppSizes.xl,
              ),
              sliver: SliverGrid(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    return ProductCard(
                      product: DummyData.products[index],
                    );
                  },
                  childCount: DummyData.products.length,
                ),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: gridCrossAxisCount,
                  crossAxisSpacing: AppSizes.md,
                  mainAxisSpacing: AppSizes.md,
                  childAspectRatio: gridChildAspectRatio,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HomeCategory {
  const _HomeCategory({
    required this.id,
    required this.title,
    required this.icon,
  });

  final String id;
  final String title;
  final String icon;
}

class _HomeCategoryCard extends StatelessWidget {
  const _HomeCategoryCard({
    required this.category,
    required this.isSelected,
    required this.onTap,
  });

  final _HomeCategory category;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final cardColor = isSelected ? AppColors.textWhite : AppColors.surfaceLight;
    final borderColor = isSelected
        ? AppColors.textWhite
        : AppColors.textWhite.withValues(alpha: 0.25);
    final textColor = AppColors.textWhite;

    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 92,
        child: Column(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 82,
              height: 70,
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(AppSizes.radiusLg),
                border: Border.all(
                  color: borderColor,
                  width: isSelected ? 2 : 1,
                ),
                boxShadow: [
                  if (isSelected)
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.12),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                ],
              ),
              child: Center(
                child: Text(
                  category.icon,
                  style: const TextStyle(fontSize: 34),
                ),
              ),
            ),
            const SizedBox(height: AppSizes.sm),
            Text(
              category.title,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.bodySmall.copyWith(
                color: textColor,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
