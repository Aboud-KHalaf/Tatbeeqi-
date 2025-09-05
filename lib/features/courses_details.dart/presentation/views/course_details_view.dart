import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tatbeeqi/features/courses_details.dart/presentation/manager/course_details_cubit.dart';
import 'package:tatbeeqi/features/courses_details.dart/presentation/manager/course_details_state.dart';
import 'package:tatbeeqi/features/courses_details.dart/presentation/widgets/course_details_content.dart';
import 'package:tatbeeqi/features/courses_details.dart/presentation/widgets/course_details_error_widget.dart';
import 'package:tatbeeqi/features/courses_details.dart/presentation/widgets/course_details_loading_widget.dart';

class CourseDetailsView extends StatefulWidget {
  final int courseId;

  const CourseDetailsView({
    super.key,
    required this.courseId,
  });

  @override
  State<CourseDetailsView> createState() => _CourseDetailsViewState();
}

class _CourseDetailsViewState extends State<CourseDetailsView> {
 

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CourseDetailsCubit, CourseDetailsState>(
      builder: (context, state) {
        if (state is CourseDetailsLoading) {
          return const CourseDetailsLoadingWidget();
        } else if (state is CourseDetailsSuccess) {
          return CourseDetailsContent(courseDetails: state.courseDetails);
        } else if (state is CourseDetailsError) {
          return CourseDetailsErrorWidget(
            message: state.message,
            onRetry: () => context
                .read<CourseDetailsCubit>()
                .fetchCourseDetails(widget.courseId),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
