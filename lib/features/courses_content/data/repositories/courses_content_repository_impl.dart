import 'package:dartz/dartz.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/lesson_entity.dart';
import '../../domain/repository/courses_content_repository.dart';
import '../datasources/courses_content_remote_data_source.dart';

import '../../domain/entities/lecture_entity.dart';

class CoursesContentRepositoryImpl implements CoursesContentRepository {
  final CoursesContentRemoteDataSource remoteDataSource;

    CoursesContentRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<Lecture>>> fetchLecturesByCourseId(
      int courseId) async {
    try {
      final remoteLectures =
          await remoteDataSource.fetchLecturesByCourseId(courseId);
      return Right(remoteLectures);
    } on ServerException {
      return const Left(ServerFailure("Error fetching lectures by course ID"));
    }
  }

  @override
  Future<Either<Failure, List<Lesson>>> fetchLessonsByLectureId(
      int lectureId) async {
    try {
      final remoteLessons =
          await remoteDataSource.fetchLessonsByLectureId(lectureId);
      return Right(remoteLessons);
    } on ServerException {
      return const Left(ServerFailure("Error fetching lessons"));
    }
  }

  @override
  Future<Either<Failure, List<Lesson>>> fetchRecentLessons({int limit = 4}) async {
    try {
      final remoteLessons = await remoteDataSource.fetchRecentLessons(limit: limit);
      return Right(remoteLessons);
    } on ServerException {
      return const Left(ServerFailure("Error fetching recent lessons"));
    }
  }

  @override
  Future<Either<Failure, Unit>> markLessonAsCompleted(int lessonId) async {
    try {
      await remoteDataSource.markLessonAsCompleted(lessonId);
      return const Right(unit);
    } on ServerException {
      return const Left(ServerFailure("Error marking lesson as completed"));
    }
  }
}

