import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tatbeeqi/features/courses/domain/entities/course_entity.dart';
import 'package:tatbeeqi/features/courses_content/domain/entities/lecture_entity.dart';
import 'package:tatbeeqi/features/courses_content/presentation/manager/lessons/lessons_cubit.dart';
import 'package:tatbeeqi/features/courses_details.dart/presentation/about_course_page.dart';
import 'package:tatbeeqi/features/references/presentation/views/references_view.dart';
import 'package:tatbeeqi/features/courses_content/presentation/widgets/course_overview_body.dart';
import 'package:tatbeeqi/features/courses_content/presentation/widgets/custom_course_content_app_bar_widget.dart';
import 'package:tatbeeqi/features/grades/presentation/views/grades_page.dart';
import 'package:tatbeeqi/features/notes/presentation/views/notes_view.dart';

class CourseOverviewView extends StatefulWidget {
  final Lecture lecture;
  final Course course;
  const CourseOverviewView(
      {super.key, required this.lecture, required this.course});
  static const String routePath = '/courseOverviewView';

  @override
  State<CourseOverviewView> createState() => _CourseOverviewViewState();
}

class _CourseOverviewViewState extends State<CourseOverviewView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    context.read<LessonsCubit>().fetchLessons(widget.lecture.id);
    _tabController = TabController(length: 5, vsync: this);
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        // Handle tab change here
        print('Tab changed to ${_tabController.index}');
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(tabController: _tabController),
      body: BlocBuilder<LessonsCubit, LessonsState>(
        builder: (context, state) {
          return TabBarView(
            controller: _tabController,
            children: [
              if (state is LessonsLoaded)
                CourseOverviewBody(
                    course: widget.course,
                    tabController: _tabController,
                    lessons: state.lessons),
              if (state is LessonsLoading) const CircularProgressIndicator(),
              if (state is LessonsError) Text(state.message),
              const GradesView(),
              NotesView(courseId: widget.course.id),
              const ReferencesView(),
              const AboutCoursePage(),
            ],
          );
        },
      ),
    );
  }
}
