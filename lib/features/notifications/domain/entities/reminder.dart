import 'package:equatable/equatable.dart';

class Reminder extends Equatable {
  final String id;
  final List<int> days; // 1-7 (Monday to Sunday)
  final int hour; // 0-23
  final int minute; // 0-59
  final String title;
  final String body;
  final bool isActive;
  final String? courseId;
  final DateTime createdAt;

  const Reminder({
    required this.id,
    required this.days,
    required this.hour,
    required this.minute,
    required this.title,
    required this.body,
    this.isActive = true,
    this.courseId,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
        id,
        days,
        hour,
        minute,
        title,
        body,
        isActive,
        courseId,
        createdAt,
      ];

  Reminder copyWith({
    String? id,
    List<int>? days,
    int? hour,
    int? minute,
    String? title,
    String? body,
    bool? isActive,
    String? courseId,
    DateTime? createdAt,
  }) {
    return Reminder(
      id: id ?? this.id,
      days: days ?? this.days,
      hour: hour ?? this.hour,
      minute: minute ?? this.minute,
      title: title ?? this.title,
      body: body ?? this.body,
      isActive: isActive ?? this.isActive,
      courseId: courseId ?? this.courseId,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
