import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// Core
import 'package:tatbeeqi/core/routing/app_routes.dart';
import 'package:tatbeeqi/core/routing/routes_args.dart';

import 'package:tatbeeqi/features/auth/presentation/manager/bloc/auth_bloc.dart';
import 'package:tatbeeqi/features/auth/presentation/views/forget_password_page.dart';
import 'package:tatbeeqi/features/auth/presentation/views/sign_in_page.dart';
import 'package:tatbeeqi/features/auth/presentation/views/sign_up_page.dart';
import 'package:tatbeeqi/features/courses/domain/entities/course_entity.dart';
import 'package:tatbeeqi/features/courses_content/presentation/views/course_lectures_view.dart';

// Features
import 'package:tatbeeqi/features/courses_content/presentation/views/course_overview_view.dart';
import 'package:tatbeeqi/features/courses_content/presentation/views/lecture_lessons_view.dart';
import 'package:tatbeeqi/features/courses_content/presentation/views/lesson_content_view.dart';
import 'package:tatbeeqi/features/navigation/presentation/screens/main_navigation_screen.dart';
import 'package:tatbeeqi/features/news/presentation/views/all_news_view.dart';
import 'package:tatbeeqi/features/news/presentation/views/news_details_view.dart';
import 'package:tatbeeqi/features/notes/presentation/views/add_update_note_view.dart';
import 'package:tatbeeqi/features/quiz/presentation/views/result_view.dart';

import 'package:tatbeeqi/features/settings/presentation/screens/settings_screen.dart';
// import 'package:tatbeeqi/features/quiz/presentation/views/quiz_view.dart';
import 'package:tatbeeqi/features/streaks/presentation/views/streaks_view.dart';
import 'package:tatbeeqi/features/todo/presentation/views/todo_view.dart';

class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    _sub = stream.asBroadcastStream().listen((_) => notifyListeners());
  }
  late final StreamSubscription _sub;

  @override
  void dispose() {
    _sub.cancel();
    super.dispose();
  }
}

GoRouter createRouter(AuthBloc authBloc) {
  return GoRouter(
    initialLocation: AppRoutes.home,
    refreshListenable: GoRouterRefreshStream(authBloc.stream),
    redirect: (context, state) {
      final loggedIn = authBloc.state is AuthAuthenticated;
      final goingToAuth = state.uri.path.startsWith('/auth');
      if (!loggedIn && !goingToAuth) return AppRoutes.signInPath;
      if (loggedIn && goingToAuth) return AppRoutes.home;
      return null;
    },
    routes: <RouteBase>[
      GoRoute(
        path: AppRoutes.home,
        builder: (BuildContext context, GoRouterState state) {
          return const MainNavigationScreen();
        },
      ),
      GoRoute(
        path: AppRoutes.settingsPath,
        builder: (BuildContext context, GoRouterState state) {
          return const SettingsView();
        },
      ),
      GoRoute(
        path: AppRoutes.allNewsPath,
        builder: (BuildContext context, GoRouterState state) {
          return const AllNewsView();
        },
      ),
      GoRoute(
        path: AppRoutes.todoPath,
        builder: (BuildContext context, GoRouterState state) {
          return const TodoView();
        },
      ),
      GoRoute(
        path: AppRoutes.signInPath,
        builder: (BuildContext context, GoRouterState state) {
          return const SignInPage();
        },
      ),
      GoRoute(
        path: AppRoutes.signUpPath,
        builder: (BuildContext context, GoRouterState state) {
          return const SignUpPage();
        },
      ),
      GoRoute(
        path: AppRoutes.forgetPasswordPath,
        builder: (BuildContext context, GoRouterState state) {
          return const ForgetPasswordPage();
        },
      ),
      GoRoute(
        path: AppRoutes.courseOverviewPath,
        builder: (BuildContext context, GoRouterState state) {
          final args = state.extra as CourseOverviewArgs?;
          if (args == null) {
            // Handle null case - navigate back or show error
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
        path: AppRoutes.lectureLessonsPath,
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
        path: AppRoutes.courseLecturesPath,
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
        path: AppRoutes.lessonContentPath,
        pageBuilder: (context, state) {
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
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
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
      GoRoute(
        path: AppRoutes.newsDetailsPath,
        name: 'newsDetails',
        builder: (context, state) {
          final args = state.extra as NewsDetailsArgs?;
          if (args == null) {
            return const Scaffold(
              body: Center(
                child: Text('Invalid news data'),
              ),
            );
          }
          return NewsDetailsView(
              newsItem: args.newsItem, heroTag: args.heroTag);
        },
      ),
      GoRoute(
        path: AppRoutes.addUpdateNotePath,
        builder: (context, state) {
          final args = state.extra as AddUpdateNoteArgs?;
          if (args == null) {
            return const Scaffold(
              body: Center(
                child: Text('Invalid note data'),
              ),
            );
          }
          if (args.note == null) {
            return AddOrUpdateNoteView(courseId: args.courseId);
          } else {
            return AddOrUpdateNoteView(
                courseId: args.courseId, note: args.note);
          }
        },
      ),
      // GoRoute(
      //   path: AppRoutes.quizPath,
      //   builder: (BuildContext context, GoRouterState state) {
      //     final lessonId = state.extra as int;
      //     return QuizView(lessonId: lessonId);
      //   },
      // ),
      GoRoute(
        path: AppRoutes.quizResultPath,
        builder: (BuildContext context, GoRouterState state) {
          final args = state.extra as QuizResultArgs?;
          if (args == null) {
            return const Scaffold(
              body: Center(
                child: Text('Invalid quiz result data'),
              ),
            );
          }
          return ResultView(
            score: args.score,
            results: args.results,
            questions: args.questions,
            userAnswers: args.userAnswers,
          );
        },
      ),
      GoRoute(
        path: AppRoutes.streaksPath,
        builder: (BuildContext context, GoRouterState state) {
          return const StreaksView();
        },
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      appBar: AppBar(title: const Text('Page Not Found')),
      body: Center(child: Text('Route not found: ${state.error}')),
    ),
  );
}
