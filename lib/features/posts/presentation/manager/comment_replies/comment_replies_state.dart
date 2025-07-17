import 'package:equatable/equatable.dart';
import 'package:tatbeeqi/features/posts/domain/entities/comment_reply.dart';

abstract class CommentRepliesState extends Equatable {
  const CommentRepliesState();

  @override
  List<Object> get props => [];
}

class CommentRepliesInitial extends CommentRepliesState {}

class CommentRepliesLoading extends CommentRepliesState {}

class CommentRepliesLoaded extends CommentRepliesState {
  final List<CommentReply> replies;

  const CommentRepliesLoaded(this.replies);

  @override
  List<Object> get props => [replies];
}

class CommentRepliesError extends CommentRepliesState {
  final String message;

  const CommentRepliesError(this.message);

  @override
  List<Object> get props => [message];
}

class CommentReplyOperationSuccess extends CommentRepliesState {}
