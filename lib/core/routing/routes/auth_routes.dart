import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:tatbeeqi/core/routing/app_routes.dart';

import 'package:tatbeeqi/features/auth/presentation/views/forget_password_page.dart';
import 'package:tatbeeqi/features/auth/presentation/views/sign_in_page.dart';
import 'package:tatbeeqi/features/auth/presentation/views/sign_up_page.dart';

final List<GoRoute> authRoutes = <GoRoute>[
  GoRoute(
    path: AppRoutes.signIn,
    builder: (BuildContext context, GoRouterState state) {
      return const SignInPage();
    },
  ),
  GoRoute(
    path: AppRoutes.signUp,
    builder: (BuildContext context, GoRouterState state) {
      return const SignUpPage();
    },
  ),
  GoRoute(
    path: AppRoutes.forgetPassword,
    builder: (BuildContext context, GoRouterState state) {
      return const ForgetPasswordPage();
    },
  ),
];
