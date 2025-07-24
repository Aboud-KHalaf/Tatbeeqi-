import 'package:dartz/dartz.dart';
import 'package:tatbeeqi/core/error/failures.dart';
import 'package:tatbeeqi/core/usecases/usecase.dart';
import 'package:tatbeeqi/features/courses/domain/entities/course_entity.dart';
import 'package:tatbeeqi/features/courses/domain/repositories/course_repository.dart';

class SaveSelectedRetakeCoursesUseCase implements UseCase<void, List<Course>> {
  final CourseRepository repository;

  SaveSelectedRetakeCoursesUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(List<Course> params) async {
    return await repository.saveSelectedRetakeCourses(params);
  }
}
