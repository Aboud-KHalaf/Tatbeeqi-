import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:tatbeeqi/core/routing/app_routes.dart';
import 'package:tatbeeqi/core/routing/routes_args.dart';

import 'package:tatbeeqi/features/news/presentation/views/all_news_view.dart';
import 'package:tatbeeqi/features/news/presentation/views/news_details_view.dart';

final List<GoRoute> newsRoutes = <GoRoute>[
  GoRoute(
    path: AppRoutes.allNews,
    builder: (BuildContext context, GoRouterState state) {
      return const AllNewsView();
    },
  ),
  GoRoute(
    path: AppRoutes.newsDetails,
    name: 'newsDetails',
    builder: (BuildContext context, GoRouterState state) {
      final args = state.extra as NewsDetailsArgs?;
      if (args == null) {
        return const Scaffold(
          body: Center(
            child: Text('Invalid news data'),
          ),
        );
      }
      return NewsDetailsView(newsItem: args.newsItem, heroTag: args.heroTag);
    },
  ),
];
