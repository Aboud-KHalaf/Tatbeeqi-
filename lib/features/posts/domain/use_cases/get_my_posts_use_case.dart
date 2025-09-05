import 'package:dartz/dartz.dart';
import 'package:tatbeeqi/core/error/failures.dart';
import 'package:tatbeeqi/features/posts/domain/entities/post.dart';
import 'package:tatbeeqi/features/posts/domain/repositories/post_repository.dart';

class GetMyPostsUseCase {
  final PostRepository repository;

  GetMyPostsUseCase(this.repository);

  Future<Either<Failure, List<Post>>> call({int start = 0, int limit = 10}) async {
    return await repository.getMyPosts(start: start, limit: limit);
  }
}
