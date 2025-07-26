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
      id: json['id'],
      lectureId: json['lecture_id'],
      title: json['title'],
      lessonType: _stringToContentType(json['lesson_type']),
      contentUrl: json['content_url'],
      content: json['content'],
      isDownloadable: json['is_downloadable'] ?? false,
      createdBy: json['created_by'],
      durationMinutes: json['duration_minutes'] ?? 0,
      publishedAt: json['published_at'] != null
          ? DateTime.parse(json['published_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
      summary: json['summary'],
      tags: (json['tags'] as List<dynamic>?)?.cast<String>(),
      isActive: json['is_active'] ?? true,
      language: json['language'] ?? 'arabic',
      isCompleted: isCompleted,
    );
  }

  static ContentType _stringToContentType(String value) {
    switch (value.toLowerCase()) {
      case 'video':
        return ContentType.video;
      case 'voice':
        return ContentType.voice;
      case 'reading':
        return ContentType.reading;
      case 'quiz':
        return ContentType.quiz;
      default:
        return ContentType.reading;
    }
  }
}
