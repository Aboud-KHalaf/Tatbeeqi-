import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:tatbeeqi/core/routing/app_routes.dart';
import 'package:tatbeeqi/core/routing/routes_args.dart';

import 'package:tatbeeqi/features/posts/presentation/views/post_details_view.dart';
import 'package:tatbeeqi/features/posts/presentation/views/create_post_view.dart';

final List<GoRoute> postsRoutes = <GoRoute>[
  GoRoute(
    path: AppRoutes.postDetails,
    pageBuilder: (BuildContext context, GoRouterState state) {
      final args = state.extra as PostDetailsArgs?;
      if (args == null) {
        return const NoTransitionPage(
          child: Scaffold(
            body: Center(child: Text('Invalid post data')),
          ),
        );
      }
      return CustomTransitionPage<void>(
        key: state.pageKey,
        child: PostDetailsView(post: args.post, showMore: args.showMore),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      );
    },
  ),
  GoRoute(
    path: AppRoutes.createOrEditPost,
    builder: (BuildContext context, GoRouterState state) {
      final args = state.extra as CreateOrEditPostArgs?;
      return CreatePostView(postToEdit: args?.postToEdit);
    },
  ),
];
