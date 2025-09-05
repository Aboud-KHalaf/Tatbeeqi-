import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tatbeeqi/core/di/service_locator.dart';
import 'package:tatbeeqi/features/courses/domain/entities/course_entity.dart';
import 'package:tatbeeqi/features/courses_details.dart/presentation/manager/course_details_cubit.dart';
import 'package:tatbeeqi/features/courses_details.dart/presentation/views/course_details_view.dart';
 
class AboutCoursePage extends StatelessWidget {
  final Course course;
  const AboutCoursePage({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (context) => sl<CourseDetailsCubit>()..fetchCourseDetails(course.id),
        child: CourseDetailsView(courseId: course.id),
      ),
    );
  }
}
