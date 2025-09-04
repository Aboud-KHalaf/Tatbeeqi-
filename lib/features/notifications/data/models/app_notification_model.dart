import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:tatbeeqi/features/notifications/domain/entities/app_notification.dart';

class AppNotificationModel extends AppNotification {
  const AppNotificationModel({
    required super.id,
    required super.title,
    super.body,
    super.imageUrl,
    super.html,
    required super.date,
    super.type,
    super.targetUserIds,
    super.targetTopics,
    super.sentBy,
    super.createdAt,
    super.seen = false,
  });

  factory AppNotificationModel.fromRemoteFCM(RemoteMessage message) {
    return AppNotificationModel(
      id: "",
      title: message.notification?.title ?? "",
      body: message.notification?.body,
      date: DateTime.now(),
    );
  }
  factory AppNotificationModel.fromDatabaseJson(Map<String, Object?> json) {
    List<String>? decodeList(dynamic v) {
      if (v == null) return null;
      try {
        final decoded = jsonDecode(v as String);
        if (decoded is List) {
          return decoded.map((e) => e.toString()).toList();
        }
      } catch (_) {}
      return null;
    }

    return AppNotificationModel(
      id: json['id'] as String,
      title: json['title'] as String,
      body: json['body'] as String?,
      imageUrl: json['image_url'] as String?,
      html: json['html'] as String?,
      date: DateTime.parse(json['date'] as String),
      type: json['type'] as String?,
      targetUserIds: decodeList(json['target_user_ids']),
      targetTopics: decodeList(json['target_topics']),
      sentBy: json['sent_by'] as String?,
      createdAt: (json['created_at'] as String?) != null
          ? DateTime.tryParse(json['created_at'] as String)
          : null,
      seen: (json['seen'] as int? ?? 0) == 1,
    );
  }

  Map<String, Object?> toDatabaseJson() {
    String? encodeList(List<String>? list) =>
        list == null ? null : jsonEncode(list);

    return <String, Object?>{
      'id': id,
      'title': title,
      'body': body,
      'image_url': imageUrl,
      'html': html,
      'date': date.toIso8601String(),
      'type': type,
      'target_user_ids': encodeList(targetUserIds),
      'target_topics': encodeList(targetTopics),
      'sent_by': sentBy,
      'created_at': createdAt?.toIso8601String(),
      'seen': seen ? 1 : 0,
    };
  }
}
