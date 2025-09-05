import 'package:tatbeeqi/features/notifications/domain/entities/reminder.dart';
import 'package:tatbeeqi/features/notifications/domain/repositories/notifications_repository.dart';

class ScheduleReminderUseCase {
  final NotificationsRepository repository;

  ScheduleReminderUseCase(this.repository);

  Future<void> call(Reminder reminder) async {
    return await repository.scheduleReminder(reminder);
  }
}
