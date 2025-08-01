import 'package:tatbeeqi/features/notifications/data/models/app_notification_model.dart';

import '../../domain/entities/app_notification.dart';

extension AppNotificationModelMapper on AppNotificationModel {
  AppNotification get toEntity {
    return AppNotification(
      id: id,
      title: title,
      subtitle: subtitle,
      html: html,
      date: date,
      imageUrl: imageUrl,
      seen: seen,
    );
  }
}

extension AppNotificationMapper on AppNotification {
  AppNotificationModel get toModel {
    return AppNotificationModel(
      id: id,
      title: title,
      subtitle: subtitle,
      html: html,
      date: date,
      imageUrl: imageUrl,
      seen: seen,
    );
  }
}
