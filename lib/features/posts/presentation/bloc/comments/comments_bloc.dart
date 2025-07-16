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

  List<Comment> _comments = [];

  CommentsBloc(
    this.getCommentsUseCase,
    this.updateCommentUseCase,
    this.removeCommentUseCase,
    this.postCommentUseCase,
  ) : super(CommentsInitial()) {
    on<FetchComments>(_onFetchCommentsRequested);
    on<DeleteComment>(_onDeleteCommentRequested);
    on<UpdateComment>(_onUpdateCommentRequested);
    on<AddComment>(_onPostCommentRequested);
  }

  Future<void> _onFetchCommentsRequested(
    FetchComments event,
    Emitter<CommentsState> emit,
  ) async {
    emit(CommentsLoading());
    final result = await getCommentsUseCase(event.postId);
    result.fold(
      (failure) => emit(CommentsError(failure.message)),
      (comments) {
        _comments = comments;
        emit(CommentsLoaded(List.of(_comments))); // create a new list to trigger UI update
      },
    );
  }

  Future<void> _onDeleteCommentRequested(
    DeleteComment event,
    Emitter<CommentsState> emit,
  ) async {
    final result = await removeCommentUseCase(event.commentId);
    result.fold(
      (failure) => emit(CommentsError(failure.message)),
      (_) {
        _comments.removeWhere((c) => c.id == event.commentId);
        emit(CommentsLoaded(List.of(_comments)));
      },
    );
  }

  Future<void> _onUpdateCommentRequested(
    UpdateComment event,
    Emitter<CommentsState> emit,
  ) async {
    final result = await updateCommentUseCase(event.comment);
    result.fold(
      (failure) => emit(CommentsError(failure.message)),
      (_) {
        final index = _comments.indexWhere((c) => c.id == event.comment.id);
        if (index != -1) {
          _comments[index] = event.comment;
        }
        emit(CommentsLoaded(List.of(_comments)));
      },
    );
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
        _comments.add(newComment);
        emit(CommentsLoaded(List.of(_comments)));
      },
    );
  }
}
