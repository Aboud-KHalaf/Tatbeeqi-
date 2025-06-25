import 'package:dartz/dartz.dart';
import 'package:tatbeeqi/core/error/failures.dart';
import 'package:tatbeeqi/core/usecases/usecase.dart';
import 'package:tatbeeqi/features/grades/domain/entities/grade.dart';
import 'package:tatbeeqi/features/grades/domain/repositories/grades_repository.dart';

class FetchGradesByLessonAndCourseIdUseCase extends UseCase<List<Grade>, FetchGradesByLessonAndCourseIdParams> {
  final GradesRepository repository;

  FetchGradesByLessonAndCourseIdUseCase(this.repository);

  @override
  Future<Either<Failure, List<Grade>>> call(FetchGradesByLessonAndCourseIdParams params) {
    return repository.fetchGradesByLessonAndCourseId(params.lessonId, params.courseId);
  }
}

class FetchGradesByLessonAndCourseIdParams {
  final String lessonId;
  final String courseId;

  FetchGradesByLessonAndCourseIdParams({required this.lessonId, required this.courseId});
}
