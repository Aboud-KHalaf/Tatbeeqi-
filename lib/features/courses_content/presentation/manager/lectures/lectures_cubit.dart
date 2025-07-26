import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tatbeeqi/core/error/failures.dart';
import 'package:tatbeeqi/features/courses_content/domain/entities/lecture_entity.dart';
import 'package:tatbeeqi/features/courses_content/domain/usecases/fetch_lectures_by_course_id_usecase.dart';

part 'lectures_state.dart';

class LecturesCubit extends Cubit<LecturesState> {
  final FetchLecturesByCourseIdUseCase _fetchLecturesByCourseIdUsecase;

  LecturesCubit({
    required FetchLecturesByCourseIdUseCase fetchLecturesByCourseIdUsecase,
  })  : _fetchLecturesByCourseIdUsecase = fetchLecturesByCourseIdUsecase,
        super(LecturesInitial());

  Future<void> fetchLectures(int courseId) async {
    emit(LecturesLoading());
    final result = await _fetchLecturesByCourseIdUsecase(courseId);
    result.fold(
      (failure) => emit(LecturesError(_mapFailureToMessage(failure))),
      (lectures) => emit(LecturesLoaded(lectures)),
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
