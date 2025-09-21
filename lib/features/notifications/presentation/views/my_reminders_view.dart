import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tatbeeqi/features/notifications/presentation/manager/reminders_cubit/reminders_cubit.dart';
import 'package:tatbeeqi/features/notifications/presentation/manager/reminders_cubit/reminders_state.dart';

class MyRemindersView extends StatefulWidget {
  const MyRemindersView({super.key});

  @override
  State<MyRemindersView> createState() => _MyRemindersViewState();
}

class _MyRemindersViewState extends State<MyRemindersView> {
  @override
  void initState() {
    super.initState();
    context.read<RemindersCubit>().loadReminders();
  }

  String _formatDays(List<int> days) {
    const weekDays = [
      "Mon",
      "Tue",
      "Wed",
      "Thu",
      "Fri",
      "Sat",
      "Sun",
    ];
    return days.map((d) => weekDays[d - 1]).join(", ");
  }

  String _formatTime(int hour, int minute) {
    final time = TimeOfDay(hour: hour, minute: minute);
    return time.format(context);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "My Reminders",
          style: theme.textTheme.titleLarge,
        ),
      ),
      body: BlocBuilder<RemindersCubit, RemindersState>(
        builder: (context, state) {
          if (state is RemindersLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is RemindersLoaded) {
            final reminders = state.reminders;

            if (reminders.isEmpty) {
              return Center(
                child: Text(
                  "No reminders yet",
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              );
            }

            return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: reminders.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final reminder = reminders[index];

                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  elevation: 0,
                  color: colorScheme.surfaceContainerHighest
                      .withValues(alpha: 0.3),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(
                      color: colorScheme.outline.withValues(alpha: 0.1),
                    ),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    leading: Icon(
                      reminder.isActive
                          ? Icons.alarm_on_rounded
                          : Icons.alarm_off_rounded,
                      color: reminder.isActive
                          ? theme.colorScheme.primary
                          : theme.colorScheme.outline,
                      size: 32,
                    ),
                    title: Text(
                      reminder.title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (reminder.body.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Text(
                              reminder.body,
                              style: theme.textTheme.bodyMedium,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            Icon(
                              Icons.calendar_today_outlined,
                              size: 16,
                              color: theme.colorScheme.primary,
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                _formatDays(reminder.days),
                                style: theme.textTheme.bodySmall,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Icon(
                              Icons.access_time,
                              size: 16,
                              color: theme.colorScheme.primary,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              _formatTime(reminder.hour, reminder.minute),
                              style: theme.textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ],
                    ),
                    trailing: Switch(
                      value: reminder.isActive,
                      onChanged: (_) {
                        // context
                        //     .read<RemindersCubit>()
                        //     .toggleReminder(reminder.id);
                      },
                    ),
                    onTap: () {
                      // maybe open details/edit dialog
                    },
                  ),
                );
              },
            );
          } else if (state is RemindersError) {
            return Center(
              child: Text(
                state.message,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.error,
                ),
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // open add reminder flow
        },
        icon: const Icon(Icons.add),
        label: const Text("Add Reminder"),
      ),
    );
  }
}
