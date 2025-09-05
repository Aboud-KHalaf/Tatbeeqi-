import 'package:flutter/material.dart';
import 'package:tatbeeqi/l10n/app_localizations.dart';
import 'package:tatbeeqi/features/more/presentation/widgets/theme_settings_card.dart';
import 'package:tatbeeqi/features/more/presentation/widgets/language_settings_card.dart';
import 'package:tatbeeqi/features/more/presentation/widgets/account_settings_card.dart';
import 'package:tatbeeqi/features/more/presentation/widgets/notifications_settings_card.dart';
import 'package:tatbeeqi/features/more/presentation/widgets/additional_settings_card.dart';

class SettingsSection extends StatelessWidget {
  const SettingsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _Header(),
        SizedBox(height: 16),
        ThemeSettingsCard(),
        SizedBox(height: 12),
        LanguageSettingsCard(),
        SizedBox(height: 12),
        AccountSettingsCard(),
        SizedBox(height: 12),
        NotificationsSettingsCard(),
        SizedBox(height: 12),
        AdditionalSettingsCard(),
      ],
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Text(
      l10n.settings,
      style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
    );
  }
}
