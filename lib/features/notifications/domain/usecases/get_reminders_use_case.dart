import 'package:tatbeeqi/features/notifications/domain/entities/reminder.dart';
import 'package:tatbeeqi/features/notifications/domain/repositories/notifications_repository.dart';

class GetRemindersUseCase {
  final NotificationsRepository repository;

  GetRemindersUseCase(this.repository);

  Future<List<Reminder>> call({String? courseId}) async {
    return await repository.getReminders(courseId: courseId);
  }
}
