import 'package:dartz/dartz.dart';
import 'package:tatbeeqi/core/error/failures.dart';
import 'package:tatbeeqi/core/usecases/usecase.dart';
import 'package:tatbeeqi/features/forums/domain/entities/forum_discussion.dart';
import 'package:tatbeeqi/features/forums/domain/repositories/forums_repository.dart';

class FetchForumDiscussionsUseCase extends UseCase<List<ForumDiscussion>, String> {
  final ForumsRepository repository;

  FetchForumDiscussionsUseCase(this.repository);

  @override
  Future<Either<Failure, List<ForumDiscussion>>> call(String courseId) {
    return repository.fetchForumDiscussions(courseId);
  }
}
