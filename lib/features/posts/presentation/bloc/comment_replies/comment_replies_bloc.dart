import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tatbeeqi/features/posts/domain/use_cases/delete_reply_on_comment.dart';
import 'package:tatbeeqi/features/posts/domain/use_cases/get_replies_for_comment.dart';
import 'package:tatbeeqi/features/posts/domain/use_cases/reply_on_comment.dart';
import 'package:tatbeeqi/features/posts/domain/use_cases/update_reply_on_comment.dart';
import 'package:tatbeeqi/features/posts/presentation/bloc/comment_replies/comment_replies_event.dart';
import 'package:tatbeeqi/features/posts/presentation/bloc/comment_replies/comment_replies_state.dart';

class CommentRepliesBloc
    extends Bloc<CommentRepliesEvent, CommentRepliesState> {
  final GetRepliesForCommentUseCase getRepliesForComment;
  final ReplyOnCommentUseCase replyOnComment;
  final UpdateReplyOnCommentUseCase updateReplyOnComment;
  final DeleteReplyOnCommentUseCase deleteReplyOnComment;

  CommentRepliesBloc(
    this.getRepliesForComment,
    this.replyOnComment,
    this.updateReplyOnComment,
    this.deleteReplyOnComment,
  ) : super(CommentRepliesInitial()) {
    on<GetRepliesForCommentEvent>(_onGetRepliesForComment);
    on<AddReplyEvent>(_onAddReply);
    on<UpdateReplyEvent>(_onUpdateReply);
    on<DeleteReplyEvent>(_onDeleteReply);
  }

  Future<void> _onGetRepliesForComment(GetRepliesForCommentEvent event,
      Emitter<CommentRepliesState> emit) async {
    emit(CommentRepliesLoading());
    final failureOrReplies = await getRepliesForComment(
        GetRepliesParams(commentId: event.commentId));
    failureOrReplies.fold(
      (failure) => emit(CommentRepliesError(failure.message)),
      (replies) => emit(CommentRepliesLoaded(replies)),
    );
  }

  Future<void> _onAddReply(
      AddReplyEvent event, Emitter<CommentRepliesState> emit) async {
    final failureOrDone = await replyOnComment(
        ReplyOnCommentParams(commentId: event.commentId, text: event.text));
    failureOrDone.fold(
      (failure) => emit(CommentRepliesError(failure.message)),
      (_) {
        emit(CommentReplyOperationSuccess());
        add(GetRepliesForCommentEvent(event.commentId));
      },
    );
  }

  Future<void> _onUpdateReply(
      UpdateReplyEvent event, Emitter<CommentRepliesState> emit) async {
    final failureOrDone = await updateReplyOnComment(
        UpdateReplyParams(replyId: event.replyId, newText: event.newText));
    failureOrDone.fold(
      (failure) => emit(CommentRepliesError(failure.message)),
      (_) => emit(CommentReplyOperationSuccess()),
    );
  }

  Future<void> _onDeleteReply(
      DeleteReplyEvent event, Emitter<CommentRepliesState> emit) async {
    final failureOrDone =
        await deleteReplyOnComment(DeleteReplyParams(replyId: event.replyId));
    failureOrDone.fold(
      (failure) => emit(CommentRepliesError(failure.message)),
      (_) => emit(CommentReplyOperationSuccess()),
    );
  }
}
