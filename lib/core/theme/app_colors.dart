import 'package:flutter/material.dart';

/// Material Design 3 color utility class that provides dynamic color scheme generation
/// and predefined seed colors for theme customization.
class AppColors {
  AppColors._();

  /// Default seed color for Material Design 3 color scheme generation
  static const Color defaultSeedColor = Color(0xFF00BCD4); // Cyan 500

  /// Predefined seed colors for theme customization
static const List<Color> seedColors = [
  // الأصلية
  Color(0xFF00BCD4), // Cyan - Default
  Color(0xFF2196F3), // Blue
  Color(0xFF4CAF50), // Green
  Color(0xFFFF9800), // Orange
  Color(0xFF9C27B0), // Purple
  Color(0xFFE91E63), // Pink
  Color(0xFF795548), // Brown
  Color(0xFF607D8B), // Blue Grey
  Color(0xFFF44336), // Red
  Color(0xFF3F51B5), // Indigo
  Color(0xFF009688), // Teal
  Color(0xFFFF5722), // Deep Orange

  // ألوان جديدة (لزيادة التنوع)
  Color(0xFF8BC34A), // Light Green
  Color(0xFFFFEB3B), // Yellow
  Color(0xFF673AB7), // Deep Purple
  Color(0xFFCDDC39), // Lime
  Color(0xFFFFCDD2), // Light Red
  Color(0xFF00ACC1), // Dark Cyan
  Color(0xFFFFA000), // Amber Dark
  Color(0xFF7E57C2), // Medium Purple
  Color(0xFF607D8B), // Greyish Blue
  Color(0xFF26A69A), // Medium Teal
  Color(0xFFFF7043), // Coral
  Color(0xFFB0BEC5), // Light Blue Grey
];


  /// Generates a Material Design 3 light color scheme from a seed color
  static ColorScheme lightColorSchemeFromSeed(Color seedColor) {
    return ColorScheme.fromSeed(
      seedColor: seedColor,
      brightness: Brightness.light,
    );
  }

  /// Generates a Material Design 3 dark color scheme from a seed color
  static ColorScheme darkColorSchemeFromSeed(Color seedColor) {
    return ColorScheme.fromSeed(
      seedColor: seedColor,
      brightness: Brightness.dark,
    );
  }

  /// Custom success colors for completion states (not part of standard MD3)
  static const Color lightSuccess = Color(0xFF4CAF50);
  static const Color lightSuccessContainer = Color(0xFFE8F5E8);
  static const Color lightOnSuccess = Color(0xFFFFFFFF);
  static const Color lightOnSuccessContainer = Color(0xFF1B5E20);

  static const Color darkSuccess = Color(0xFF66BB6A);
  static const Color darkSuccessContainer = Color(0xFF2E7D32);
  static const Color darkOnSuccess = Color(0xFF000000);
  static const Color darkOnSuccessContainer = Color(0xFFC8E6C9);

  /// Gets the appropriate success color based on brightness
  static Color getSuccessColor(Brightness brightness) {
    return brightness == Brightness.light ? lightSuccess : darkSuccess;
  }

  /// Gets the appropriate success container color based on brightness
  static Color getSuccessContainerColor(Brightness brightness) {
    return brightness == Brightness.light ? lightSuccessContainer : darkSuccessContainer;
  }

  /// Gets the appropriate on-success color based on brightness
  static Color getOnSuccessColor(Brightness brightness) {
    return brightness == Brightness.light ? lightOnSuccess : darkOnSuccess;
  }

  /// Gets the appropriate on-success container color based on brightness
  static Color getOnSuccessContainerColor(Brightness brightness) {
    return brightness == Brightness.light ? lightOnSuccessContainer : darkOnSuccessContainer;
  }

  /// Helper method to get seed color name for UI display
  static String getSeedColorName(Color color) {
    switch (color.value) {
      case 0xFF00BCD4:
        return 'Cyan';
      case 0xFF2196F3:
        return 'Blue';
      case 0xFF4CAF50:
        return 'Green';
      case 0xFFFF9800:
        return 'Orange';
      case 0xFF9C27B0:
        return 'Purple';
      case 0xFFE91E63:
        return 'Pink';
      case 0xFF795548:
        return 'Brown';
      case 0xFF607D8B:
        return 'Blue Grey';
      case 0xFFF44336:
        return 'Red';
      case 0xFF3F51B5:
        return 'Indigo';
      case 0xFF009688:
        return 'Teal';
      case 0xFFFF5722:
        return 'Deep Orange';
      default:
        return 'Custom';
    }
  }
}
