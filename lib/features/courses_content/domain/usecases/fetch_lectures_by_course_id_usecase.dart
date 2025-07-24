import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/lecture_entity.dart';
import '../repository/courses_content_repository.dart';

class FetchLecturesByCourseIdUseCase implements UseCase<List<Lecture>, int> {
  final CoursesContentRepository repository;

  FetchLecturesByCourseIdUseCase(this.repository);

  @override
  Future<Either<Failure, List<Lecture>>> call(int params) async {
    return await repository.fetchLecturesByCourseId(params);
  }
}
