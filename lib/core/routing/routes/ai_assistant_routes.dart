import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tatbeeqi/core/routing/app_routes.dart';
import 'package:tatbeeqi/features/ai_assistant/presentation/views/labeb_ai_assistant_view.dart';

final List<GoRoute> aiAssistantRoutes = <GoRoute>[
  GoRoute(
    path: AppRoutes.labebAiAssistant,
    builder: (BuildContext context, GoRouterState state) {
      return const LabebAiAssistantView();
    },
  ),
];
