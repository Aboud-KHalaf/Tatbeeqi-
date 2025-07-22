import 'package:flutter/foundation.dart';
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

  static const int _postsLimit = 10;

  PostsBloc({
    required GetPostsUseCase getPostsUseCase,
    required LikePostUseCase likePostUseCase,
    required UnlikePostUseCase unlikePostUseCase,
  })  : _getPostsUseCase = getPostsUseCase,
        _likePostUseCase = likePostUseCase,
        _unlikePostUseCase = unlikePostUseCase,
        super(PostsInitial()) {
    on<FetchPostsEvent>(_onFetchPostsRequested);
    on<RefreshPostsEvent>(_onRefreshPostsRequested);
    on<LoadMorePostsEvent>(_onLoadMorePostsRequested);
    on<LikePostToggledEvent>(_onLikePostToggled);
    on<IncrementPostCommentCountEvent>(_onIncrementCommentCount);
  }

  Future<void> _onFetchPostsRequested(
    PostsEvent event,
    Emitter<PostsState> emit,
  ) async {
    emit(PostsLoading());
    final failureOrPosts = await _getPostsUseCase(start: 0, limit: _postsLimit);
    failureOrPosts.fold(
      (failure) => emit(PostsError(failure.message)),
      (posts) => emit(PostsLoaded(
        posts: posts,
        hasReachedMax: posts.length < _postsLimit,
      )),
    );
  }

  Future<void> _onRefreshPostsRequested(
    RefreshPostsEvent event,
    Emitter<PostsState> emit,
  ) async {
    emit(PostsLoading());
    final failureOrPosts = await _getPostsUseCase(start: 0, limit: _postsLimit);
    failureOrPosts.fold(
      (failure) => emit(PostsError(failure.message)),
      (posts) => emit(PostsLoaded(
        posts: posts,
        hasReachedMax: posts.length < _postsLimit,
      )),
    );
  }

  Future<void> _onLoadMorePostsRequested(
    LoadMorePostsEvent event,
    Emitter<PostsState> emit,
  ) async {
    if (state is PostsLoaded) {
      final currentState = state as PostsLoaded;

      // Don't load more if already loading or reached max
      if (currentState.isLoadingMore || currentState.hasReachedMax) {
        return;
      }

      // Set loading more state
      emit(currentState.copyWith(isLoadingMore: true));

      // Use proper offset-based pagination:
      // First fetch: start=0, limit=10 → posts 0-9 (length=10)
      // Load more: start=10, limit=10 → posts 10-19 (length=20)
      // Load more: start=20, limit=10 → posts 20-29 (length=30)
      final nextOffset = currentState.posts.length;
      final failureOrPosts = await _getPostsUseCase(
        start: nextOffset,
        limit: _postsLimit,
      );

      debugPrint("start: $nextOffset , limit: ${_postsLimit + nextOffset}");

      failureOrPosts.fold(
        (failure) => emit(currentState.copyWith(
          isLoadingMore: false,
        )),
        (newPosts) {
          final allPosts = List<Post>.from(currentState.posts)
            ..addAll(newPosts);
          emit(PostsLoaded(
            posts: allPosts,
            hasReachedMax: newPosts.length < _postsLimit,
            isLoadingMore: false,
          ));
        },
      );
    }
  }

  Future<void> _onLikePostToggled(
    LikePostToggledEvent event,
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

      emit(currentState.copyWith(posts: updatedPosts));

      if (updatedPost.isLiked) {
        await _likePostUseCase(event.postId);
      } else {
        await _unlikePostUseCase(event.postId);
      }
    }
  }

  Future<void> _onIncrementCommentCount(
    IncrementPostCommentCountEvent event,
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

      emit(currentState.copyWith(posts: updatedPosts));
    }
  }
}
