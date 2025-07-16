import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tatbeeqi/features/posts/domain/entities/post.dart';
import 'package:tatbeeqi/features/posts/domain/use_cases/get_posts_use_case.dart';
import 'package:tatbeeqi/features/posts/domain/use_cases/like_post_use_case.dart';
import 'package:tatbeeqi/features/posts/domain/use_cases/unlike_post_use_case.dart';
import 'post_feed_event.dart';
import 'post_feed_state.dart';

class PostsBloc extends Bloc<PostsEvent, PostsState> {
  final GetPostsUseCase _getPostsUseCase;
  final LikePostUseCase _likePostUseCase;
  final UnlikePostUseCase _unlikePostUseCase;

  PostsBloc({
    required GetPostsUseCase getPostsUseCase,
    required LikePostUseCase likePostUseCase,
    required UnlikePostUseCase unlikePostUseCase,
  })  : _getPostsUseCase = getPostsUseCase,
        _likePostUseCase = likePostUseCase,
        _unlikePostUseCase = unlikePostUseCase,
        super(PostsInitial()) {
    on<FetchPostsRequested>(_onFetchPostsRequested);
    on<RefreshPostsRequested>(_onFetchPostsRequested);
    on<LikePostToggled>(_onLikePostToggled);
    on<IncrementPostCommentCount>(_onIncrementCommentCount);
  }

  Future<void> _onFetchPostsRequested(
    PostsEvent event,
    Emitter<PostsState> emit,
  ) async {
    emit(PostsLoading());
    final failureOrPosts = await _getPostsUseCase(limit: 20);
    failureOrPosts.fold(
      (failure) => emit(PostsError(failure.message)),
      (posts) => emit(PostsLoaded(posts)),
    );
  }

  Future<void> _onLikePostToggled(
    LikePostToggled event,
    Emitter<PostsState> emit,
  ) async {
    if (state is PostsLoaded) {
      final currentState = state as PostsLoaded;
      final postIndex =
          currentState.posts.indexWhere((p) => p.id == event.postId);
      if (postIndex == -1) return;

      final post = currentState.posts[postIndex];
      final updatedPost = post.copyWith(
        isLiked: !post.isLiked,
        likesCount: post.isLiked ? post.likesCount - 1 : post.likesCount + 1,
      );

      final updatedPosts = List<Post>.from(currentState.posts);
      updatedPosts[postIndex] = updatedPost;

      emit(PostsLoaded(updatedPosts));

      if (updatedPost.isLiked) {
        await _likePostUseCase(event.postId);
      } else {
        await _unlikePostUseCase(event.postId);
      }
    }
  }

  Future<void> _onIncrementCommentCount(
    IncrementPostCommentCount event,
    Emitter<PostsState> emit,
  ) async {
    if (state is PostsLoaded) {
      final currentState = state as PostsLoaded;
      final updatedPosts = currentState.posts.map((post) {
        if (post.id == event.postId) {
          return post.copyWith(commentsCount: post.commentsCount + 1);
        }
        return post;
      }).toList();

      emit(PostsLoaded(updatedPosts));
    }
  }
}
