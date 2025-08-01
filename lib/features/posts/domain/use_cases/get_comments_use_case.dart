import 'package:dartz/dartz.dart';
import 'package:tatbeeqi/core/error/failures.dart';
import 'package:tatbeeqi/features/posts/domain/entities/comment.dart';
import 'package:tatbeeqi/features/posts/domain/repositories/post_repository.dart';

class GetCommentsUseCase {
  final PostRepository repository;

  GetCommentsUseCase(this.repository);

  Future<Either<Failure, List<Comment>>> call(String postId,
      {int start = 0, int limit = 10}) async {
    return await repository.getComments(postId, start: start, limit: limit);
  }
}
