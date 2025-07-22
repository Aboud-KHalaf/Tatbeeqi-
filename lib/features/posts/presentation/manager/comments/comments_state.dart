import 'package:equatable/equatable.dart';
import 'package:tatbeeqi/features/posts/domain/entities/comment.dart';

abstract class CommentsState extends Equatable {
  const CommentsState();

  @override
  List<Object> get props => [];
}

class CommentsInitial extends CommentsState {}

class CommentsLoading extends CommentsState {}

class CommentsLoaded extends CommentsState {
  final List<Comment> comments;
  final bool hasReachedMax;
  final bool isLoadingMore;

  const CommentsLoaded({
    required this.comments,
    this.hasReachedMax = false,
    this.isLoadingMore = false,
  });

  CommentsLoaded copyWith({
    List<Comment>? comments,
    bool? hasReachedMax,
    bool? isLoadingMore,
  }) {
    return CommentsLoaded(
      comments: comments ?? this.comments,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }

  @override
  List<Object> get props => [comments, hasReachedMax, isLoadingMore];
}

class CommentsError extends CommentsState {
  final String message;

  const CommentsError(this.message);

  @override
  List<Object> get props => [message];
}
