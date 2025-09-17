import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:tatbeeqi/core/routing/app_routes.dart';

import 'package:tatbeeqi/features/more/presentation/views/more_view.dart';
import 'package:tatbeeqi/features/navigation/presentation/screens/main_navigation_screen.dart';

final List<GoRoute> navigationRoutes = <GoRoute>[
  GoRoute(
    path: AppRoutes.home,
    builder: (BuildContext context, GoRouterState state) {
      return const MainNavigationScreen();
    },
  ),
  GoRoute(
    path: AppRoutes.settings,
    builder: (BuildContext context, GoRouterState state) {
      return const MoreView();
    },
  ),
];
