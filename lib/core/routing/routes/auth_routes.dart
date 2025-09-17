import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:tatbeeqi/core/routing/app_routes.dart';

import 'package:tatbeeqi/features/auth/presentation/views/forget_password_page.dart';
import 'package:tatbeeqi/features/auth/presentation/views/sign_in_page.dart';
import 'package:tatbeeqi/features/auth/presentation/views/sign_up_page.dart';

final List<GoRoute> authRoutes = <GoRoute>[
  GoRoute(
    path: AppRoutes.signIn,
    pageBuilder: (BuildContext context, GoRouterState state) {
      return CustomTransitionPage<void>(
        key: state.pageKey,
        child: const SignInPage(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          // Slide from left → right
          const begin = Offset(-1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.easeInOut;
          final tween =
              Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
      );
    },
  ),
  GoRoute(
    path: AppRoutes.signUp,
    pageBuilder: (BuildContext context, GoRouterState state) {
      return CustomTransitionPage<void>(
        key: state.pageKey,
        child: const SignUpPage(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          // Slide from right → left
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.easeInOut;
          final tween =
              Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
      );
    },
  ),
  GoRoute(
    path: AppRoutes.forgetPassword,
    pageBuilder: (BuildContext context, GoRouterState state) {
      return CustomTransitionPage<void>(
        key: state.pageKey,
        child: const ForgetPasswordPage(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
      );
    },
  ),
];
