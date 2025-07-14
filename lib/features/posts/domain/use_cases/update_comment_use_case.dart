import 'package:dartz/dartz.dart';
import 'package:tatbeeqi/core/error/failures.dart';
import 'package:tatbeeqi/core/usecases/usecase.dart';
import 'package:tatbeeqi/features/posts/domain/entities/comment.dart';
import 'package:tatbeeqi/features/posts/domain/repositories/post_repository.dart';

class UpdateCommentUseCase extends UseCase<void, Comment> {
  final PostRepository postRepository;

  UpdateCommentUseCase(this.postRepository);

  @override
  Future<Either<Failure, void>> call(Comment comment) async {
    return await postRepository.updateComment(comment);
  }
} 