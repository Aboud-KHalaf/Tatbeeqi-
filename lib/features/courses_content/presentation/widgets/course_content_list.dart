import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tatbeeqi/core/routing/app_routes.dart';
import 'package:tatbeeqi/features/courses_content/domain/entities/lesson_entity.dart';
import 'package:tatbeeqi/features/courses_content/presentation/widgets/course_content_card.dart';

class CourseContentList extends StatelessWidget {
  final List<Lesson> lessonsList;

  const CourseContentList({super.key, required this.lessonsList});

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final item = lessonsList[index];
          return CourseContentCard(
            lessonItem: item,
            onTap: () {
              context.push(AppRoutes.lessonContentPath, extra: item);
            },
          );
        },
        childCount: lessonsList.length,
      ),
    );
  }
}
