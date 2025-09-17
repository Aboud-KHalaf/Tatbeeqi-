import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class AppLocalNotificationsService {
  ///
  static const InitializationSettings settings = InitializationSettings(
    iOS: DarwinInitializationSettings(),
    android: AndroidInitializationSettings('@mipmap/ic_launcher'),
  );

  ///
  static const defaultChannel = AndroidNotificationChannel(
    "local_notifications_channel",
    "local_notifications_channel",
    importance: Importance.min,
    playSound: false,
    enableVibration: false,
    enableLights: false,
  );

  /// Reminders channel
  static const remindersChannel = AndroidNotificationChannel(
    "reminders_channel",
    "Study Reminders",
    description: "Notifications for study reminders",
    importance: Importance.high,
    playSound: true,
    enableVibration: true,
    enableLights: true,
  );

  /// default
  static const List<AndroidNotificationChannel> channels = [
    defaultChannel,
    remindersChannel,
  ];

  ///
  static NotificationDetails defaultNotificationsDetails() {
    return NotificationDetails(
      android: AndroidNotificationDetails(
        defaultChannel.id,
        defaultChannel.name,
        importance: Importance.min,
        priority: Priority.min,
        playSound: false,
        enableVibration: false,
        enableLights: false,
      ),
      iOS: const DarwinNotificationDetails(
        badgeNumber: 1,
        presentAlert: false,
        presentBadge: false,
        presentSound: false,
        subtitle: '',
        threadIdentifier: '',
      ),
    );
  }

  ///
  static NotificationDetails remoteNotificationsDetails({String? imagePath}) {
    StyleInformation? styleInformation;
    if (imagePath != null) {
      styleInformation = BigPictureStyleInformation(
        FilePathAndroidBitmap(imagePath), // Use valid file path here
      );
    }

    return NotificationDetails(
      android: AndroidNotificationDetails(
        defaultChannel.id,
        defaultChannel.name,
        importance: Importance.max,
        priority: Priority.max,
        playSound: true,
        enableVibration: true,
        enableLights: false,
        styleInformation: styleInformation,
      ),
      iOS: const DarwinNotificationDetails(
        badgeNumber: 1,
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
        subtitle: '',
        threadIdentifier: '',
      ),
    );
  }

  ///
  static NotificationDetails remindersNotificationDetails() {
    return NotificationDetails(
      android: AndroidNotificationDetails(
        remindersChannel.id,
        remindersChannel.name,
        channelDescription: remindersChannel.description,
        importance: Importance.high,
        priority: Priority.high,
        playSound: true,
        enableVibration: true,
        enableLights: true,
      ),
      iOS: const DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      ),
    );
  }

  ///
  static NotificationDetails progressNotificationsDetails({
    required int sent,
    required int total,
  }) {
    return NotificationDetails(
      android: AndroidNotificationDetails(
        defaultChannel.id,
        defaultChannel.name,
        importance: Importance.high,
        priority: Priority.high,
        showProgress: true,
        maxProgress: total,
        progress: sent,
        indeterminate: total == 0,
        playSound: false,
        enableLights: false,
        enableVibration: false,
        silent: true,
        actions: [
          const AndroidNotificationAction(
            'cancel_operation_button',
            'الغاء العملية',
          ),
        ],
      ),
      iOS: const DarwinNotificationDetails(),
    );
  }
}

/// Top-level handlers required by flutter_local_notifications
/// The background handler MUST be a top-level or static function and marked as an entry-point.
@pragma('vm:entry-point')
void notificationTapBackground(NotificationResponse response) {
  // Handle background notification tap if needed.
  // Keep minimal work here; you can queue work to run when app resumes.
}

void notificationTapForeground(NotificationResponse response) {
  // Handle foreground notification tap if needed.
}

