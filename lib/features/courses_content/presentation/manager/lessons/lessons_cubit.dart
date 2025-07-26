import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tatbeeqi/core/error/failures.dart';
import 'package:tatbeeqi/features/courses_content/domain/entities/lesson_entity.dart';
import 'package:tatbeeqi/features/courses_content/domain/usecases/fetch_lessons_by_lecture_id_usecase.dart';

part 'lessons_state.dart';

class LessonsCubit extends Cubit<LessonsState> {
  final FetchLessonsByLectureIdUseCase _fetchLessonsByLectureIdUsecase;

  LessonsCubit({
    required FetchLessonsByLectureIdUseCase fetchLessonsByLectureIdUsecase,
  })  : _fetchLessonsByLectureIdUsecase = fetchLessonsByLectureIdUsecase,
        super(LessonsInitial());

  Future<void> fetchLessons(int lectureId) async {
    emit(LessonsLoading());
    final result = await _fetchLessonsByLectureIdUsecase(lectureId);
    result.fold(
      (failure) => emit(LessonsError(_mapFailureToMessage(failure))),
      (lessons) => emit(LessonsLoaded(lessons)),
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
