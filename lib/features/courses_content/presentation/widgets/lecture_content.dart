import 'package:flutter/material.dart';
import 'package:tatbeeqi/features/courses/domain/entities/course_entity.dart';
import 'package:tatbeeqi/features/courses_content/domain/entities/lecture_entity.dart';
import 'package:tatbeeqi/features/courses_content/domain/entities/lesson_entity.dart';
import 'package:tatbeeqi/features/courses_content/presentation/widgets/course_content_list.dart';
import 'package:tatbeeqi/features/courses_content/presentation/widgets/lecture_description_section.dart';
import 'package:tatbeeqi/features/courses_content/presentation/widgets/course_resources_card.dart';
import 'package:tatbeeqi/features/courses_content/presentation/widgets/module_progress_section.dart';
import 'package:tatbeeqi/features/courses_content/presentation/widgets/up_next_card.dart';

class LectureContent extends StatelessWidget {
  final Course course;
  final Lecture lecture;
  final List<Lesson> lessons;

  const LectureContent(
      {super.key,
      required this.course,
      required this.lessons,
      required this.lecture});

  @override
  Widget build(BuildContext context) {
    final Lesson? upNextItem = lessons.isNotEmpty
        ? lessons.cast<Lesson>().firstWhere(
              (lesson) => !lesson.isCompleted,
              orElse: () => lessons.first,
            )
        : null;
    Widget buildResponsiveLayout(BuildContext context, Widget content) {
      final screenWidth = MediaQuery.of(context).size.width;

      if (screenWidth > 1200) {
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(flex: 3, child: content),
            const Expanded(flex: 2, child: CourseResourcesCard()),
          ],
        );
      } else {
        return content;
      }
    }

    return buildResponsiveLayout(
      context,
      CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // const CourseLecturesList(),
                ModuleProgressSection(
                  completionPercentage: course.progressPercent ?? 0,
                ),
                const Divider(height: 16, indent: 12, endIndent: 12),
                if (upNextItem != null)
                  UpNextCard(
                    lesson: upNextItem,
                    onPressed: () {},
                  ),
                LectureDescriptionSection(lecture: lecture),
              ],
            ),
          ),
          CourseContentList(lessonsList: lessons),
          const SliverToBoxAdapter(child: SizedBox(height: 32)),
        ],
      ),
    );
  }
}
