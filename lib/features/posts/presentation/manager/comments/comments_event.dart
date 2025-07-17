import 'package:equatable/equatable.dart';
import 'package:tatbeeqi/features/posts/domain/entities/comment.dart';

abstract class CommentsEvent extends Equatable {
  const CommentsEvent();

  @override
  List<Object> get props => [];
}

class FetchComments extends CommentsEvent {
  final String postId;

  const FetchComments(this.postId);

  @override
  List<Object> get props => [postId];
}

class AddComment extends CommentsEvent {
  final String postId;
  final String content;

  const AddComment(this.postId, this.content);

  @override
  List<Object> get props => [postId, content];
}

class DeleteComment extends CommentsEvent {
  final String commentId;

  const DeleteComment(this.commentId);

  @override
  List<Object> get props => [commentId];
}

class UpdateComment extends CommentsEvent {
  final Comment comment;

  const UpdateComment(this.comment);

  @override
  List<Object> get props => [comment];
}
