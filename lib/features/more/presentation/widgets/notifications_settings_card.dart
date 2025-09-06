import 'package:flutter/material.dart';
import 'package:tatbeeqi/features/notifications/presentation/views/notifications_view.dart';
import 'package:tatbeeqi/features/notifications/presentation/views/notifications_settings_view.dart';
import 'package:tatbeeqi/l10n/app_localizations.dart';

class NotificationsSettingsCard extends StatelessWidget {
  const NotificationsSettingsCard({super.key});

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
                color: colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.notifications_outlined,
                color: colorScheme.onPrimaryContainer,
              ),
            ),
            title: Text(l10n.notifications),
            subtitle: Text(l10n.manageNotifications),
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.list_alt_outlined),
            title: Text(l10n.viewNotifications),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const NotificationsView()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings_outlined),
            title: Text(l10n.notificationSettings),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const NotificationsSettingsView()),
              );
            },
          ),
        ],
      ),
    );
  }
}
