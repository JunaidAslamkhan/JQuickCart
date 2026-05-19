import 'package:flutter/material.dart';
import 'app_colors_premium.dart';
import 'app_text_styles.dart';
import '../constants/app_sizes.dart';

/// Premium theme with modern Material Design 3 aesthetics
class AppThemePremium {
  AppThemePremium._();

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      fontFamily: 'Poppins',
      brightness: Brightness.light,
      primaryColor: AppColorsPremium.primary,
      scaffoldBackgroundColor: AppColorsPremium.background,
      colorScheme: const ColorScheme.light(
        primary: AppColorsPremium.primary,
        secondary: AppColorsPremium.secondary,
        surface: AppColorsPremium.surfaceLight,
        error: AppColorsPremium.error,
        onPrimary: AppColorsPremium.textWhite,
        onSecondary: AppColorsPremium.textWhite,
        onSurface: AppColorsPremium.textPrimary,
        onError: AppColorsPremium.textWhite,
      ),

      // AppBar - Premium style with elevation
      appBarTheme: AppBarTheme(
        backgroundColor: AppColorsPremium.background,
        elevation: 2,
        shadowColor: AppColorsPremium.textPrimary.withValues(alpha: 0.1),
        centerTitle: false,
        iconTheme: const IconThemeData(color: AppColorsPremium.textPrimary),
        titleTextStyle: AppTextStyles.headingSmall.copyWith(
          color: AppColorsPremium.textPrimary,
          letterSpacing: 0.3,
        ),
        surfaceTintColor: Colors.transparent,
      ),

      // ElevatedButton - Premium with gradient and shadow
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColorsPremium.primary,
          foregroundColor: AppColorsPremium.textWhite,
          minimumSize: const Size(double.infinity, AppSizes.buttonHeight),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.radiusMd),
          ),
          elevation: 4,
          shadowColor: AppColorsPremium.primary.withValues(alpha: 0.4),
          textStyle: AppTextStyles.buttonText.copyWith(
            letterSpacing: 0.5,
          ),
        ),
      ),

      // OutlinedButton - Refined borders
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColorsPremium.primary,
          minimumSize: const Size(double.infinity, AppSizes.buttonHeight),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.radiusMd),
          ),
          side: const BorderSide(
            color: AppColorsPremium.primary,
            width: 1.5,
          ),
          textStyle: AppTextStyles.buttonTextOutlined.copyWith(
            letterSpacing: 0.5,
          ),
        ),
      ),

      // TextButton
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColorsPremium.primary,
          textStyle: AppTextStyles.labelMedium.copyWith(
            letterSpacing: 0.3,
          ),
        ),
      ),

      // InputDecoration - Premium form fields with focus effects
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColorsPremium.surfaceLight,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSizes.md,
          vertical: AppSizes.md,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusMd),
          borderSide: const BorderSide(
            color: AppColorsPremium.border,
            width: 1.5,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusMd),
          borderSide: const BorderSide(
            color: AppColorsPremium.divider,
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusMd),
          borderSide: const BorderSide(
            color: AppColorsPremium.primary,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusMd),
          borderSide: const BorderSide(
            color: AppColorsPremium.error,
            width: 1.5,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusMd),
          borderSide: const BorderSide(
            color: AppColorsPremium.error,
            width: 2,
          ),
        ),
        hintStyle: AppTextStyles.bodyMedium.copyWith(
          color: AppColorsPremium.textHint,
        ),
        labelStyle: AppTextStyles.bodyMedium.copyWith(
          color: AppColorsPremium.textSecondary,
        ),
        prefixIconColor: WidgetStateColor.resolveWith((states) {
          if (states.contains(WidgetState.focused)) {
            return AppColorsPremium.primary;
          }
          return AppColorsPremium.textSecondary;
        }),
        suffixIconColor: WidgetStateColor.resolveWith((states) {
          if (states.contains(WidgetState.focused)) {
            return AppColorsPremium.primary;
          }
          return AppColorsPremium.textSecondary;
        }),
      ),

      // Bottom Navigation Bar - Modern style
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColorsPremium.background,
        selectedItemColor: AppColorsPremium.primary,
        unselectedItemColor: AppColorsPremium.textSecondary,
        elevation: 16,
        type: BottomNavigationBarType.fixed,
      ),

      // Card Theme - Elevated cards
      cardTheme: CardThemeData(
        color: AppColorsPremium.background,
        elevation: 2,
        shadowColor: AppColorsPremium.textPrimary.withValues(alpha: 0.08),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusMd),
          side: const BorderSide(
            color: AppColorsPremium.divider,
            width: 1,
          ),
        ),
        clipBehavior: Clip.antiAlias,
      ),

      // Dialog Theme
      dialogTheme: DialogThemeData(
        backgroundColor: AppColorsPremium.background,
        elevation: 24,
        shadowColor: AppColorsPremium.textPrimary.withValues(alpha: 0.2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusLg),
        ),
      ),

      // Checkbox Theme
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColorsPremium.primary;
          }
          return AppColorsPremium.surfaceLight;
        }),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
        side: const BorderSide(
          color: AppColorsPremium.border,
          width: 1.5,
        ),
      ),

      // Chip Theme
      chipTheme: ChipThemeData(
        backgroundColor: AppColorsPremium.surfaceLight,
        selectedColor: AppColorsPremium.primary,
        labelStyle: AppTextStyles.bodySmall.copyWith(
          color: AppColorsPremium.textPrimary,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusSm),
        ),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      fontFamily: 'Poppins',
      brightness: Brightness.dark,
      primaryColor: AppColorsPremium.primary,
      scaffoldBackgroundColor: AppColorsPremium.bgDark,
      // ... dark theme configuration
    );
  }
}
