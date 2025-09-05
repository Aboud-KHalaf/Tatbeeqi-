import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tatbeeqi/features/posts/domain/entities/post.dart';
import 'package:tatbeeqi/features/posts/domain/use_cases/get_my_posts_use_case.dart';
import 'package:tatbeeqi/features/posts/domain/use_cases/delete_post_use_case.dart';
import 'package:tatbeeqi/features/posts/domain/use_cases/update_post_use_case.dart';
import 'package:tatbeeqi/features/posts/presentation/manager/my_posts/my_posts_state.dart';

class MyPostsCubit extends Cubit<MyPostsState> {
  final GetMyPostsUseCase getMyPostsUseCase;
  final DeletePostUseCase deletePostUseCase;
  final UpdatePostUseCase updatePostUseCase;

  MyPostsCubit({
    required this.getMyPostsUseCase,
    required this.deletePostUseCase,
    required this.updatePostUseCase,
  }) : super(MyPostsInitial());

  static const int _limit = 10;
  int _currentPage = 0;

  Future<void> fetchMyPosts() async {
    if (state is MyPostsLoading) return;

    emit(MyPostsLoading());
    _currentPage = 0;

    final result = await getMyPostsUseCase(start: 0, limit: _limit);

    result.fold(
      (failure) => emit(MyPostsError(failure.toString())),
      (posts) {
        emit(MyPostsLoaded(
          posts: posts,
          hasReachedMax: posts.length < _limit,
        ));
      },
    );
  }

  Future<void> loadMorePosts() async {
    final currentState = state;
    if (currentState is! MyPostsLoaded || currentState.hasReachedMax || currentState.isLoadingMore) {
      return;
    }

    emit(currentState.copyWith(isLoadingMore: true));
    _currentPage++;

    final result = await getMyPostsUseCase(start: _currentPage * _limit, limit: _limit);

    result.fold(
      (failure) => emit(MyPostsError(failure.toString())),
      (newPosts) {
        final updatedPosts = List.of(currentState.posts)..addAll(newPosts);
        emit(MyPostsLoaded(
          posts: updatedPosts,
          hasReachedMax: newPosts.length < _limit,
          isLoadingMore: false,
        ));
      },
    );
  }

  Future<void> refreshPosts() async {
    _currentPage = 0;
    await fetchMyPosts();
  }

  Future<void> deletePost(String postId) async {
    final currentState = state;
    if (currentState is! MyPostsLoaded) return;

    final result = await deletePostUseCase(postId);
    
    result.fold(
      (failure) => emit(MyPostsError(failure.toString())),
      (_) {
        final updatedPosts = currentState.posts.where((post) => post.id != postId).toList();
        emit(currentState.copyWith(posts: updatedPosts));
      },
    );
  }

  Future<void> updatePost(Post updatedPost) async {
    final currentState = state;
    if (currentState is! MyPostsLoaded) return;

    final result = await updatePostUseCase(updatedPost);
    
    result.fold(
      (failure) => emit(MyPostsError(failure.toString())),
      (post) {
        final updatedPosts = currentState.posts.map((p) => p.id == post.id ? post : p).toList();
        emit(currentState.copyWith(posts: updatedPosts));
      },
    );
  }
}
