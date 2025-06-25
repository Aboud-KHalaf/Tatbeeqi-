import 'package:dartz/dartz.dart';
import 'package:tatbeeqi/core/error/failures.dart';
import 'package:tatbeeqi/features/grades/domain/entities/grade.dart';

abstract class GradesRepository {
  Future<Either<Failure, void>> insertGrade(Grade grade);
  Future<Either<Failure, void>> updateGrade(Grade grade);
  Future<Either<Failure, List<Grade>>> fetchGradesByLessonAndCourseId(String lessonId, String courseId);
  Future<Either<Failure, List<Grade>>> fetchGradesByCourseId(String courseId);
}
