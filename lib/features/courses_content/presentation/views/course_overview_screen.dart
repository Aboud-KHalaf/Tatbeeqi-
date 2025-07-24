import 'package:flutter/material.dart';
import 'package:tatbeeqi/features/courses/domain/entities/course_entity.dart';
import 'package:tatbeeqi/features/courses_details.dart/presentation/about_course_page.dart';
import 'package:tatbeeqi/features/references/presentation/views/references_view.dart';
import 'package:tatbeeqi/features/courses_content/presentation/widgets/course_overview_body.dart';
import 'package:tatbeeqi/features/courses_content/presentation/widgets/custom_course_content_app_bar_widget.dart';
import 'package:tatbeeqi/features/forums/presentation/views/forums_view.dart';
import 'package:tatbeeqi/features/grades/presentation/views/grades_page.dart';
import 'package:tatbeeqi/features/notes/presentation/views/notes_view.dart';

class CourseOverviewScreen extends StatefulWidget {
  final Course course;
  const CourseOverviewScreen({super.key, required this.course});
  static const String routePath = '/courseOverviewView';

  @override
  State<CourseOverviewScreen> createState() => _CourseOverviewScreenState();
}

class _CourseOverviewScreenState extends State<CourseOverviewScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 6, vsync: this);
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
      body: TabBarView(
        controller: _tabController,
        children: [
          CourseOverviewBody(tabController: _tabController , course: widget.course),
          const GradesView(),
          const ForumsView(),
           NotesView(courseId: widget.course.id),
          const ReferencesView(),
          const AboutCoursePage(),
        ],
      ),
    );
  }
}
