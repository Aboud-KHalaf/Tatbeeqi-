import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// Core
import 'package:tatbeeqi/core/routing/app_routes.dart';

import 'package:tatbeeqi/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:tatbeeqi/features/auth/presentation/views/forget_password_page.dart';
import 'package:tatbeeqi/features/auth/presentation/views/sign_in_page.dart';
import 'package:tatbeeqi/features/auth/presentation/views/sign_up_page.dart';

// Features
import 'package:tatbeeqi/features/courses_content/presentation/screens/course_overview_screen.dart';
import 'package:tatbeeqi/features/navigation/presentation/screens/main_navigation_screen.dart';
import 'package:tatbeeqi/features/news/presentation/views/all_news_view.dart';

import 'package:tatbeeqi/features/settings/presentation/screens/settings_screen.dart';
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

    //debugLogDiagnostics: true,
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
          return const CourseOverview();
        },
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      appBar: AppBar(title: const Text('Page Not Found')),
      body: Center(child: Text('Route not found: ${state.error}')),
    ),
  );
}
