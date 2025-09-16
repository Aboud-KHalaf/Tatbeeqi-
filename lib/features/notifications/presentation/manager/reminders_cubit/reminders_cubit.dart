import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tatbeeqi/features/notifications/domain/entities/reminder.dart';
import 'package:tatbeeqi/features/notifications/domain/usecases/cancel_reminder_use_case.dart';
import 'package:tatbeeqi/features/notifications/domain/usecases/get_reminders_use_case.dart';
import 'package:tatbeeqi/features/notifications/domain/usecases/schedule_reminder_use_case.dart';
import 'package:tatbeeqi/features/notifications/presentation/manager/reminders_cubit/reminders_state.dart';

class RemindersCubit extends Cubit<RemindersState> {
  final ScheduleReminderUseCase scheduleReminderUseCase;
  final CancelReminderUseCase cancelReminderUseCase;
  final GetRemindersUseCase getRemindersUseCase;

  RemindersCubit({
    required this.scheduleReminderUseCase,
    required this.cancelReminderUseCase,
    required this.getRemindersUseCase,
  }) : super(RemindersInitial());

  Future<void> loadReminders({String? courseId}) async {
    try {
      emit(RemindersLoading());
      final reminders = await getRemindersUseCase(courseId: courseId);
      emit(RemindersLoaded(reminders));
    } catch (e) {
      emit(RemindersError(e.toString()));
    }
  }

  Future<void> scheduleReminder(Reminder reminder) async {
    try {
      emit(ReminderScheduling());
      await scheduleReminderUseCase(reminder);
      emit(ReminderScheduled(reminder));
      // Reload reminders to show updated list
      await loadReminders(courseId: reminder.courseId);
    } catch (e) {
      emit(RemindersError(e.toString()));
    }
  }

  Future<void> cancelReminder(String reminderId, {String? courseId}) async {
    try {
      emit(RemindersLoading());
      await cancelReminderUseCase(reminderId);
      // Reload reminders to show updated list
      await loadReminders(courseId: courseId);
    } catch (e) {
      emit(RemindersError(e.toString()));
    }
  }
}
