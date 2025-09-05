import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tatbeeqi/features/localization/presentation/manager/locale_cubit/locale_cubit.dart';
import 'package:tatbeeqi/features/localization/presentation/manager/locale_cubit/locale_state.dart';
import 'package:tatbeeqi/l10n/app_localizations.dart';

class LanguageSettingsCard extends StatelessWidget {
  const LanguageSettingsCard({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context)!;

    return BlocBuilder<LocaleCubit, LocaleState>(
      builder: (context, state) {
        final isArabic = state.locale.languageCode == 'ar';

        return Card(
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: ListTile(
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: colorScheme.secondaryContainer,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.language,
                color: colorScheme.onSecondaryContainer,
              ),
            ),
            title: Text(l10n.language),
            subtitle: Text(isArabic ? l10n.arabic : l10n.english),
            trailing: DropdownButton<String>(
              value: state.locale.languageCode,
              underline: const SizedBox(),
              items: [
                DropdownMenuItem(value: 'ar', child: Text(l10n.arabic)),
                DropdownMenuItem(value: 'en', child: Text(l10n.english)),
              ],
              onChanged: (value) {
                if (value != null) {
                  context.read<LocaleCubit>().setLocale(Locale(value));
                }
              },
            ),
          ),
        );
      },
    );
  }
}
