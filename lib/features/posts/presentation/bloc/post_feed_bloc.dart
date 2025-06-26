import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tatbeeqi/features/posts/domain/use_cases/get_posts_use_case.dart';
import 'package:tatbeeqi/features/posts/presentation/bloc/post_feed/post_feed_event.dart';
import 'post_feed/post_feed_state.dart';

class PostFeedBloc extends Bloc<PostFeedEvent, PostFeedState> {
  final GetPostsUseCase getPostsUseCase;

  PostFeedBloc(this.getPostsUseCase) : super(PostFeedInitial()) {
    on<FetchPostsRequested>(_onFetchPostsRequested);
    on<RefreshPostsRequested>(_onFetchPostsRequested);
  }

  Future<void> _onFetchPostsRequested(
    PostFeedEvent event,
    Emitter<PostFeedState> emit,
  ) async {
    emit(PostFeedLoading());
    final failureOrPosts = await getPostsUseCase(limit: 20);
    failureOrPosts.fold(
      (failure) => emit(PostFeedError(failure.message)),
      (posts) => emit(PostFeedLoaded(posts)),
    );
  }
}
