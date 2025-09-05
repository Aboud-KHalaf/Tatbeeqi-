import 'package:flutter/material.dart';
import 'package:tatbeeqi/features/more/presentation/views/about_app_view.dart';
import 'package:tatbeeqi/features/more/presentation/views/help_suppurt_view.dart';
import 'package:tatbeeqi/features/more/presentation/views/privacy_view.dart';
import 'package:tatbeeqi/l10n/app_localizations.dart';

class AdditionalSettingsCard extends StatelessWidget {
  const AdditionalSettingsCard({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context)!;

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          ListTile(
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: colorScheme.secondaryContainer,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.more_horiz,
                color: colorScheme.onSecondaryContainer,
              ),
            ),
            title: Text(l10n.additionalSettings),
            subtitle: Text(l10n.moreOptionsSettings),
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.help_outline),
            title: Text(l10n.helpSupport),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const HelpSupportScreen(),
                  ));
            },
          ),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: Text(l10n.aboutApp),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AboutAppScreen(),
                  ));
            },
          ),
          ListTile(
            leading: const Icon(Icons.privacy_tip_outlined),
            title: Text(l10n.privacySecurity),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PrivacyScreen(),
                  ));
            },
          ),
        ],
      ),
    );
  }
}
