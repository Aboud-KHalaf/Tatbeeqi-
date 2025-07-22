import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tatbeeqi/features/posts/domain/entities/comment.dart';
import 'package:tatbeeqi/features/posts/domain/use_cases/add_comment_use_case.dart';
import 'package:tatbeeqi/features/posts/domain/use_cases/get_comments_use_case.dart';
import 'package:tatbeeqi/features/posts/domain/use_cases/remove_comment_use_case.dart';
import 'package:tatbeeqi/features/posts/domain/use_cases/update_comment_use_case.dart';
import 'comments_event.dart';
import 'comments_state.dart';

class CommentsBloc extends Bloc<CommentsEvent, CommentsState> {
  final GetCommentsUseCase getCommentsUseCase;
  final UpdateCommentUseCase updateCommentUseCase;
  final RemoveCommentUseCase removeCommentUseCase;
  final AddCommentUseCase postCommentUseCase;

  static const int _commentsLimit = 10;

  CommentsBloc(
    this.getCommentsUseCase,
    this.updateCommentUseCase,
    this.removeCommentUseCase,
    this.postCommentUseCase,
  ) : super(CommentsInitial()) {
    on<FetchComments>(_onFetchCommentsRequested);
    on<RefreshComments>(_onRefreshCommentsRequested);
    on<LoadMoreComments>(_onLoadMoreCommentsRequested);
    on<DeleteComment>(_onDeleteCommentRequested);
    on<UpdateComment>(_onUpdateCommentRequested);
    on<AddComment>(_onPostCommentRequested);
  }

  Future<void> _onFetchCommentsRequested(
    FetchComments event,
    Emitter<CommentsState> emit,
  ) async {
    emit(CommentsLoading());
    final result = await getCommentsUseCase(event.postId, start: 0, limit: _commentsLimit);
    result.fold(
      (failure) => emit(CommentsError(failure.message)),
      (comments) => emit(CommentsLoaded(
        comments: comments,
        hasReachedMax: comments.length < _commentsLimit,
      )),
    );
  }

  Future<void> _onRefreshCommentsRequested(
    RefreshComments event,
    Emitter<CommentsState> emit,
  ) async {
    emit(CommentsLoading());
    final result = await getCommentsUseCase(event.postId, start: 0, limit: _commentsLimit);
    result.fold(
      (failure) => emit(CommentsError(failure.message)),
      (comments) => emit(CommentsLoaded(
        comments: comments,
        hasReachedMax: comments.length < _commentsLimit,
      )),
    );
  }

  Future<void> _onLoadMoreCommentsRequested(
    LoadMoreComments event,
    Emitter<CommentsState> emit,
  ) async {
    if (state is CommentsLoaded) {
      final currentState = state as CommentsLoaded;
      
      // Don't load more if already loading or reached max
      if (currentState.isLoadingMore || currentState.hasReachedMax) {
        return;
      }

      // Set loading more state
      emit(currentState.copyWith(isLoadingMore: true));

      // Use proper offset-based pagination:
      // First fetch: start=0, limit=10 → comments 0-9 (length=10)
      // Load more: start=10, limit=10 → comments 10-19 (length=20)
      // Load more: start=20, limit=10 → comments 20-29 (length=30)
      final nextOffset = currentState.comments.length;
      final result = await getCommentsUseCase(
        event.postId,
        start: nextOffset,
        limit: _commentsLimit,
      );

      debugPrint("Comments - start: $nextOffset, limit: $_commentsLimit");

      result.fold(
        (failure) => emit(currentState.copyWith(
          isLoadingMore: false,
        )),
        (newComments) {
          final allComments = List<Comment>.from(currentState.comments)
            ..addAll(newComments);
          emit(CommentsLoaded(
            comments: allComments,
            hasReachedMax: newComments.length < _commentsLimit,
            isLoadingMore: false,
          ));
        },
      );
    }
  }

  Future<void> _onDeleteCommentRequested(
    DeleteComment event,
    Emitter<CommentsState> emit,
  ) async {
    if (state is CommentsLoaded) {
      final currentState = state as CommentsLoaded;
      final result = await removeCommentUseCase(event.commentId);
      result.fold(
        (failure) => emit(CommentsError(failure.message)),
        (_) {
          final updatedComments = currentState.comments
              .where((c) => c.id != event.commentId)
              .toList();
          emit(currentState.copyWith(comments: updatedComments));
        },
      );
    }
  }

  Future<void> _onUpdateCommentRequested(
    UpdateComment event,
    Emitter<CommentsState> emit,
  ) async {
    if (state is CommentsLoaded) {
      final currentState = state as CommentsLoaded;
      final result = await updateCommentUseCase(event.comment);
      result.fold(
        (failure) => emit(CommentsError(failure.message)),
        (_) {
          final updatedComments = currentState.comments.map((comment) {
            if (comment.id == event.comment.id) {
              return event.comment;
            }
            return comment;
          }).toList();
          emit(currentState.copyWith(comments: updatedComments));
        },
      );
    }
  }

  Future<void> _onPostCommentRequested(
    AddComment event,
    Emitter<CommentsState> emit,
  ) async {
    final comment = Comment(
      id: '',
      authorId: '',
      authorName: '',
      text: event.content,
      postId: event.postId,
      createdAt: DateTime.now(),
    );

    final result = await postCommentUseCase(comment);
    result.fold(
      (failure) => emit(CommentsError(failure.message)),
      (newComment) {
        if (state is CommentsLoaded) {
          final currentState = state as CommentsLoaded;
          final updatedComments = [newComment, ...currentState.comments];
          emit(currentState.copyWith(comments: updatedComments));
        } else {
          emit(CommentsLoaded(comments: [newComment]));
        }
      },
    );
  }
}
