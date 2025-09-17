import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:tatbeeqi/core/routing/app_routes.dart';

import 'package:tatbeeqi/features/todo/presentation/views/todo_view.dart';

final List<GoRoute> todoRoutes = <GoRoute>[
  GoRoute(
    path: AppRoutes.todo,
    builder: (BuildContext context, GoRouterState state) {
      return const TodoView();
    },
  ),
];
