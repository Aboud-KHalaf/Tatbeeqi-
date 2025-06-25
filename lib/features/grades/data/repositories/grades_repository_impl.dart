import 'package:dartz/dartz.dart';
import 'package:tatbeeqi/core/error/failures.dart';
import 'package:tatbeeqi/features/grades/data/datasources/mock_grades_datasource.dart';
import 'package:tatbeeqi/features/grades/domain/entities/grade.dart';
import 'package:tatbeeqi/features/grades/domain/repositories/grades_repository.dart';

class GradesRepositoryImpl implements GradesRepository {
  final MockGradesDataSource dataSource;

  GradesRepositoryImpl(this.dataSource);

  @override
  Future<Either<Failure, void>> insertGrade(Grade grade) async {
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, List<Grade>>> fetchGradesByLessonAndCourseId(String lessonId, String courseId) async {
    throw UnimplementedError();
  
  }

  @override
  Future<Either<Failure, List<Grade>>> fetchGradesByCourseId(String courseId) async {
    throw UnimplementedError();
  
  }

  @override
  Future<Either<Failure, void>> updateGrade(Grade grade) async {
    throw UnimplementedError();
  }
}
