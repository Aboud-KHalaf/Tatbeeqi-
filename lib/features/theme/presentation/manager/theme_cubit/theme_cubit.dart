import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tatbeeqi/core/theme/app_theme.dart';
import 'package:tatbeeqi/core/theme/app_colors.dart';
import 'package:tatbeeqi/core/utils/app_logger.dart';
import 'package:tatbeeqi/features/theme/domain/usecases/get_theme_mode_usecase.dart';
import 'package:tatbeeqi/features/theme/domain/usecases/set_theme_mode_usecase.dart';

/// Enhanced ThemeCubit with Material Design 3 support and seed color customization
class ThemeCubit extends Cubit<ThemeData> {
  final GetThemeModeUseCase _getThemeModeUseCase;
  final SetThemeModeUseCase _setThemeModeUseCase;

  // Current theme settings
  ThemeMode _currentThemeMode = ThemeMode.light;
  Color _currentSeedColor = AppColors.defaultSeedColor;

  ThemeCubit({
    required GetThemeModeUseCase getThemeModeUseCase,
    required SetThemeModeUseCase setThemeModeUseCase,
  })  : _getThemeModeUseCase = getThemeModeUseCase,
        _setThemeModeUseCase = setThemeModeUseCase,
        super(AppTheme.lightTheme);

  /// Gets the current theme mode
  ThemeMode get currentThemeMode => _currentThemeMode;

  /// Gets the current seed color
  Color get currentSeedColor => _currentSeedColor;

  /// Gets the current brightness
  Brightness get currentBrightness => _currentThemeMode == ThemeMode.dark 
      ? Brightness.dark 
      : Brightness.light;

  /// Loads the saved theme preferences
  Future<void> loadTheme() async {
    final result = await _getThemeModeUseCase();

    result.fold(
      (failure) {
        AppLogger.error('Error loading theme preference', failure);
        _currentThemeMode = ThemeMode.light;
        _currentSeedColor = AppColors.defaultSeedColor;
        emit(_generateTheme());
      },
      (themeMode) {
        _currentThemeMode = themeMode;
        _currentSeedColor = AppColors.defaultSeedColor; // TODO: Load saved seed color
        emit(_generateTheme());
      },
    );
  }

  /// Sets the theme mode (light/dark) while preserving the current seed color
  Future<void> setTheme(ThemeMode mode) async {
    final previousThemeMode = _currentThemeMode;
    final previousState = state;

    _currentThemeMode = mode;
    emit(_generateTheme());

    final result = await _setThemeModeUseCase(mode);
    result.fold(
      (failure) {
        AppLogger.error('Error setting theme preference', failure);
        _currentThemeMode = previousThemeMode;
        emit(previousState);
      },
      (_) {
        AppLogger.info('Theme mode updated to: ${mode.name}');
      },
    );
  }

  /// Sets a custom seed color while preserving the current theme mode
  Future<void> setSeedColor(Color seedColor) async {
    final previousSeedColor = _currentSeedColor;
    final previousState = state;

    _currentSeedColor = seedColor;
    emit(_generateTheme());

    // TODO: Implement seed color persistence if needed
    // For now, we'll just log the change
    AppLogger.info('Seed color updated to: ${seedColor.value.toRadixString(16)}');

    // If you want to persist the seed color, you would need to create
    // new use cases similar to theme mode persistence
  }

  /// Sets both theme mode and seed color simultaneously
  Future<void> setThemeWithSeedColor({
    required ThemeMode mode,
    required Color seedColor,
  }) async {
    final previousThemeMode = _currentThemeMode;
    final previousSeedColor = _currentSeedColor;
    final previousState = state;

    _currentThemeMode = mode;
    _currentSeedColor = seedColor;
    emit(_generateTheme());

    final result = await _setThemeModeUseCase(mode);
    result.fold(
      (failure) {
        AppLogger.error('Error setting theme preferences', failure);
        _currentThemeMode = previousThemeMode;
        _currentSeedColor = previousSeedColor;
        emit(previousState);
      },
      (_) {
        AppLogger.info('Theme updated - Mode: ${mode.name}, Seed Color: ${seedColor.value.toRadixString(16)}');
      },
    );
  }

  /// Toggles between light and dark mode
  Future<void> toggleTheme() async {
    final newMode = _currentThemeMode == ThemeMode.light 
        ? ThemeMode.dark 
        : ThemeMode.light;
    await setTheme(newMode);
  }

  /// Resets to default theme settings
  Future<void> resetToDefault() async {
    await setThemeWithSeedColor(
      mode: ThemeMode.light,
      seedColor: AppColors.defaultSeedColor,
    );
  }

  /// Generates a theme based on current settings
  ThemeData _generateTheme() {
    return AppTheme.createTheme(
      seedColor: _currentSeedColor,
      brightness: currentBrightness,
    );
  }

  /// Gets a preview theme for a specific seed color without applying it
  ThemeData getPreviewTheme(Color seedColor) {
    return AppTheme.createTheme(
      seedColor: seedColor,
      brightness: currentBrightness,
    );
  }

  /// Checks if the current theme is using the default seed color
  bool get isUsingDefaultSeedColor => _currentSeedColor == AppColors.defaultSeedColor;

  /// Gets the name of the current seed color for display
  String get currentSeedColorName => AppColors.getSeedColorName(_currentSeedColor);
}
