import 'package:equatable/equatable.dart';

abstract class CommentsEvent extends Equatable {
  const CommentsEvent();

  @override
  List<Object> get props => [];
}

class FetchCommentsRequested extends CommentsEvent {
  final String postId;

  const FetchCommentsRequested(this.postId);

  @override
  List<Object> get props => [postId];
}
