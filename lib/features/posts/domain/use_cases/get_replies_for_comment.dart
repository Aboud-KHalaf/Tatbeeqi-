import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:tatbeeqi/core/error/failures.dart';
import 'package:tatbeeqi/core/usecases/usecase.dart';
import 'package:tatbeeqi/features/posts/domain/entities/comment_reply.dart';
import 'package:tatbeeqi/features/posts/domain/repositories/post_repository.dart';

class GetRepliesForCommentUseCase
    implements UseCase<List<CommentReply>, GetRepliesParams> {
  final PostRepository repository;

  GetRepliesForCommentUseCase(this.repository);

  @override
  Future<Either<Failure, List<CommentReply>>> call(
      GetRepliesParams params) async {
    return await repository.getRepliesForComment(params.commentId);
  }
}

class GetRepliesParams extends Equatable {
  final String commentId;

  const GetRepliesParams({required this.commentId});

  @override
  List<Object?> get props => [commentId];
}
