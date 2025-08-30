import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tatbeeqi/core/widgets/app_error.dart';
import 'package:tatbeeqi/core/widgets/app_loading.dart';
import 'package:tatbeeqi/features/courses/domain/entities/course_entity.dart';
import 'package:tatbeeqi/features/courses_content/domain/entities/lecture_entity.dart';
import 'package:tatbeeqi/features/courses_content/presentation/manager/lessons/lessons_cubit.dart';
import 'package:tatbeeqi/features/courses_content/presentation/widgets/lecture_content.dart';

class LectureLessonsView extends StatefulWidget {
  static const String routePath = '/lectureLessonsView';
  final Course course;
  final Lecture lecture;
  const LectureLessonsView(
      {super.key, required this.course, required this.lecture});

  @override
  State<LectureLessonsView> createState() => _LectureLessonsViewState();
}

class _LectureLessonsViewState extends State<LectureLessonsView> {
  @override
  void initState() {
    super.initState();
    context.read<LessonsCubit>().fetchLessons(widget.lecture.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(' ${widget.lecture.title}'),
      ),
      body: BlocBuilder<LessonsCubit, LessonsState>(
        builder: (context, state) {
          if (state is LessonsLoaded) {
            return LectureContent(
                course: widget.course,
                lessons: state.lessons,
                lecture: widget.lecture);
          }
          if (state is LessonsLoading) {
            return const AppLoading(
              message: "جاري تحميل الدروس",
            );
          }
          if (state is LessonsError) {
            return AppError(message: state.message);
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
