import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tatbeeqi/core/theme/app_colors.dart';
import 'package:tatbeeqi/core/theme/app_text_styles.dart';



class AppTheme {
  AppTheme._(); // Private constructor

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true, // Enable Material 3
      brightness: Brightness.light,
      primaryColor: AppColors.lightPrimary,
      scaffoldBackgroundColor: AppColors.lightBackground,
      colorScheme: const ColorScheme.light(
        primary: AppColors.lightPrimary,
        primaryContainer: AppColors.lightPrimaryContainer,
        secondary: AppColors.lightSecondary,
        secondaryContainer: AppColors.lightSecondaryContainer,
        tertiary: AppColors.lightTertiary,
        tertiaryContainer: AppColors.lightTertiaryContainer,
        surface: AppColors.lightSurface,
        surfaceContainer: AppColors.lightSurfaceContainer,
        error: AppColors.lightError,
        onPrimary: AppColors.lightOnPrimary,
        onPrimaryContainer: AppColors.lightOnPrimaryContainer,
        onSecondary: AppColors.lightOnSecondary,
        onSecondaryContainer: AppColors.lightOnSecondaryContainer,
        onTertiary: AppColors.lightOnTertiary,
        onTertiaryContainer: AppColors.lightOnTertiaryContainer,
        onSurface: AppColors.lightOnSurface,
        onSurfaceVariant: AppColors.lightOnSurfaceVariant,
        onError: AppColors.lightOnError,
        outline: AppColors.lightOutline,
        shadow: AppColors.lightShadow,
      ),
      textTheme: AppTextStyles.lightTextTheme,
      appBarTheme: AppBarTheme(
        elevation: 0,
        centerTitle: true,
        backgroundColor: AppColors.lightSurface,
        foregroundColor: AppColors.lightOnSurface,
        titleTextStyle: AppTextStyles.lightTextTheme.titleLarge,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      buttonTheme: const ButtonThemeData(
        buttonColor: AppColors.lightPrimary,
        textTheme: ButtonTextTheme.primary,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.lightPrimary,
          foregroundColor: AppColors.lightOnPrimary,
          textStyle: AppTextStyles.lightTextTheme.labelLarge,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.lightPrimary,
          side: const BorderSide(color: AppColors.lightOutline),
          textStyle: AppTextStyles.lightTextTheme.labelLarge,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.lightPrimary,
          textStyle: AppTextStyles.lightTextTheme.labelLarge,
        ),
      ),
      cardTheme: CardThemeData(
        color: AppColors.lightSurfaceContainer,
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.lightSurfaceContainer,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: AppColors.lightPrimary,
        foregroundColor: AppColors.lightOnPrimary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: AppColors.lightSurface,
        indicatorColor: AppColors.lightPrimaryContainer,
        labelTextStyle: WidgetStateProperty.all(
          AppTextStyles.lightTextTheme.labelMedium,
        ),
      ),
      tabBarTheme:const TabBarThemeData(
        labelColor: AppColors.lightPrimary,
        unselectedLabelColor: AppColors.lightOnSurfaceVariant,
        indicator: UnderlineTabIndicator(
          borderSide: BorderSide(color: AppColors.lightPrimary, width: 2),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.lightSurfaceContainer,
        contentTextStyle: AppTextStyles.lightTextTheme.bodyMedium,
        actionTextColor: AppColors.lightPrimary,
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.lightOutline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.lightPrimary, width: 2),
        ),
        labelStyle: AppTextStyles.lightTextTheme.bodyMedium,
        hintStyle: AppTextStyles.lightTextTheme.bodyMedium?.copyWith(
          color: AppColors.lightOnSurfaceVariant,
        ),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true, // Enable Material 3
      brightness: Brightness.dark,
      primaryColor: AppColors.darkPrimary,
      scaffoldBackgroundColor: AppColors.darkBackground,
      colorScheme:const ColorScheme.dark(
        primary: AppColors.darkPrimary,
        primaryContainer: AppColors.darkPrimaryContainer,
        secondary: AppColors.darkSecondary,
        secondaryContainer: AppColors.darkSecondaryContainer,
        tertiary: AppColors.darkTertiary,
        tertiaryContainer: AppColors.darkTertiaryContainer,
        surface: AppColors.darkSurface,
        surfaceContainer: AppColors.darkSurfaceContainer,
        error: AppColors.darkError,
        onPrimary: AppColors.darkOnPrimary,
        onPrimaryContainer: AppColors.darkOnPrimaryContainer,
        onSecondary: AppColors.darkOnSecondary,
        onSecondaryContainer: AppColors.darkOnSecondaryContainer,
        onTertiary: AppColors.darkOnTertiary,
        onTertiaryContainer: AppColors.darkOnTertiaryContainer,
        onSurface: AppColors.darkOnSurface,
        onSurfaceVariant: AppColors.darkOnSurfaceVariant,
        onError: AppColors.darkOnError,
        outline: AppColors.darkOutline,
        shadow: AppColors.darkShadow,
      ),
      textTheme: AppTextStyles.darkTextTheme,
      appBarTheme: AppBarTheme(
        elevation: 0,
        centerTitle: true,
        backgroundColor: AppColors.darkBackground,
        foregroundColor: AppColors.darkOnSurface,
        titleTextStyle: AppTextStyles.darkTextTheme.titleLarge,
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      buttonTheme: const ButtonThemeData(
        buttonColor: AppColors.darkPrimary,
        textTheme: ButtonTextTheme.primary,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.darkPrimary,
          foregroundColor: AppColors.darkOnPrimary,
          textStyle: AppTextStyles.darkTextTheme.labelLarge,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.darkPrimary,
          side: const BorderSide(color: AppColors.darkOutline),
          textStyle: AppTextStyles.darkTextTheme.labelLarge,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.darkPrimary,
          textStyle: AppTextStyles.darkTextTheme.labelLarge,
        ),
      ),
      cardTheme: CardThemeData(
        color: AppColors.darkSurfaceContainer,
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.darkSurfaceContainer,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: AppColors.darkPrimary,
        foregroundColor: AppColors.darkOnPrimary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: AppColors.darkSurface,
        indicatorColor: AppColors.darkPrimaryContainer,
        labelTextStyle: WidgetStateProperty.all(
          AppTextStyles.darkTextTheme.labelMedium,
        ),
      ),
      tabBarTheme:const TabBarThemeData(
        labelColor: AppColors.darkPrimary,
        unselectedLabelColor: AppColors.darkOnSurfaceVariant,
        indicator: UnderlineTabIndicator(
          borderSide: BorderSide(color: AppColors.darkPrimary, width: 2),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.darkSurfaceContainer,
        contentTextStyle: AppTextStyles.darkTextTheme.bodyMedium,
        actionTextColor: AppColors.darkPrimary,
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.darkOutline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.darkPrimary, width: 2),
        ),
        labelStyle: AppTextStyles.darkTextTheme.bodyMedium,
        hintStyle: AppTextStyles.darkTextTheme.bodyMedium?.copyWith(
          color: AppColors.darkOnSurfaceVariant,
        ),
      ),
    );
  }
}