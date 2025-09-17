import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// Core
import 'package:tatbeeqi/core/routing/app_routes.dart';
import 'package:tatbeeqi/features/auth/presentation/manager/bloc/auth_bloc.dart';

// Modular route lists
import 'package:tatbeeqi/core/routing/routes/auth_routes.dart';
import 'package:tatbeeqi/core/routing/routes/news_routes.dart';
import 'package:tatbeeqi/core/routing/routes/courses_routes.dart';
import 'package:tatbeeqi/core/routing/routes/notes_routes.dart';
import 'package:tatbeeqi/core/routing/routes/quiz_routes.dart';
import 'package:tatbeeqi/core/routing/routes/streaks_routes.dart';
import 'package:tatbeeqi/core/routing/routes/todo_routes.dart';
import 'package:tatbeeqi/core/routing/routes/navigation_routes.dart';

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
      if (!loggedIn && !goingToAuth) return AppRoutes.signIn;
      if (loggedIn && goingToAuth) return AppRoutes.home;
      return null;
    },
    routes: <RouteBase>[
      ...navigationRoutes,
      ...authRoutes,
      ...newsRoutes,
      ...todoRoutes,
      ...coursesRoutes,
      ...notesRoutes,
      ...quizRoutes,
      ...streaksRoutes,
    ],
    errorBuilder: (context, state) => Scaffold(
      appBar: AppBar(title: const Text('Page Not Found')),
      body: Center(child: Text('Route not found: ${state.error}')),
    ),
  );
}
