import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tatbeeqi/core/usecases/usecase.dart';
import '../../domain/usecases/get_user_streak.dart';
import '../../domain/usecases/update_streak_on_lesson_complete.dart';
import 'streaks_state.dart';

class StreaksCubit extends Cubit<StreaksState> {
  final GetUserStreak getUserStreak;
  final UpdateStreakOnLessonComplete updateStreakOnLessonComplete;

  StreaksCubit({
    required this.getUserStreak,
    required this.updateStreakOnLessonComplete,
  }) : super(StreaksInitial());

  Future<void> loadUserStreak() async {
    emit(StreaksLoading());

    final result = await getUserStreak(NoParams());

    result.fold(
      (failure) => emit(StreaksError(message: failure.message)),
      (streak) => emit(StreaksLoaded(streak: streak)),
    );
  }

  Future<void> updateStreak(String userId) async {
    final currentState = state;
    if (currentState is StreaksLoaded) {
      emit(StreaksUpdating(currentStreak: currentState.streak));

      final result = await updateStreakOnLessonComplete(
        UpdateStreakParams(userId: userId),
      );

      result.fold(
        (failure) => emit(StreaksError(message: failure.message)),
        (_) => loadUserStreak(), // Reload to get updated streak
      );
    }
  }

  Future<void> refreshStreak() async {
    await loadUserStreak();
  }
}
