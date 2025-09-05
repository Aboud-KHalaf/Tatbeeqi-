import 'package:tatbeeqi/features/notifications/domain/entities/reminder.dart';

class ReminderModel extends Reminder {
  const ReminderModel({
    required super.id,
    required super.days,
    required super.hour,
    required super.minute,
    required super.title,
    required super.body,
    super.isActive,
    super.courseId,
    required super.createdAt,
  });

  factory ReminderModel.fromJson(Map<String, dynamic> json) {
    return ReminderModel(
      id: json['id'] as String,
      days: _parseDaysFromString(json['days'] as String),
      hour: json['hour'] as int,
      minute: json['minute'] as int,
      title: json['title'] as String,
      body: json['body'] as String,
      isActive: (json['isActive'] as int) == 1,
      courseId: json['courseId'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'days': _daysToString(days),
      'hour': hour,
      'minute': minute,
      'title': title,
      'body': body,
      'isActive': isActive ? 1 : 0,
      'courseId': courseId,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  static List<int> _parseDaysFromString(String daysString) {
    if (daysString.isEmpty) return [];
    return daysString.split(',').map((e) => int.parse(e.trim())).toList();
  }

  static String _daysToString(List<int> days) {
    return days.join(',');
  }

  factory ReminderModel.fromEntity(Reminder reminder) {
    return ReminderModel(
      id: reminder.id,
      days: reminder.days,
      hour: reminder.hour,
      minute: reminder.minute,
      title: reminder.title,
      body: reminder.body,
      isActive: reminder.isActive,
      courseId: reminder.courseId,
      createdAt: reminder.createdAt,
    );
  }
}
