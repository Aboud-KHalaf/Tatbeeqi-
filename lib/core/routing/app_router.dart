import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// Core
import 'package:tatbeeqi/core/routing/app_routes.dart';
import 'package:tatbeeqi/core/routing/routes_args.dart';

// Features
import 'package:tatbeeqi/features/courses_content/presentation/screens/course_overview_screen.dart';
import 'package:tatbeeqi/features/navigation/presentation/screens/main_navigation_screen.dart';
import 'package:tatbeeqi/features/news/presentation/views/all_news_view.dart';
import 'package:tatbeeqi/features/news/presentation/views/news_details_view.dart';
import 'package:tatbeeqi/features/notes/presentation/views/add_update_note_view.dart';
import 'package:tatbeeqi/features/settings/presentation/screens/settings_screen.dart';
import 'package:tatbeeqi/features/todo/presentation/views/todo_view.dart';

final GoRouter router = GoRouter(
  initialLocation: AppRoutes.home,
  debugLogDiagnostics: true,
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
      path: AppRoutes.courseOverviewPath,
      builder: (BuildContext context, GoRouterState state) {
        return const CourseOverview();
      },
    ),
    GoRoute(
      path: AppRoutes.newsDetailsPath,
      name: 'newsDetails',
      builder: (context, state) {
        final args = state.extra as NewsDetailsArgs;
        return NewsDetailsView(newsItem: args.newsItem, heroTag: args.heroTag);
      },
    ),
    GoRoute(
      path: AppRoutes.addUpdateNotePath,
      builder: (context, state) {
        final args = state.extra as AddUpdateNoteArgs;
        if (args.note == null) {
          return AddOrUpdateNoteView(courseId: args.courseId);
        } else {
          return AddOrUpdateNoteView(note: args.note, courseId: args.courseId);
        }
      },
    ),
  ],
  errorBuilder: (context, state) => Scaffold(
    appBar: AppBar(title: const Text('Page Not Found')),
    body: Center(child: Text('Route not found: ${state.error}')),
  ),
);
