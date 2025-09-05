import 'package:flutter/material.dart';
import 'package:tatbeeqi/features/courses_details.dart/domain/entities/course_details.dart';
import 'package:tatbeeqi/features/courses_details.dart/presentation/widgets/course_info_card.dart';
import 'package:tatbeeqi/features/courses_details.dart/presentation/widgets/course_schedule_card.dart';
import 'package:tatbeeqi/features/courses_details.dart/presentation/widgets/course_contributors_card.dart';

class CourseDetailsContent extends StatelessWidget {
  final CourseDetails courseDetails;

  const CourseDetailsContent({
    super.key,
    required this.courseDetails,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CourseInfoCard(courseDetails: courseDetails),
          const SizedBox(height: 16),
          if (courseDetails.schedule != null)
            CourseScheduleCard(schedule: courseDetails.schedule!),
          const SizedBox(height: 16),
          if (courseDetails.contributors != null && courseDetails.contributors!.isNotEmpty)
            CourseContributorsCard(contributors: courseDetails.contributors!),
        ],
      ),
    );
  }
}
