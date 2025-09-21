import 'package:go_router/go_router.dart';
import 'package:tatbeeqi/core/routing/app_routes.dart';
import 'package:tatbeeqi/features/notifications/presentation/views/notifications_view.dart';

final List<GoRoute> notificationsRoutes = <GoRoute>[
  GoRoute(
    path: AppRoutes.notifications,
    builder: (context, state) => const NotificationsView(),
  ),
];
