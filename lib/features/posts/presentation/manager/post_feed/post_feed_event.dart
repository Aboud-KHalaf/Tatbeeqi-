import 'package:equatable/equatable.dart';

abstract class PostsEvent extends Equatable {
  const PostsEvent();

  @override
  List<Object> get props => [];
}

class FetchPostsEvent extends PostsEvent {}

class RefreshPostsEvent extends PostsEvent {}

class LoadMorePostsEvent extends PostsEvent {}

class LikePostToggledEvent extends PostsEvent {
  final String postId;

  const LikePostToggledEvent(this.postId);

  @override
  List<Object> get props => [postId];
}

class IncrementPostCommentCountEvent extends PostsEvent {
  final String postId;

  const IncrementPostCommentCountEvent(this.postId);

  @override
  List<Object> get props => [postId];
}
