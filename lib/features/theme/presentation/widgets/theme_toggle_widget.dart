import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tatbeeqi/core/theme/app_colors.dart';
import 'package:tatbeeqi/features/theme/presentation/manager/theme_cubit/theme_cubit.dart';

/// Enhanced theme toggle widget with Material Design 3 support and color picker
class ThemeToggleWidget extends StatelessWidget {
  /// Whether to show the color picker section
  final bool showColorPicker;

  /// Whether to show the theme mode toggle
  final bool showThemeToggle;

  /// Custom title for the widget
  final String? title;

  const ThemeToggleWidget({
    super.key,
    this.showColorPicker = true,
    this.showThemeToggle = true,
    this.title,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final themeCubit = context.read<ThemeCubit>();

    return BlocBuilder<ThemeCubit, ThemeData>(
      builder: (context, themeData) {
        final isDarkMode = themeCubit.currentBrightness == Brightness.dark;

        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (title != null) ...[
                  Text(
                    title!,
                    style: theme.textTheme.titleMedium,
                  ),
                  const SizedBox(height: 16),
                ],
                if (showThemeToggle) ...[
                  _buildThemeModeToggle(context, theme, themeCubit, isDarkMode),
                  if (showColorPicker) const SizedBox(height: 16),
                ],
                if (showColorPicker) ...[
                  _buildColorPicker(context, theme, themeCubit),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildThemeModeToggle(
    BuildContext context,
    ThemeData theme,
    ThemeCubit themeCubit,
    bool isDarkMode,
  ) {
    return Row(
      children: [
        Icon(
          Icons.light_mode,
          color: !isDarkMode
              ? theme.colorScheme.primary
              : theme.colorScheme.onSurfaceVariant,
          size: 20,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            'وضع الظلام',
            style: theme.textTheme.bodyMedium,
          ),
        ),
        Switch(
          value: isDarkMode,
          onChanged: (value) {
            HapticFeedback.selectionClick();
            themeCubit.setTheme(
              value ? ThemeMode.dark : ThemeMode.light,
            );
          },
        ),
        const SizedBox(width: 8),
        Icon(
          Icons.dark_mode,
          color: isDarkMode
              ? theme.colorScheme.primary
              : theme.colorScheme.onSurfaceVariant,
          size: 20,
        ),
      ],
    );
  }

  Widget _buildColorPicker(
    BuildContext context,
    ThemeData theme,
    ThemeCubit themeCubit,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.palette,
              color: theme.colorScheme.primary,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              'لون التطبيق',
              style: theme.textTheme.bodyMedium,
            ),
            const Spacer(),
            TextButton(
              onPressed: () => _showColorPickerDialog(context, themeCubit),
              child: const Text('المزيد'),
            ),
          ],
        ),
        const SizedBox(height: 12),
        _buildColorGrid(context, theme, themeCubit),
        const SizedBox(height: 8),
        _buildCurrentColorInfo(context, theme, themeCubit),
      ],
    );
  }

  Widget _buildColorGrid(
    BuildContext context,
    ThemeData theme,
    ThemeCubit themeCubit,
  ) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: AppColors.seedColors.map((color) {
        final isSelected = themeCubit.currentSeedColor.value == color.value;

        return GestureDetector(
          onTap: () {
            HapticFeedback.selectionClick();
            themeCubit.setSeedColor(color);
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              border: Border.all(
                color: isSelected
                    ? theme.colorScheme.onSurface
                    : theme.colorScheme.outline,
                width: isSelected ? 3 : 1,
              ),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: color.withValues(alpha: 0.3),
                        blurRadius: 8,
                        spreadRadius: 2,
                      ),
                    ]
                  : null,
            ),
            child: isSelected
                ? Icon(
                    Icons.check,
                    color: _getContrastColor(color),
                    size: 20,
                  )
                : null,
          ),
        );
      }).toList(),
    );
  }

  Widget _buildCurrentColorInfo(
    BuildContext context,
    ThemeData theme,
    ThemeCubit themeCubit,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: Row(
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: themeCubit.currentSeedColor,
              shape: BoxShape.circle,
              border: Border.all(color: theme.colorScheme.outline),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  themeCubit.currentSeedColorName,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  '#${themeCubit.currentSeedColor.value.toRadixString(16).substring(2).toUpperCase()}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          if (!themeCubit.isUsingDefaultSeedColor)
            IconButton(
              onPressed: () {
                HapticFeedback.selectionClick();
                themeCubit.setSeedColor(AppColors.defaultSeedColor);
              },
              icon: const Icon(Icons.refresh),
              tooltip: 'إعادة تعيين',
              iconSize: 20,
            ),
        ],
      ),
    );
  }

  void _showColorPickerDialog(BuildContext context, ThemeCubit themeCubit) {
    showDialog(
      context: context,
      builder: (context) => _ColorPickerDialog(themeCubit: themeCubit),
    );
  }

  Color _getContrastColor(Color color) {
    // Simple contrast calculation
    final luminance =
        (0.299 * color.red + 0.587 * color.green + 0.114 * color.blue) / 255;
    return luminance > 0.5 ? Colors.black : Colors.white;
  }
}

/// Advanced color picker dialog with more color options
class _ColorPickerDialog extends StatefulWidget {
  final ThemeCubit themeCubit;

  const _ColorPickerDialog({required this.themeCubit});

  @override
  State<_ColorPickerDialog> createState() => _ColorPickerDialogState();
}

class _ColorPickerDialogState extends State<_ColorPickerDialog> {
  late Color _selectedColor;

  @override
  void initState() {
    super.initState();
    _selectedColor = widget.themeCubit.currentSeedColor;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AlertDialog(
      title: const Text('اختيار لون التطبيق'),
      content: SizedBox(
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Predefined colors
            Text(
              'الألوان المحددة مسبقاً',
              style: theme.textTheme.titleSmall,
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: AppColors.seedColors.map((color) {
                final isSelected = _selectedColor.value == color.value;

                return GestureDetector(
                  onTap: () {
                    HapticFeedback.selectionClick();
                    setState(() {
                      _selectedColor = color;
                    });
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isSelected
                            ? theme.colorScheme.onSurface
                            : theme.colorScheme.outline,
                        width: isSelected ? 3 : 1,
                      ),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: color.withValues(alpha: 0.3),
                                blurRadius: 8,
                                spreadRadius: 2,
                              ),
                            ]
                          : null,
                    ),
                    child: isSelected
                        ? Icon(
                            Icons.check,
                            color: _getContrastColor(color),
                            size: 24,
                          )
                        : null,
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),

            // Preview section
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerLow,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: theme.colorScheme.outlineVariant),
              ),
              child: Column(
                children: [
                  Text(
                    'معاينة',
                    style: theme.textTheme.titleSmall,
                  ),
                  const SizedBox(height: 12),
                  _buildColorPreview(context, _selectedColor),
                ],
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => context.pop(),
          child: const Text('إلغاء'),
        ),
        FilledButton(
          onPressed: () {
            widget.themeCubit.setSeedColor(_selectedColor);
            context.pop();
          },
          child: const Text('تطبيق'),
        ),
      ],
    );
  }

  Widget _buildColorPreview(BuildContext context, Color seedColor) {
    final previewTheme = widget.themeCubit.getPreviewTheme(seedColor);

    return Theme(
      data: previewTheme,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: previewTheme.colorScheme.surface,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: previewTheme.colorScheme.outline),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Icon(
                  Icons.palette,
                  color: previewTheme.colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'نموذج للنص',
                    style: previewTheme.textTheme.bodyMedium,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: FilledButton(
                    onPressed: () {},
                    child: const Text('زر أساسي'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {},
                    child: const Text('زر ثانوي'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getContrastColor(Color color) {
    final luminance =
        (0.299 * color.red + 0.587 * color.green + 0.114 * color.blue) / 255;
    return luminance > 0.5 ? Colors.black : Colors.white;
  }
}
