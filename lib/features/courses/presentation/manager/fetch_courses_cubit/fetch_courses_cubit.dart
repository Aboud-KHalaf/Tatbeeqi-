import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tatbeeqi/features/auth/domain/usecases/get_current_user_usecase.dart';
import 'package:tatbeeqi/features/courses/domain/usecases/get_courses_by_study_year_and_department_id_usecase.dart';
import 'package:tatbeeqi/features/courses/presentation/manager/fetch_courses_cubit/fetch_courses_state.dart';

class FetchCoursesCubit extends Cubit<FetchCoursesState> {
  final GetCoursesByStudyYearAndDepartmentIdUseCase
      _getCoursesByStudyYearUseCase;
      final GetCurrentUserUseCase _getCurrentUser;

  FetchCoursesCubit({
    required GetCoursesByStudyYearAndDepartmentIdUseCase
        getCoursesByStudyYearUseCase,
    required GetCurrentUserUseCase getCurrentUserUseCase,
  })  : _getCoursesByStudyYearUseCase = getCoursesByStudyYearUseCase,
        _getCurrentUser = getCurrentUserUseCase,
        super(CoursesInitial());

  Future<void> fetchCourses() async {
    emit(CoursesLoading());
    final user = await _getCurrentUser();
    final failureOrCourses =
        await _getCoursesByStudyYearUseCase(user!.studyYear, user.department);

    failureOrCourses.fold(
      (failure) => emit(CoursesError(failure.message)),
      (courseEntities) {
        emit(CoursesLoaded(courseEntities));
      },
    );
  }
}
