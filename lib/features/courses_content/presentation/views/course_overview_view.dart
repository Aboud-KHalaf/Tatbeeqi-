import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tatbeeqi/features/courses/domain/entities/course_entity.dart';
import 'package:tatbeeqi/features/courses_content/presentation/manager/lectures/lectures_cubit.dart';
import 'package:tatbeeqi/features/courses_content/presentation/views/course_lectures_view.dart';
import 'package:tatbeeqi/features/courses_details.dart/presentation/about_course_page.dart';
import 'package:tatbeeqi/features/references/presentation/views/references_view.dart';
import 'package:tatbeeqi/features/courses_content/presentation/widgets/custom_course_content_app_bar_widget.dart';
import 'package:tatbeeqi/features/grades/presentation/views/grades_page.dart';
import 'package:tatbeeqi/features/notes/presentation/views/notes_view.dart';

class CourseOverviewView extends StatefulWidget {
  final Course course;
  const CourseOverviewView({super.key, required this.course});
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
    _tabController = TabController(length: 5, vsync: this);
    context.read<LecturesCubit>().fetchLectures(widget.course.id);

    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {}
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
      body: TabBarView(
        controller: _tabController,
        children: [
          CourseLecturesView(course: widget.course),
          const GradesView(),
          NotesView(course: widget.course),
          const ReferencesView(),
          const AboutCoursePage(),
        ],
      ),
    );
  }
}
