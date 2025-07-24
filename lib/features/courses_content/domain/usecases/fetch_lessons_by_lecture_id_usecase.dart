import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/lesson_entity.dart';
import '../repository/courses_content_repository.dart';

class FetchLessonsByLectureIdUseCase implements UseCase<List<Lesson>, int> {
  final CoursesContentRepository repository;

  FetchLessonsByLectureIdUseCase(this.repository);

  @override
  Future<Either<Failure, List<Lesson>>> call(int params) async {
    return await repository.fetchLessonsByLectureId(params);
  }
}
