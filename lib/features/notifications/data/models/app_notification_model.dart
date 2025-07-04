import 'package:tatbeeqi/features/notifications/domain/entities/app_notification.dart';

class AppNotificationModel extends AppNotification {
  AppNotificationModel({
    required super.id,
    required super.title,
    required super.subtitle,
    required super.html,
    required super.date,
    required super.seen,
    super.imageUrl,
  });

  factory AppNotificationModel.fromDatabaseJson(Map json) {
    return AppNotificationModel(
      id: json['id'],
      title: json['title'],
      subtitle: json['subtitle'],
      html: json['html'],
      date: DateTime.parse(json['date']),
      imageUrl: json['image_url'],
      seen: json['seen'] == 1 ? true : false,
    );
  }

  Map<String, dynamic> toDatabaseJson() {
    return {
      'id': id,
      'title': title,
      'subtitle': subtitle,
      'html': html,
      'image_url': imageUrl,
      'date': date.toIso8601String(),
      'seen': seen ? 1 : 0,
    };
  }
}
