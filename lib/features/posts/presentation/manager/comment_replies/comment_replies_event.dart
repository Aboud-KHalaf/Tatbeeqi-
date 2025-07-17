import 'package:equatable/equatable.dart';

abstract class CommentRepliesEvent extends Equatable {
  const CommentRepliesEvent();

  @override
  List<Object> get props => [];
}

class GetRepliesForCommentEvent extends CommentRepliesEvent {
  final String commentId;

  const GetRepliesForCommentEvent(this.commentId);

  @override
  List<Object> get props => [commentId];
}

class AddReplyEvent extends CommentRepliesEvent {
  final String commentId;
  final String text;

  const AddReplyEvent({required this.commentId, required this.text});

  @override
  List<Object> get props => [commentId, text];
}

class UpdateReplyEvent extends CommentRepliesEvent {
  final String replyId;
  final String newText;

  const UpdateReplyEvent({required this.replyId, required this.newText});

  @override
  List<Object> get props => [replyId, newText];
}

class DeleteReplyEvent extends CommentRepliesEvent {
  final String replyId;

  const DeleteReplyEvent(this.replyId);

  @override
  List<Object> get props => [replyId];
}
