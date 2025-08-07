import 'package:flutter/material.dart';
import 'package:tatbeeqi/features/courses_content/domain/entities/lesson_entity.dart';

class LessonHelper {
  static String getTypeText(ContentType type, BuildContext context) {
    switch (type) {
      case ContentType.video:
        return 'فيديو';
      case ContentType.voice:
        return 'صوت';
      case ContentType.reading:
        return 'قراءة';
      case ContentType.quiz:
        return 'اختبار';
      case ContentType.pdf:
        return 'pdf';
    }
  }

  static Color getTypeColor(ContentType type, ColorScheme colorScheme) {
    switch (type) {
      case ContentType.video:
        return Colors.red.shade600;
      case ContentType.voice:
        return Colors.orange.shade600;
      case ContentType.reading:
        return Colors.blue.shade600;
      case ContentType.quiz:
        return Colors.purple.shade600;
      case ContentType.pdf:
        return Colors.yellow.shade600;
    }
  }

  static IconData getIcon(ContentType type) {
    switch (type) {
      case ContentType.video:
        return Icons.play_arrow;
      case ContentType.voice:
        return Icons.headset;
      case ContentType.reading:
        return Icons.book;
      case ContentType.quiz:
        return Icons.quiz;
      case ContentType.pdf:
        return Icons.picture_as_pdf;
    }
  }

  static Color getIconColor(ContentType type, ColorScheme colorScheme) {
    switch (type) {
      case ContentType.video:
        return Colors.red.shade600;
      case ContentType.voice:
        return Colors.orange.shade600;
      case ContentType.reading:
        return Colors.blue.shade600;
      case ContentType.quiz:
        return Colors.purple.shade600;
      case ContentType.pdf:
        return Colors.yellow.shade600;
    }
  }
}
