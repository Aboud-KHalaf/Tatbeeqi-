import 'package:tatbeeqi/features/notifications/domain/repositories/notifications_repository.dart';

class CancelReminderUseCase {
  final NotificationsRepository repository;

  CancelReminderUseCase(this.repository);

  Future<void> call(String reminderId) async {
    return await repository.cancelReminder(reminderId);
  }
}
