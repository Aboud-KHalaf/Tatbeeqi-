import 'package:flutter/material.dart';
import 'package:tatbeeqi/features/courses_content/domain/entities/lesson_entity.dart';

class LessonContent extends StatelessWidget {
  final Lesson lesson;
  const LessonContent({super.key, required this.lesson});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _lessonContentByType(),
    );
  }

  Widget _lessonContentByType() {
    if (lesson.lessonType == ContentType.pdf) {
      return Container();
    } else if (lesson.lessonType == ContentType.voice) {
      return Container();
    } else if (lesson.lessonType == ContentType.video) {
      return Container();
    } else if (lesson.lessonType == ContentType.quiz) {
      return Container();
    } else if (lesson.lessonType == ContentType.quiz) {
      return Container();
    }
    return Container();
  }
}
