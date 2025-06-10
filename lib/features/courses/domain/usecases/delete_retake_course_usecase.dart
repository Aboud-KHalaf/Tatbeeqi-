import 'package:dartz/dartz.dart';
import 'package:tatbeeqi/core/error/failures.dart';
import 'package:tatbeeqi/core/usecases/usecase.dart';
import 'package:tatbeeqi/features/courses/domain/repositories/course_repository.dart';

class DeleteRetakeCourseUseCase implements UseCase<void, int> {
  final CourseRepository repository;

  DeleteRetakeCourseUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(int courseId) async {
    return await repository.deleteRetakeCourse(courseId);
  }
}