import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tatbeeqi/core/routing/app_routes.dart';
import 'package:tatbeeqi/features/feedbacks/presentation/views/my_feedbacks_view.dart';

final List<GoRoute> feedbackRoutes = <GoRoute>[
  // BlocProvider(
  //         create: (context) => GetIt.instance<FeedbackCubit>(),
  //         child: const MyFeedbacksView(),
  //       ),

  GoRoute(
    path: AppRoutes.myFeedbacks,
    builder: (BuildContext context, GoRouterState state) {
      return const MyFeedbacksView();
    },
  ),
];
