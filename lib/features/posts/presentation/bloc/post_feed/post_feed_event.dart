import 'package:equatable/equatable.dart';

abstract class PostsEvent extends Equatable {
  const PostsEvent();

  @override
  List<Object> get props => [];
}

class FetchPostsRequested extends PostsEvent {}

class RefreshPostsRequested extends PostsEvent {}

class LikePostToggled extends PostsEvent {
  final String postId;

  const LikePostToggled(this.postId);

  @override
  List<Object> get props => [postId];
}
