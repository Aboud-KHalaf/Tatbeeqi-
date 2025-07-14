import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tatbeeqi/features/posts/domain/use_cases/get_comments_use_case.dart';
import 'package:tatbeeqi/features/posts/domain/use_cases/remove_comment_use_case.dart';
import 'package:tatbeeqi/features/posts/domain/use_cases/update_comment_use_case.dart';
import 'comments_event.dart';
import 'comments_state.dart';

class CommentsBloc extends Bloc<CommentsEvent, CommentsState> {
  final GetCommentsUseCase getCommentsUseCase;
  final UpdateCommentUseCase updateCommentUseCase;
  final RemoveCommentUseCase removeCommentUseCase;
  CommentsBloc(this.getCommentsUseCase, this.updateCommentUseCase,
      this.removeCommentUseCase)
      : super(CommentsInitial()) {
    on<FetchCommentsRequested>(_onFetchCommentsRequested);
    on<DeleteCommentRequested>(_onDeleteCommentRequested);
    on<UpdateCommentRequested>(_onUpdateCommentRequested);
  }

  Future<void> _onFetchCommentsRequested(
    FetchCommentsRequested event,
    Emitter<CommentsState> emit,
  ) async {
    emit(CommentsLoading());
    final failureOrComments = await getCommentsUseCase(event.postId);
    failureOrComments.fold(
      (failure) => emit(CommentsError(failure.message)),
      (comments) => emit(CommentsLoaded(comments)),
    );
  }

  Future<void> _onDeleteCommentRequested(
    DeleteCommentRequested event,
    Emitter<CommentsState> emit,
  ) async {
    emit(CommentsLoading());
    final failureOrComments = await removeCommentUseCase(event.commentId);
    failureOrComments.fold(
      (failure) => emit(CommentsError(failure.message)),
      (comments) => emit(ComentDeleted()),
    );
  }

  Future<void> _onUpdateCommentRequested(
    UpdateCommentRequested event,
    Emitter<CommentsState> emit,
  ) async {
    emit(CommentsLoading());
    final failureOrComments = await updateCommentUseCase(event.comment);
    failureOrComments.fold(
      (failure) => emit(CommentsError(failure.message)),
      (comments) => emit(CommentUpdated()),
    );
  }
}
