import 'package:dartz/dartz.dart';
import 'package:tatbeeqi/core/error/failures.dart';
import 'package:tatbeeqi/features/posts/domain/repositories/post_repository.dart';

class UnlikePostUseCase {
  final PostRepository repository;

  UnlikePostUseCase(this.repository);

  Future<Either<Failure, void>> call(String postId) async {
    return await repository.unlikePost(postId);
  }
}
