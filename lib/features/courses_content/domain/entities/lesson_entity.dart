import 'package:equatable/equatable.dart';

enum ContentType { video, voice, reading, quiz }

class Lesson extends Equatable {
  final int id;
  final int lectureId;
  final String title;
  final ContentType lessonType; 
  final String? contentUrl;
  final String? content;
  final bool isDownloadable;
  final String? createdBy;
  final int durationMinutes;
  final DateTime? publishedAt;
  final DateTime? updatedAt;
  final String? summary;
  final List<String>? tags;
  final bool isActive;
  final String language;
  final bool isCompleted;

  const Lesson({
    required this.id,
    required this.lectureId,
    required this.title,
    required this.lessonType,
    this.contentUrl,
    this.content,
    required this.isDownloadable,
    this.createdBy,
    required this.durationMinutes,
    this.publishedAt,
    this.updatedAt,
    this.summary,
    this.tags,
    required this.isActive,
    required this.language,
    required this.isCompleted,
  });

  @override
  List<Object?> get props => [
        id,
        lectureId,
        title,
        lessonType,
        contentUrl,
        content,
        isDownloadable,
        durationMinutes,
        isCompleted,
      ];
}
