import 'package:equatable/equatable.dart';
 import 'package:flutter_bloc/flutter_bloc.dart';
 import 'package:tatbeeqi/features/grades/domain/entities/grade.dart';
import 'package:tatbeeqi/features/grades/domain/use_cases/fetch_grades_by_course_id_use_case.dart';
import 'package:tatbeeqi/features/grades/domain/use_cases/fetch_grades_by_lesson_and_course_id_use_case.dart';
import 'package:tatbeeqi/features/grades/domain/use_cases/insert_grade_use_case.dart';
import 'package:tatbeeqi/features/grades/domain/use_cases/update_grade_use_case.dart';

part 'grades_state.dart';

class GradesCubit extends Cubit<GradesState> {
  final FetchGradesByCourseIdUseCase _fetchByCourseId;
  final FetchGradesByLessonAndCourseIdUseCase _fetchByLessonAndCourseId;
  final InsertGradeUseCase _insertGradeUseCase;
  final UpdateGradeUseCase _updateGradeUseCase;

  GradesCubit({
    required FetchGradesByCourseIdUseCase fetchByCourseId,
    required FetchGradesByLessonAndCourseIdUseCase fetchByLessonAndCourseId,
    required InsertGradeUseCase insertGradeUseCase,
    required UpdateGradeUseCase updateGradeUseCase,
  })  : _fetchByCourseId = fetchByCourseId,
        _fetchByLessonAndCourseId = fetchByLessonAndCourseId,
        _insertGradeUseCase = insertGradeUseCase,
        _updateGradeUseCase = updateGradeUseCase,
        super(GradesInitial());

  Future<void> fetchByCourse(String courseId) async {
    emit(GradesLoading());
    final result = await _fetchByCourseId(courseId);
    result.fold(
      (f) => emit(GradesError(f.message)),
      (list) => emit(GradesLoaded(list)),
    );
  }

  Future<void> fetchByLessonAndCourse(String lessonId, String courseId) async {
    emit(GradesLoading());
    final result = await _fetchByLessonAndCourseId(
      FetchGradesByLessonAndCourseIdParams(
          lessonId: lessonId, courseId: courseId),
    );
    result.fold(
      (f) => emit(GradesError(f.message)),
      (list) => emit(GradesLoaded(list)),
    );
  }

  Future<void> insert(Grade grade) async {
    emit(GradesSaving());
    final result = await _insertGradeUseCase(grade);
    result.fold(
      (f) => emit(GradesError(f.message)),
      (_) => emit(GradesSaved()),
    );
  }

  Future<void> update(Grade grade) async {
    emit(GradesSaving());
    final result = await _updateGradeUseCase(grade);
    result.fold(
      (f) => emit(GradesError(f.message)),
      (_) => emit(GradesSaved()),
    );
  }
}
