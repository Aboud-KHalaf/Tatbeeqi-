import 'package:dartz/dartz.dart';
import 'package:tatbeeqi/core/error/exceptions.dart';
import 'package:tatbeeqi/core/error/failures.dart';
import 'package:tatbeeqi/features/courses/data/datasources/course_local_data_source.dart';
import 'package:tatbeeqi/features/courses/data/datasources/course_remote_data_source.dart';
import 'package:tatbeeqi/features/courses/data/models/course_data_model.dart';
import 'package:tatbeeqi/features/courses/domain/entities/course_entity.dart';
import 'package:tatbeeqi/features/courses/domain/repositories/course_repository.dart';

class CourseRepositoryImpl implements CourseRepository {
  final CourseRemoteDataSource remoteDataSource;
  final CourseLocalDataSource localDataSource; // Added local data source

  CourseRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource, // Added local data source
  });

  @override
  Future<Either<Failure, List<Course>>> getCoursesByStudyYearAndDepartmentId(
      {required int studyYear, required int departmentId}) async {
    try {
      // // 1. Try to get from local cache first
      // final hasLocalData =
      //     await localDataSource.hasCoursesForStudyYearAndDepartmentId(
      //         studyYear: studyYear, departmentId: departmentId);
      // if (hasLocalData) {
      //   final localCourses =
      //       await localDataSource.getCoursesByStudyYearAndDepartmentId(
      //           studyYear: studyYear, departmentId: departmentId);
      //   if (localCourses.isNotEmpty) {
      //     return Right(localCourses.cast<Course>());
      //   }
      // }

      // 2. If not in cache or cache is empty, fetch from remote
      final remoteCourseModels =
          await remoteDataSource.getCoursesByStudyYearAndDepartmentId(
              studyYear: studyYear, departmentId: departmentId);

      // 3. Cache the fetched data
      await localDataSource.cacheCourses(
          courses: remoteCourseModels,
          studyYear: studyYear,
          departmentId: departmentId);

      return Right(remoteCourseModels.cast<Course>());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(
          ServerFailure('An unexpected error occurred: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, List<Course>>> getAllCoursesForReatake(
      {required int studyYear, required int departmentId}) async {
    try {
      final remoteCourseModels = await remoteDataSource.getAllCoursesForReatake(
          studyYear: studyYear, departmentId: departmentId);
      final localCourseModels =
          await localDataSource.getCoursesBysemester(semester: 3);

      final localIds = localCourseModels.map((e) => e.id).toSet();

      final reTakeCourses = remoteCourseModels
          .where((course) => !localIds.contains(course.id + 500))
          .toList();

      return Right(reTakeCourses.cast<Course>());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(
          ServerFailure('An unexpected error occurred: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, Unit>> saveSelectedRetakeCourses(
      List<Course> courses) async {
    try {
      final courseModels =
          courses.map((entity) => CourseModel.fromEntity(entity)).toList();
      await localDataSource.cacheSelectedRetakeCourses(courseModels);
      return const Right(unit);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(
          CacheFailure('Failed to save retake courses: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteRetakeCourse(int courseId) async {
    try {
      await localDataSource.deleteRetakeCourse(courseId);
      return const Right(unit);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(
          CacheFailure('Failed to delete retake course: ${e.toString()}'));
    }
  }
}
