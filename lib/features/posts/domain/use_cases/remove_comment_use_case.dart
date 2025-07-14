
import 'package:dartz/dartz.dart';
import 'package:tatbeeqi/core/error/failures.dart';
import 'package:tatbeeqi/core/usecases/usecase.dart';
import 'package:tatbeeqi/features/posts/domain/repositories/post_repository.dart';

class RemoveCommentUseCase extends UseCase<void, String> {
  final PostRepository postRepository;

  RemoveCommentUseCase(this.postRepository);

  @override
  Future<Either<Failure, void>> call(String commentId) async {
    return await postRepository.removeComment(commentId);
  }
}