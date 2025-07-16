import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:tatbeeqi/core/error/failures.dart';
import 'package:tatbeeqi/core/usecases/usecase.dart';
import 'package:tatbeeqi/features/posts/domain/repositories/post_repository.dart';

class ReplyOnCommentUseCase implements UseCase<Unit, ReplyOnCommentParams> {
  final PostRepository repository;

  ReplyOnCommentUseCase(this.repository);

  @override
  Future<Either<Failure, Unit>> call(ReplyOnCommentParams params) async {
    return await repository.replyOnComment(params.commentId, params.text);
  }
}

class ReplyOnCommentParams extends Equatable {
  final String commentId;
  final String text;

  const ReplyOnCommentParams({required this.commentId, required this.text});

  @override
  List<Object?> get props => [commentId, text];
}
