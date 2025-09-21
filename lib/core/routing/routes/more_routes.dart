import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:tatbeeqi/core/routing/app_routes.dart';

// Views
import 'package:tatbeeqi/features/auth/presentation/views/update_profile_page.dart';
import 'package:tatbeeqi/features/more/presentation/views/help_suppurt_view.dart';
import 'package:tatbeeqi/features/more/presentation/views/about_app_view.dart';
import 'package:tatbeeqi/features/more/presentation/views/privacy_view.dart';
import 'package:tatbeeqi/features/posts/presentation/views/my_posts_view.dart';
import 'package:tatbeeqi/features/reports/presentation/views/my_reports_view.dart';
import 'package:tatbeeqi/features/notifications/presentation/views/my_reminders_view.dart';
import 'package:tatbeeqi/features/notifications/presentation/views/notifications_settings_view.dart';

// Optional: Providers for certain screens
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tatbeeqi/core/di/service_locator.dart';
import 'package:tatbeeqi/features/posts/presentation/manager/my_posts/my_posts_cubit.dart';
import 'package:tatbeeqi/features/notifications/presentation/manager/reminders_cubit/reminders_cubit.dart';

final List<GoRoute> moreRoutes = <GoRoute>[
  // Account / Profile
  GoRoute(
    path: AppRoutes.updateProfile,
    builder: (BuildContext context, GoRouterState state) => const UpdateProfilePage(),
  ),

  // Additional settings
  GoRoute(
    path: AppRoutes.helpSupport,
    builder: (BuildContext context, GoRouterState state) => const HelpSupportScreen(),
  ),
  GoRoute(
    path: AppRoutes.aboutApp,
    builder: (BuildContext context, GoRouterState state) => const AboutAppScreen(),
  ),
  GoRoute(
    path: AppRoutes.privacy,
    builder: (BuildContext context, GoRouterState state) => const PrivacyScreen(),
  ),

  // Shortcuts
  GoRoute(
    path: AppRoutes.myPosts,
    builder: (BuildContext context, GoRouterState state) => BlocProvider(
      create: (_) => sl<MyPostsCubit>(),
      child: const MyPostsView(),
    ),
  ),
  GoRoute(
    path: AppRoutes.myReports,
    builder: (BuildContext context, GoRouterState state) => const MyReportsView(),
  ),
  GoRoute(
    path: AppRoutes.myReminders,
    builder: (BuildContext context, GoRouterState state) => BlocProvider(
      create: (_) => sl<RemindersCubit>(),
      child: const MyRemindersView(),
    ),
  ),

  // Notifications settings
  GoRoute(
    path: AppRoutes.notificationSettings,
    builder: (BuildContext context, GoRouterState state) => const NotificationsSettingsView(),
  ),
];
