import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tatbeeqi/features/posts/domain/use_cases/get_comments_use_case.dart';
import 'comments_event.dart';
import 'comments_state.dart';

class CommentsBloc extends Bloc<CommentsEvent, CommentsState> {
  final GetCommentsUseCase getCommentsUseCase;

  CommentsBloc(this.getCommentsUseCase) : super(CommentsInitial()) {
    on<FetchCommentsRequested>(_onFetchCommentsRequested);
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
}
