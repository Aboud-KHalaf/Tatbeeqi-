import 'package:flutter/material.dart';

class NotificationsSettingsView extends StatefulWidget {
  const NotificationsSettingsView({super.key});

  @override
  State<NotificationsSettingsView> createState() => _NotificationsSettingsViewState();
}

class _NotificationsSettingsViewState extends State<NotificationsSettingsView> {
  bool _enabled = true;
  bool _sound = true;
  bool _vibration = true;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('إعدادات الإشعارات'),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        children: [
          Card(
            elevation: 0,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Column(
              children: [
                SwitchListTile.adaptive(
                  title: const Text('تفعيل الإشعارات'),
                  subtitle: const Text('السماح باستلام إشعارات من التطبيق'),
                  value: _enabled,
                  onChanged: (v) => setState(() => _enabled = v),
                ),
                const Divider(height: 1),
                SwitchListTile.adaptive(
                  title: const Text('الصوت'),
                  subtitle: const Text('تشغيل نغمة عند وصول الإشعار'),
                  value: _sound,
                  onChanged: _enabled ? (v) => setState(() => _sound = v) : null,
                ),
                const Divider(height: 1),
                SwitchListTile.adaptive(
                  title: const Text('الاهتزاز'),
                  subtitle: const Text('اهتزاز الجهاز عند وصول الإشعار'),
                  value: _vibration,
                  onChanged: _enabled ? (v) => setState(() => _vibration = v) : null,
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Card(
            elevation: 0,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: ListTile(
              title: const Text('الوضع الهادئ'),
              subtitle: const Text('تعيين فترة عدم الإزعاج'),
              leading: Icon(Icons.nightlight_round, color: colors.primary),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('الوضع الهادئ'),
                    content: const Text('هذا نموذج عرض فقط. يمكنك تنفيذ منتقي الوقت لاحقاً.'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('حسناً'),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          // const SizedBox(height: 8),
          // Padding(
          //   padding: const EdgeInsets.symmetric(horizontal: 4.0),
          //   child: Text(
          //     'هذه شاشة تجريبية لإعدادات الإشعارات. يمكنك لاحقاً ربطها بالمنطق الفعلي وتهيئة الإشعارات المحلية.',
          //     style: theme.textTheme.bodySmall?.copyWith(color: colors.onSurfaceVariant),
          //     textAlign: TextAlign.center,
          //   ),
          // ),
        ],
      ),
    );
  }
}
