import 'package:equatable/equatable.dart';
import 'package:tatbeeqi/features/posts/domain/entities/comment.dart';

abstract class CommentsEvent extends Equatable {
  const CommentsEvent();

  @override
  List<Object> get props => [];
}

class FetchCommentsRequested extends CommentsEvent {
  final String postId;

  const FetchCommentsRequested(this.postId);

  @override
  List<Object> get props => [postId];
}

class PostCommentRequested extends CommentsEvent {
  final String postId;
  final String content;

  const PostCommentRequested(this.postId, this.content);

  @override
  List<Object> get props => [postId, content];
}

class DeleteCommentRequested extends CommentsEvent {
  final String commentId;

  const DeleteCommentRequested(this.commentId);

  @override
  List<Object> get props => [commentId];
}

class UpdateCommentRequested extends CommentsEvent {
  final Comment comment;

  const UpdateCommentRequested(this.comment);

  @override
  List<Object> get props => [comment];
}
