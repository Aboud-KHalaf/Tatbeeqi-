 import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tatbeeqi/core/error/failures.dart';
import 'package:tatbeeqi/features/courses_content/domain/usecases/mark_lesson_as_completed_usecase.dart';

part 'lesson_completion_state.dart';

class LessonCompletionCubit extends Cubit<LessonCompletionState> {
  final MarkLessonAsCompletedUseCase _markLessonAsCompletedUsecase;

  LessonCompletionCubit({
    required MarkLessonAsCompletedUseCase markLessonAsCompletedUsecase,
  })  : _markLessonAsCompletedUsecase = markLessonAsCompletedUsecase,
        super(LessonCompletionInitial());

  Future<void> markLessonAsCompleted(int lessonId) async {
    emit(LessonCompletionLoading());
    final result = await _markLessonAsCompletedUsecase(MarkLessonParams(lessonId: lessonId));
    result.fold(
      (failure) => emit(LessonCompletionError(_mapFailureToMessage(failure))),
      (_) => emit(LessonCompletionSuccess()),
    );
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return 'Server Error';
      case CacheFailure:
        return 'Cache Error';
      default:
        return 'An unexpected error occurred';
    }
  }
}
