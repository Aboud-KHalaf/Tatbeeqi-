import 'package:equatable/equatable.dart';
import 'package:tatbeeqi/features/posts/domain/entities/post.dart';

abstract class PostFeedState extends Equatable {
  const PostFeedState();

  @override
  List<Object> get props => [];
}

class PostFeedInitial extends PostFeedState {}

class PostFeedLoading extends PostFeedState {}

class PostFeedLoaded extends PostFeedState {
  final List<Post> posts;

  const PostFeedLoaded(this.posts);

  @override
  List<Object> get props => [posts];
}

class PostFeedError extends PostFeedState {
  final String message;

  const PostFeedError(this.message);

  @override
  List<Object> get props => [message];
}
