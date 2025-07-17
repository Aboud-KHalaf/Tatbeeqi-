import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'create_post_event.dart';
import 'create_post_state.dart';
import 'package:tatbeeqi/features/posts/domain/entities/post.dart';
import 'package:tatbeeqi/features/posts/domain/use_cases/create_post_use_case.dart';
import 'package:tatbeeqi/features/posts/domain/use_cases/delete_post_use_case.dart';
import 'package:tatbeeqi/features/posts/domain/use_cases/update_post_use_case.dart';
import 'package:tatbeeqi/features/posts/domain/use_cases/upload_image_use_case.dart';

class PostCrudBloc extends Bloc<PostCrudEvent, PostCrudState> {
  final CreatePostUseCase createPostUseCase;
  final UpdatePostUseCase updatePostUseCase;
  final DeletePostUseCase deletePostUseCase;
  final UploadImageUseCase uploadImageUseCase;

  PostCrudBloc(
    this.createPostUseCase,
    this.updatePostUseCase,
    this.deletePostUseCase,
    this.uploadImageUseCase,
  ) : super(CreatePostInitial()) {
    on<CreatePostEvent>(_onCreatePost);
    on<UpdatePostEvent>(_onUpdatePost);
    on<DeletePostEvent>(_onDeletePost);
  }

  Future<void> _onCreatePost(
    CreatePostEvent event,
    Emitter<PostCrudState> emit,
  ) async {
    emit(CreatePostInProgress());

    String? imageUrl;
    if (event.image != null) {
      imageUrl = await uploadPostImage(event.image!);
    }

    final post = Post(
      id: '',
      authorId: '', // Replace with actual author ID
      authorName: 'غير محدد', // Replace with actual author name
      text: event.text,
      categories: event.categories,
      topics: event.topics,
      imageUrl: imageUrl,
      createdAt: DateTime.now(),
      isArticle: event.isArticle,
    );

    final result = await createPostUseCase(post);
    result.fold(
      (failure) => emit(CreatePostFailure(failure.message)),
      (_) => emit(CreatePostSuccess()),
    );
  }

  Future<void> _onUpdatePost(
    UpdatePostEvent event,
    Emitter<PostCrudState> emit,
  ) async {
    emit(CreatePostInProgress());

    final post = Post(
      id: event.postId,
      authorId: '', // Replace with actual author ID
      authorName: 'غير محدد', // Replace with actual author name
      text: event.text,
      categories: event.categories,
      topics: event.topics,
      imageUrl: event.imagePath,
      createdAt: DateTime.now(),
      isArticle: event.isArticle,
    );

    final result = await updatePostUseCase(post);
    result.fold(
      (failure) => emit(CreatePostFailure(failure.message)),
      (_) => emit(CreatePostSuccess()),
    );
  }

  Future<void> _onDeletePost(
    DeletePostEvent event,
    Emitter<PostCrudState> emit,
  ) async {
    emit(CreatePostInProgress());

    final result = await deletePostUseCase(event.postId);
    result.fold(
      (failure) => emit(CreatePostFailure(failure.message)),
      (_) => emit(CreatePostSuccess()),
    );
  }

  Future<String?> uploadPostImage(File image) async {
    String? imageUrl;
    final result = await uploadImageUseCase(image);
    result.fold(
      (faiure) => print(faiure.message),
      (url) => imageUrl = url,
    );
    return imageUrl;
  }
}
