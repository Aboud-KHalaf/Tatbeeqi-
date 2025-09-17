import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:tatbeeqi/core/routing/app_routes.dart';

import 'package:tatbeeqi/features/streaks/presentation/views/streaks_view.dart';

final List<GoRoute> streaksRoutes = <GoRoute>[
  GoRoute(
    path: AppRoutes.streaks,
    builder: (BuildContext context, GoRouterState state) {
      return const StreaksView();
    },
  ),
];
