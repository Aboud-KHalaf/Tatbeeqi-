import 'package:equatable/equatable.dart';

abstract class PostFeedEvent extends Equatable {
  const PostFeedEvent();

  @override
  List<Object> get props => [];
}

class FetchPostsRequested extends PostFeedEvent {}

class RefreshPostsRequested extends PostFeedEvent {}
