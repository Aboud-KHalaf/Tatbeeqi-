import 'package:flutter_bloc/flutter_bloc.dart';
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

  Future<void> loadUserStreak(String userId) async {
    emit(StreaksLoading());

    final result = await getUserStreak(GetUserStreakParams(userId: userId));

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
        (_) => loadUserStreak(userId), // Reload to get updated streak
      );
    }
  }

  Future<void> refreshStreak(String userId) async {
    await loadUserStreak(userId);
  }
}
