import 'package:dartz/dartz.dart';
import 'package:tatbeeqi/core/error/failures.dart';
import 'package:tatbeeqi/core/error/exceptions.dart';
import 'package:tatbeeqi/core/network/network_info.dart';
import 'package:tatbeeqi/features/grades/data/datasources/grades_remote_datasource.dart';
 import 'package:tatbeeqi/features/grades/domain/entities/grade.dart';
import 'package:tatbeeqi/features/grades/domain/repositories/grades_repository.dart';
import 'package:tatbeeqi/features/grades/data/models/grade_model.dart';

class GradesRepositoryImpl implements GradesRepository {
  final GradesRemoteDataSource dataSource;
  final NetworkInfo networkInfo;

  GradesRepositoryImpl({required this.dataSource, required this.networkInfo});

  @override
  Future<Either<Failure, void>> insertGrade(Grade grade) async {
    try {
      if (await networkInfo.isConnected()) {
        await dataSource.insertGrade(_toModel(grade));
        return const Right(null);
      } else {
        return const Left(NetworkFailure());
      }
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, List<Grade>>> fetchGradesByLessonAndCourseId(String lessonId, String courseId) async {
    try {
      if (await networkInfo.isConnected()) {
        final models = await dataSource.fetchGradesByLessonAndCourseId(lessonId, courseId);
        return Right(models);
      } else {
        return const Left(NetworkFailure());
      }
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, List<Grade>>> fetchGradesByCourseId(String courseId) async {
    try {
      if (await networkInfo.isConnected()) {
        final models = await dataSource.fetchGradesByCourseId(courseId);
        return Right(models);
      } else {
        return const Left(NetworkFailure());
      }
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> updateGrade(Grade grade) async {
    try {
      if (await networkInfo.isConnected()) {
        await dataSource.updateGrade(_toModel(grade));
        return const Right(null);
      } else {
        return const Left(NetworkFailure());
      }
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Unexpected error: $e'));
    }
  }
}

GradeModel _toModel(Grade grade) {
  return GradeModel(
    id: grade.id,
    lessonId: grade.lessonId,
    quizId: grade.quizId,
    lectureId: grade.lectureId,
    courseId: grade.courseId,
    studentId: grade.studentId,
    score: grade.score,
    submissionDate: grade.submissionDate,
  );
}
