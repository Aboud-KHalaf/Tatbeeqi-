import 'package:equatable/equatable.dart';
import 'package:tatbeeqi/features/notifications/domain/entities/reminder.dart';

abstract class RemindersState extends Equatable {
  const RemindersState();

  @override
  List<Object?> get props => [];
}

class RemindersInitial extends RemindersState {}

class RemindersLoading extends RemindersState {}

class RemindersLoaded extends RemindersState {
  final List<Reminder> reminders;

  const RemindersLoaded(this.reminders);

  @override
  List<Object?> get props => [reminders];
}

class ReminderScheduling extends RemindersState {}

class ReminderScheduled extends RemindersState {
  final Reminder reminder;

  const ReminderScheduled(this.reminder);

  @override
  List<Object?> get props => [reminder];
}

class RemindersError extends RemindersState {
  final String message;

  const RemindersError(this.message);

  @override
  List<Object?> get props => [message];
}
