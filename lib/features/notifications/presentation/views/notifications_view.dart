import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:tatbeeqi/core/widgets/app_error.dart';
import 'package:tatbeeqi/core/widgets/app_loading.dart';
import 'package:tatbeeqi/features/notifications/domain/entities/app_notification.dart';
import 'package:tatbeeqi/features/notifications/presentation/manager/notifications_bloc/notifications_bloc.dart';

class NotificationsView extends StatefulWidget {
  const NotificationsView({super.key});

  @override
  State<NotificationsView> createState() => _NotificationsViewState();
}

class _NotificationsViewState extends State<NotificationsView> {
  late final NotificationsBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = GetIt.instance<NotificationsBloc>();
    _bloc.add(GetNotifications());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _bloc,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('الإشعارات'),
        ),
        body: BlocBuilder<NotificationsBloc, NotificationsState>(
          builder: (context, state) {
            if (state is NotificationsLoading ||
                state is NotificationsInitial) {
              return const AppLoading();
            }
            if (state is NotificationsFailure) {
              return AppError(onAction: () => _bloc.add(GetNotifications()));
            }
            if (state is NotificationsLoaded) {
              if (state.notifications.isEmpty) {
                return const _Empty();
              }
              return RefreshIndicator(
                onRefresh: () async => _bloc.add(GetNotifications()),
                child: ListView.separated(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                  itemCount: state.notifications.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemBuilder: (context, index) => _NotificationTile(
                    notification: state.notifications[index],
                  ),
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}

class _Empty extends StatelessWidget {
  const _Empty();
  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.notifications_off_outlined,
              size: 56, color: color.outline),
          const SizedBox(height: 12),
          Text('لا توجد إشعارات',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(color: color.onSurfaceVariant)),
        ],
      ),
    );
  }
}

class _NotificationTile extends StatelessWidget {
  final AppNotification notification;
  const _NotificationTile({required this.notification});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = theme.colorScheme;
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: CircleAvatar(
          backgroundColor: color.primaryContainer,
          child: Icon(Icons.notifications_rounded,
              color: color.onPrimaryContainer),
        ),
        title: Text(notification.title,
            style: theme.textTheme.titleMedium
                ?.copyWith(fontWeight: FontWeight.w600)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if ((notification.body ?? '').isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Text(
                  notification.body!,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodyMedium
                      ?.copyWith(color: color.onSurfaceVariant),
                ),
              ),
            Padding(
              padding: const EdgeInsets.only(top: 6.0),
              child: Text(
                _formatDate(notification.date),
                style:
                    theme.textTheme.bodySmall?.copyWith(color: color.outline),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime dt) {
    final d = dt.toLocal();
    two(int v) => v.toString().padLeft(2, '0');
    return '${d.year}-${two(d.month)}-${two(d.day)} ${two(d.hour)}:${two(d.minute)}';
  }
}
