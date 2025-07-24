import '../../domain/entities/lesson_entity.dart';

class LessonModel extends Lesson {
  const LessonModel({
    required super.id,
    required super.lectureId,
    required super.title,
    required super.lessonType,
    required super.contentUrl,
    super.content,
    required super.isDownloadable,
    super.createdBy,
    required super.durationMinutes,
    super.publishedAt,
    super.updatedAt,
    super.summary,
    super.tags,
    required super.isActive,
    required super.language,
    required super.isCompleted,
  });

  factory LessonModel.fromJson(Map<String, dynamic> json,
      {bool isCompleted = false}) {
    return LessonModel(
      isActive: json['is_active'],
      language: json['language'] ?? 'arbic',
      isCompleted: isCompleted,
      id: json['id'],
      createdBy: json['created_by'] ?? '',
      durationMinutes: json['duration_minutes'] ?? 0,
      lectureId: json['lecture_id'],
      title: json['title'],
      lessonType: json['lesson_type'],
      contentUrl: json['content_url'],
      content: json['content'],
      isDownloadable: json['is_downloadable'] ?? false,
    );
  }
}
