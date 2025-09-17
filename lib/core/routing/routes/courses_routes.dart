import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:tatbeeqi/core/routing/app_routes.dart';
import 'package:tatbeeqi/core/routing/routes_args.dart';

import 'package:tatbeeqi/features/courses/domain/entities/course_entity.dart';
import 'package:tatbeeqi/features/courses_content/presentation/views/course_lectures_view.dart';
import 'package:tatbeeqi/features/courses_content/presentation/views/course_overview_view.dart';
import 'package:tatbeeqi/features/courses_content/presentation/views/lecture_lessons_view.dart';
import 'package:tatbeeqi/features/courses_content/presentation/views/lesson_content_view.dart';

final List<GoRoute> coursesRoutes = <GoRoute>[
  GoRoute(
    path: AppRoutes.courseOverview,
    builder: (BuildContext context, GoRouterState state) {
      final args = state.extra as CourseOverviewArgs?;
      if (args == null) {
        return const Scaffold(
          body: Center(
            child: Text('Invalid course data'),
          ),
        );
      }
      return CourseOverviewView(
        course: args.course,
      );
    },
  ),
  GoRoute(
    path: AppRoutes.lectureLessons,
    builder: (BuildContext context, GoRouterState state) {
      final args = state.extra as LectureLessonsArgs?;
      if (args == null) {
        return const Scaffold(
          body: Center(
            child: Text('Invalid navigation arguments'),
          ),
        );
      }
      return LectureLessonsView(
        course: args.course,
        lecture: args.lecture,
      );
    },
  ),
  GoRoute(
    path: AppRoutes.courseLectures,
    builder: (BuildContext context, GoRouterState state) {
      final args = state.extra as Course?;
      if (args == null) {
        return const Scaffold(
          body: Center(
            child: Text('Invalid course data'),
          ),
        );
      }
      return CourseLecturesView(course: args);
    },
  ),
  GoRoute(
    path: AppRoutes.lessonContent,
    pageBuilder: (BuildContext context, GoRouterState state) {
      final args = state.extra as LessonContentArgs?;
      if (args == null) {
        return const NoTransitionPage(
          child: Scaffold(
            body: Center(
              child: Text('Invalid lesson data'),
            ),
          ),
        );
      }
      return CustomTransitionPage<void>(
        key: state.pageKey,
        child: LessonContentView(
          lesson: args.lesson,
          courseId: args.courseId,
          index: args.index,
        ),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(-1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.easeInOut;
          var tween = Tween(begin: begin, end: end).chain(
            CurveTween(curve: curve),
          );
          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 300),
      );
    },
  ),
];
