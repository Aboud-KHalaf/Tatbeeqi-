import 'package:equatable/equatable.dart';
import 'package:tatbeeqi/features/posts/domain/entities/post.dart';

abstract class MyPostsState extends Equatable {
  const MyPostsState();

  @override
  List<Object> get props => [];
}

class MyPostsInitial extends MyPostsState {}

class MyPostsLoading extends MyPostsState {}

class MyPostsLoaded extends MyPostsState {
  final List<Post> posts;
  final bool hasReachedMax;
  final bool isLoadingMore;

  const MyPostsLoaded({
    required this.posts,
    this.hasReachedMax = false,
    this.isLoadingMore = false,
  });

  MyPostsLoaded copyWith({
    List<Post>? posts,
    bool? hasReachedMax,
    bool? isLoadingMore,
  }) {
    return MyPostsLoaded(
      posts: posts ?? this.posts,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }

  @override
  List<Object> get props => [posts, hasReachedMax, isLoadingMore];
}

class MyPostsError extends MyPostsState {
  final String message;

  const MyPostsError(this.message);

  @override
  List<Object> get props => [message];
}
