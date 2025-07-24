import 'package:dartz/dartz.dart';
import 'package:tatbeeqi/core/error/failures.dart';
import 'package:tatbeeqi/features/courses/domain/entities/course_entity.dart';

abstract class CourseRepository {
  Future<Either<Failure, List<Course>>> getCoursesByStudyYearAndDepartmentId(
      {required int studyYear, required int departmentId});
  Future<Either<Failure, List<Course>>> getAllCoursesForReatake(
      {required int studyYear, required int departmentId});
  Future<Either<Failure, void>> saveSelectedRetakeCourses(List<Course> courses);
  Future<Either<Failure, void>> deleteRetakeCourse(int courseId);
}
