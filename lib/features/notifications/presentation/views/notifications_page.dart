import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:tatbeeqi/features/notifications/domain/entities/app_notification.dart';
import 'package:tatbeeqi/features/notifications/presentation/manager/initialize_notifications_cubit/initialize_notifications_cubit.dart';
import 'package:tatbeeqi/features/notifications/presentation/manager/notification_settings_bloc/notification_settings_bloc.dart';
import 'package:tatbeeqi/features/notifications/presentation/manager/notifications_bloc/notifications_bloc.dart';
import 'package:tatbeeqi/features/notifications/presentation/manager/send_notification_bloc/send_notification_bloc.dart';

final sl = GetIt.instance;

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<NotificationsBloc>(
          create: (context) => sl<NotificationsBloc>()..add(GetNotifications()),
        ),
        BlocProvider<SendNotificationBloc>(
          create: (context) => sl<SendNotificationBloc>(),
        ),
        BlocProvider<NotificationSettingsBloc>(
          create: (context) =>
              sl<NotificationSettingsBloc>()..add(GetDeviceToken()),
        ),
      ],
      child: const NotificationsView(),
    );
  }
}

class NotificationsView extends StatelessWidget {
  const NotificationsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<InitializeNotificationsCubit,
        InitializeNotificationsState>(
      listener: (context, state) {
        if (state is InitializeNotificationsSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Notification services initialized successfully!'),
              backgroundColor: Colors.green,
            ),
          );
        }
        if (state is InitializeNotificationsFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Initialization failed: ${state.message}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Notifications'),
          actions: [
            IconButton(
              icon: const Icon(Icons.delete_sweep),
              onPressed: () =>
                  context.read<NotificationsBloc>().add(ClearNotifications()),
              tooltip: 'Clear All Notifications',
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildNotificationSettingsSection(context),
                const SizedBox(height: 24),
                _buildSendNotificationSection(context),
                const SizedBox(height: 24),
                _buildNotificationsList(context),
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () =>
              context.read<NotificationsBloc>().add(GetNotifications()),
          tooltip: 'Refresh Notifications',
          child: const Icon(Icons.refresh),
        ),
      ),
    );
  }

  Widget _buildNotificationSettingsSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Device Settings', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 8),
        BlocBuilder<NotificationSettingsBloc, NotificationSettingsState>(
          builder: (context, state) {
            if (state is NotificationSettingsLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is NotificationSettingsLoaded) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Device Token: ${state.deviceToken}'),
                  const SizedBox(height: 8),
                  Text(
                      'Subscribed Topics: ${state.subscribedTopics.join(', ')}'),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      ElevatedButton(
                        onPressed: () => context
                            .read<NotificationSettingsBloc>()
                            .add(const SubscribeToTopic('news')),
                        child: const Text('Subscribe to News'),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: () => context
                            .read<NotificationSettingsBloc>()
                            .add(const UnsubscribeFromTopic('news')),
                        child: const Text('Unsubscribe'),
                      ),
                    ],
                  ),
                ],
              );
            }
            if (state is NotificationSettingsFailure) {
              return Text('Error: ${state.message}',
                  style: const TextStyle(color: Colors.red));
            }
            return const Text('Fetching notification settings...');
          },
        ),
      ],
    );
  }

  Widget _buildSendNotificationSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Send a Test Notification',
            style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 8),
        ElevatedButton(
          onPressed: () {
            AppNotification notification = AppNotification(
              id: 125235,
              title: 'Hello from Tatbeeqi!',
              subtitle: 'This is a test notification sent to all users.',
              date: DateTime.now(),
            );
            context.read<SendNotificationBloc>().add(
                  SendNotificationToTopics(
                    topics: const ['test'],
                    notification: notification,
                  ),
                );
          },
          child: const Text('Send to Topic: all_users'),
        ),
        BlocListener<SendNotificationBloc, SendNotificationState>(
          listener: (context, state) {
            if (state is SendNotificationSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text('Notification sent!'),
                    backgroundColor: Colors.green),
              );
            }
            if (state is SendNotificationFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content: Text('Error: ${state.message}'),
                    backgroundColor: Colors.red),
              );
            }
          },
          child: const SizedBox.shrink(),
        ),
      ],
    );
  }

  Widget _buildNotificationsList(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Incoming Notifications',
            style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 8),
        BlocBuilder<NotificationsBloc, NotificationsState>(
          builder: (context, state) {
            if (state is NotificationsLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is NotificationsLoaded) {
              if (state.notifications.isEmpty) {
                return const Center(child: Text('No notifications yet.'));
              }
              return ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: state.notifications.length,
                itemBuilder: (context, index) {
                  final notification = state.notifications[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 4.0),
                    child: ListTile(
                      title: Text(notification.title),
                      subtitle: Text(notification.subtitle ?? 'No content'),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          context
                              .read<NotificationsBloc>()
                              .add(DeleteNotification(notification.id));
                        },
                        tooltip: 'Delete Notification',
                      ),
                    ),
                  );
                },
              );
            }
            if (state is NotificationsFailure) {
              return Text('Error: ${state.message}',
                  style: const TextStyle(color: Colors.red));
            }
            return const Center(
                child: Text('Press refresh to get notifications.'));
          },
        ),
      ],
    );
  }
}
