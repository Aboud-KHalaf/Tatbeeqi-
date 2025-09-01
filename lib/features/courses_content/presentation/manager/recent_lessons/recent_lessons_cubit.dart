import 'package:bloc/bloc.dart';
import 'package:tatbeeqi/core/error/failures.dart';
import '../../../domain/usecases/fetch_recent_lessons_usecase.dart';
import 'recent_lessons_state.dart';

class RecentLessonsCubit extends Cubit<RecentLessonsState> {
  final FetchRecentLessonsUseCase _fetchRecentLessonsUseCase;

  RecentLessonsCubit({required FetchRecentLessonsUseCase fetchRecentLessonsUseCase})
      : _fetchRecentLessonsUseCase = fetchRecentLessonsUseCase,
        super(RecentLessonsInitial());

  Future<void> fetch({int limit = 4}) async {
    emit(RecentLessonsLoading());
    final res = await _fetchRecentLessonsUseCase(
      FetchRecentLessonsParams(limit: limit),
    );
    res.fold(
      (failure) => emit(RecentLessonsError(_mapFailureToMessage(failure))),
      (lessons) => lessons.isEmpty
          ? emit(RecentLessonsEmpty())
          : emit(RecentLessonsLoaded(lessons)),
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
