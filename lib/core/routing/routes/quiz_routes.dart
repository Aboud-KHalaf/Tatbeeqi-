import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:tatbeeqi/core/routing/app_routes.dart';
import 'package:tatbeeqi/core/routing/routes_args.dart';

import 'package:tatbeeqi/features/quiz/presentation/views/result_view.dart';

final List<GoRoute> quizRoutes = <GoRoute>[
  GoRoute(
    path: AppRoutes.quizResult,
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
];
