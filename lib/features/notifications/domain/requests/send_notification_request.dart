 import 'package:tatbeeqi/features/notifications/domain/entities/app_notification.dart';
import 'package:tatbeeqi/features/notifications/domain/entities/notifications_topic.dart';

class SendNotificationRequest {
  final String? userId;
  final NotificationsTopic? topic;
  final AppNotification notification;

  SendNotificationRequest({
    required this.notification,
    required this.topic,
    required this.userId,
  });

  Map toBody() {
     return {};
  }
}
