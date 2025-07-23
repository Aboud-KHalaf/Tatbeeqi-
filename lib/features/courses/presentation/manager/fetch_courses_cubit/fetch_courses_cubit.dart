import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tatbeeqi/features/courses/domain/usecases/get_courses_by_study_year_and_department_id_usecase.dart';
import 'package:tatbeeqi/features/courses/presentation/manager/fetch_courses_cubit/fetch_courses_state.dart';

class FetchCoursesCubit extends Cubit<FetchCoursesState> {
  final GetCoursesByStudyYearAndDepartmentIdUseCase
      _getCoursesByStudyYearUseCase;

  FetchCoursesCubit({
    required GetCoursesByStudyYearAndDepartmentIdUseCase
        getCoursesByStudyYearUseCase,
  })  : _getCoursesByStudyYearUseCase = getCoursesByStudyYearUseCase,
        super(CoursesInitial());

  Future<void> fetchCourses(int studyYear, int departmentId) async {
    emit(CoursesLoading());
    final failureOrCourses =
        await _getCoursesByStudyYearUseCase(studyYear, departmentId);

    failureOrCourses.fold(
      (failure) => emit(CoursesError(failure.message)),
      (courseEntities) {
        emit(CoursesLoaded(courseEntities));
      },
    );
  }
}
