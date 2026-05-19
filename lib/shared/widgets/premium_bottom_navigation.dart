import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

const _brand = Color(0xFF1A35CC);
const _brand2 = Color(0xFF3451E8);
const _inactive = Color(0xFF8E96AA);

class PremiumNavItem {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final int? badgeCount;

  const PremiumNavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    this.badgeCount,
  });
}

class PremiumBottomNavigation extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;
  final List<PremiumNavItem> items;

  const PremiumBottomNavigation({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final width = media.size.width;
    final bottom = media.padding.bottom;
    final isSmall = width < 380;
    final isTablet = width >= 600;

    if (items.isEmpty) return const SizedBox.shrink();

    return SafeArea(
      top: false,
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          isTablet ? 48 : 16,
          0,
          isTablet ? 48 : 16,
          bottom > 0 ? 8 : 16,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(32),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
            child: Container(
              height: isTablet ? 70 : 62,
              padding: const EdgeInsets.symmetric(horizontal: 6),
              decoration: BoxDecoration(
                color: Colors.white.withAlpha(245),
                borderRadius: BorderRadius.circular(32),
                border: Border.all(color: Colors.white.withAlpha(220)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(18),
                    blurRadius: 24,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Row(
                children: List.generate(items.length, (index) {
                  final item = items[index];
                  final active = currentIndex == index;

                  return Expanded(
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        HapticFeedback.selectionClick();
                        onTap(index);
                      },
                      child: Center(
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 250),
                          curve: Curves.easeOutCubic,
                          height: isTablet ? 46 : 42,
                          constraints: BoxConstraints(
                            maxWidth: active ? (isTablet ? 130 : 104) : 48,
                          ),
                          padding: EdgeInsets.symmetric(
                            horizontal: active ? (isSmall ? 8 : 10) : 0,
                          ),
                          decoration: BoxDecoration(
                            gradient: active
                                ? const LinearGradient(
                                    colors: [_brand, _brand2],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  )
                                : null,
                            borderRadius: BorderRadius.circular(24),
                            boxShadow: active
                                ? [
                                    BoxShadow(
                                      color: _brand.withAlpha(55),
                                      blurRadius: 14,
                                      offset: const Offset(0, 6),
                                    ),
                                  ]
                                : null,
                          ),
                          child: active
                              ? Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    _IconBadge(
                                      icon: item.activeIcon,
                                      color: Colors.white,
                                      size: isTablet ? 25 : 22,
                                      count: item.badgeCount,
                                    ),
                                    if (!isSmall) const SizedBox(width: 6),
                                    if (!isSmall)
                                      Flexible(
                                        child: FittedBox(
                                          fit: BoxFit.scaleDown,
                                          child: Text(
                                            item.label,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: isTablet ? 13 : 12,
                                              fontWeight: FontWeight.w800,
                                            ),
                                          ),
                                        ),
                                      ),
                                  ],
                                )
                              : _IconBadge(
                                  icon: item.icon,
                                  color: _inactive,
                                  size: isTablet ? 25 : 22,
                                  count: item.badgeCount,
                                ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _IconBadge extends StatelessWidget {
  final IconData icon;
  final Color color;
  final double size;
  final int? count;

  const _IconBadge({
    required this.icon,
    required this.color,
    required this.size,
    this.count,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Icon(icon, color: color, size: size),
        if (count != null)
          Positioned(
            top: -8,
            right: -9,
            child: _Badge(count: count!),
          ),
      ],
    );
  }
}

class _Badge extends StatelessWidget {
  final int count;

  const _Badge({required this.count});

  @override
  Widget build(BuildContext context) {
    final dot = count == 0;

    return Container(
      constraints: BoxConstraints(
        minWidth: dot ? 8 : 16,
        minHeight: dot ? 8 : 16,
      ),
      padding:
          dot ? EdgeInsets.zero : const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFFF3B30),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white, width: 1.2),
      ),
      child: dot
          ? null
          : Text(
              count > 99 ? '99+' : '$count',
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 9,
                fontWeight: FontWeight.w900,
                height: 1.2,
              ),
            ),
    );
  }
}
