import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:tatbeeqi/core/error/failures.dart';
import 'package:tatbeeqi/core/usecases/usecase.dart';
import 'package:tatbeeqi/features/posts/domain/repositories/post_repository.dart';

class DeleteReplyOnCommentUseCase implements UseCase<Unit, DeleteReplyParams> {
  final PostRepository repository;

  DeleteReplyOnCommentUseCase(this.repository);

  @override
  Future<Either<Failure, Unit>> call(DeleteReplyParams params) async {
    return await repository.deleteReplyOnComment(params.replyId);
  }
}

class DeleteReplyParams extends Equatable {
  final String replyId;

  const DeleteReplyParams({required this.replyId});

  @override
  List<Object?> get props => [replyId];
}
