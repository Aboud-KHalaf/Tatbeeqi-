import 'package:flutter/material.dart';
import 'package:tatbeeqi/core/utils/app_data.dart';
import 'package:tatbeeqi/features/courses_content/presentation/widgets/course_content_list.dart';
import 'package:tatbeeqi/features/courses_content/presentation/widgets/course_description_section.dart';
import 'package:tatbeeqi/features/courses_content/presentation/widgets/course_lectures_list.dart';
import 'package:tatbeeqi/features/courses_content/presentation/widgets/course_resources_card.dart';
import 'package:tatbeeqi/features/courses_content/presentation/widgets/module_progress_section.dart';
import 'package:tatbeeqi/features/courses_content/presentation/widgets/up_next_card.dart';

class CourseOverviewBody extends StatelessWidget {
  final TabController tabController;

  const CourseOverviewBody({super.key, required this.tabController});

  @override
  Widget build(BuildContext context) {
    final upNextItem = contentItems.firstWhere(
      (item) => !item.isCompleted,
      orElse: () => contentItems.first,
    );

    final completedItems =
        contentItems.where((item) => item.isCompleted).length;
    final completionPercentage = completedItems / contentItems.length;

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
                const CourseLecturesList(),
                ModuleProgressSection(
                  completionPercentage: completionPercentage,
                ),
                const Divider(height: 16, indent: 12, endIndent: 12),
                UpNextCard(
                  contentItem: upNextItem,
                  onPressed: () {},
                ),
                const CourseDescriptionSection(),
              ],
            ),
          ),
          CourseContentList(items: contentItems),
          const SliverToBoxAdapter(child: SizedBox(height: 32)),
        ],
      ),
    );
  }
}
