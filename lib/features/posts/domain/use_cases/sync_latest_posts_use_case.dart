import 'package:dartz/dartz.dart';
import 'package:tatbeeqi/core/error/failures.dart';
import 'package:tatbeeqi/features/posts/domain/entities/post.dart';
import 'package:tatbeeqi/features/posts/domain/repositories/post_repository.dart';

class SyncLatestPostsUseCase {
  final PostRepository repository;

  SyncLatestPostsUseCase(this.repository);

  Future<Either<Failure, List<Post>>> call() async {
    return await repository.syncLatestPosts();
  }
}
