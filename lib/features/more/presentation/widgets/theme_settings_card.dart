import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tatbeeqi/core/theme/app_colors.dart';
import 'package:tatbeeqi/features/theme/presentation/manager/theme_cubit/theme_cubit.dart';
import 'package:tatbeeqi/l10n/app_localizations.dart';

class ThemeSettingsCard extends StatelessWidget {
  const ThemeSettingsCard({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context)!;

    return BlocBuilder<ThemeCubit, ThemeData>(
      builder: (context, themeData) {
        final themeCubit = context.read<ThemeCubit>();
        final isDark = themeCubit.currentThemeMode == ThemeMode.dark;

        return Card(
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.palette_rounded,
                        color: colorScheme.onPrimaryContainer,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.themeAndColors,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            l10n.customizeAppAppearance,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                ThemeModeToggle(themeCubit: themeCubit, isDark: isDark),
                const SizedBox(height: 20),
                ColorPicker(themeCubit: themeCubit),
              ],
            ),
          ),
        );
      },
    );
  }
}

class ThemeModeToggle extends StatelessWidget {
  final ThemeCubit themeCubit;
  final bool isDark;

  const ThemeModeToggle({super.key, required this.themeCubit, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context)!;

    return Row(
      children: [
        Icon(
          Icons.light_mode,
          color: !isDark ? colorScheme.primary : colorScheme.onSurfaceVariant,
          size: 20,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            l10n.darkMode,
            style: theme.textTheme.bodyMedium,
          ),
        ),
        Switch(
          value: isDark,
          onChanged: (_) {
            HapticFeedback.selectionClick();
            themeCubit.toggleTheme();
          },
        ),
        const SizedBox(width: 8),
        Icon(
          Icons.dark_mode,
          color: isDark ? colorScheme.primary : colorScheme.onSurfaceVariant,
          size: 20,
        ),
      ],
    );
  }
}

class ColorPicker extends StatelessWidget {
  final ThemeCubit themeCubit;

  const ColorPicker({super.key, required this.themeCubit});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.color_lens_rounded,
              color: colorScheme.primary,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              l10n.appColor,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
            const Spacer(),
            TextButton(
              onPressed: () => _showColorPickerDialog(context, themeCubit),
              child: Text(l10n.more),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ColorGrid(themeCubit: themeCubit),
        const SizedBox(height: 12),
        CurrentColorInfo(themeCubit: themeCubit),
      ],
    );
  }

  void _showColorPickerDialog(BuildContext context, ThemeCubit themeCubit) {
    showDialog(
      context: context,
      builder: (context) => ColorPickerDialog(themeCubit: themeCubit),
    );
  }
}

class ColorGrid extends StatelessWidget {
  final ThemeCubit themeCubit;

  const ColorGrid({super.key, required this.themeCubit});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: AppColors.seedColors.take(6).map((color) {
        final isSelected = themeCubit.currentSeedColor.value == color.value;

        return GestureDetector(
          onTap: () {
            themeCubit.setSeedColor(color);
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 36,
            height: 36,
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
                        blurRadius: 6,
                        spreadRadius: 1,
                      ),
                    ]
                  : null,
            ),
            child: isSelected
                ? Icon(
                    Icons.check,
                    color: _getContrastColor(color),
                    size: 18,
                  )
                : null,
          ),
        );
      }).toList(),
    );
  }

  Color _getContrastColor(Color color) {
    final luminance = (0.299 * color.red + 0.587 * color.green + 0.114 * color.blue) / 255;
    return luminance > 0.5 ? Colors.black : Colors.white;
  }
}

class CurrentColorInfo extends StatelessWidget {
  final ThemeCubit themeCubit;

  const CurrentColorInfo({super.key, required this.themeCubit});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context)!;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: Row(
        children: [
          Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              color: themeCubit.currentSeedColor,
              shape: BoxShape.circle,
              border: Border.all(color: colorScheme.outline),
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
                    color: colorScheme.onSurfaceVariant,
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
              tooltip: l10n.reset,
              iconSize: 18,
            ),
        ],
      ),
    );
  }
}

class ColorPickerDialog extends StatefulWidget {
  final ThemeCubit themeCubit;

  const ColorPickerDialog({super.key, required this.themeCubit});

  @override
  State<ColorPickerDialog> createState() => _ColorPickerDialogState();
}

class _ColorPickerDialogState extends State<ColorPickerDialog> {
  late Color _selectedColor;

  @override
  void initState() {
    super.initState();
    _selectedColor = widget.themeCubit.currentSeedColor;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return AlertDialog(
      title: Text(l10n.chooseAppColor),
      content: SizedBox(
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              l10n.availableColors,
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
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.cancel),
        ),
        FilledButton(
          onPressed: () {
            widget.themeCubit.setSeedColor(_selectedColor);
            Navigator.of(context).pop();
          },
          child: Text(l10n.apply),
        ),
      ],
    );
  }

  Color _getContrastColor(Color color) {
    final luminance = (0.299 * color.red + 0.587 * color.green + 0.114 * color.blue) / 255;
    return luminance > 0.5 ? Colors.black : Colors.white;
  }
}
