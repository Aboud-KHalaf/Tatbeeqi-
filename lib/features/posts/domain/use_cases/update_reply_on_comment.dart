import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:tatbeeqi/core/error/failures.dart';
import 'package:tatbeeqi/core/usecases/usecase.dart';
import 'package:tatbeeqi/features/posts/domain/repositories/post_repository.dart';

class UpdateReplyOnCommentUseCase implements UseCase<Unit, UpdateReplyParams> {
  final PostRepository repository;

  UpdateReplyOnCommentUseCase(this.repository);

  @override
  Future<Either<Failure, Unit>> call(UpdateReplyParams params) async {
    return await repository.updateReplyOnComment(
        params.replyId, params.newText);
  }
}

class UpdateReplyParams extends Equatable {
  final String replyId;
  final String newText;

  const UpdateReplyParams({required this.replyId, required this.newText});

  @override
  List<Object?> get props => [replyId, newText];
}
