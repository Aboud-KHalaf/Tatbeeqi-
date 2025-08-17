import 'package:equatable/equatable.dart';
import '../../domain/entities/user_streak.dart';

abstract class StreaksState extends Equatable {
  const StreaksState();

  @override
  List<Object?> get props => [];
}

class StreaksInitial extends StreaksState {}

class StreaksLoading extends StreaksState {}

class StreaksLoaded extends StreaksState {
  final UserStreak streak;

  const StreaksLoaded({required this.streak});

  @override
  List<Object> get props => [streak];
}

class StreaksError extends StreaksState {
  final String message;

  const StreaksError({required this.message});

  @override
  List<Object> get props => [message];
}

class StreaksUpdating extends StreaksState {
  final UserStreak currentStreak;

  const StreaksUpdating({required this.currentStreak});

  @override
  List<Object> get props => [currentStreak];
}
