import 'package:equatable/equatable.dart';

abstract class PostCrudState extends Equatable {
  const PostCrudState();

  @override
  List<Object> get props => [];
}

class CreatePostInitial extends PostCrudState {}

class CreatePostInProgress extends PostCrudState {}

class CreatePostSuccess extends PostCrudState {}

class CreatePostFailure extends PostCrudState {
  final String message;

  const CreatePostFailure(this.message);

  @override
  List<Object> get props => [message];
}
 
 class UpdatePostSuccess extends PostCrudState {}
 
 class UpdatePostFailure extends PostCrudState {
  final String message;

  const UpdatePostFailure(this.message);

  @override
  List<Object> get props => [message];
}
 
 class DeletePostSuccess extends PostCrudState {}
 
 class DeletePostFailure extends PostCrudState {
  final String message;

  const DeletePostFailure(this.message);

  @override
  List<Object> get props => [message];
}