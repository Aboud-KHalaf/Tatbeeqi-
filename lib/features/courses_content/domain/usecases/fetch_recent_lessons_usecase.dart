import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/lesson_entity.dart';
import '../repository/courses_content_repository.dart';

class FetchRecentLessonsUseCase
    implements UseCase<List<Lesson>, FetchRecentLessonsParams> {
  final CoursesContentRepository repository;

  FetchRecentLessonsUseCase(this.repository);

  @override
  Future<Either<Failure, List<Lesson>>> call(
      FetchRecentLessonsParams params) async {
    return await repository.fetchRecentLessons(limit: params.limit);
  }
}

class FetchRecentLessonsParams {
  final int limit;
  const FetchRecentLessonsParams({this.limit = 4});
}
