import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tatbeeqi/features/posts/domain/entities/post.dart';
import 'package:tatbeeqi/features/posts/domain/use_cases/create_post_use_case.dart';
import 'package:tatbeeqi/features/posts/domain/use_cases/delete_post_use_case.dart';
import 'package:tatbeeqi/features/posts/domain/use_cases/update_post_use_case.dart';
import 'package:uuid/uuid.dart';
import 'create_post_event.dart';
import 'create_post_state.dart';

class PostCrudBloc extends Bloc<PostCrudEvent, PostCrudState> {
  final CreatePostUseCase createPostUseCase;
  final UpdatePostUseCase updatePostUseCase;
  final DeletePostUseCase deletePostUseCase;
  PostCrudBloc(
      this.createPostUseCase, this.updatePostUseCase, this.deletePostUseCase)
      : super(CreatePostInitial()) {
    on<CreatePostEvent>(_onPostSubmitted);
    on<UpdatePostEvent>(_onUpdatePostSubmitted);
    on<DeletePostEvent>(_onDeletePostSubmitted);
  }

  Future<void> _onPostSubmitted(
    CreatePostEvent event,
    Emitter<PostCrudState> emit,
  ) async {
    emit(CreatePostInProgress());

    final newPost = Post(
      id: const Uuid().v4(),
      authorId: '', // Placeholder
      authorName: 'غير محدد', // Placeholder
      text: event.text,
      categories: event.categories,
      topics: event.topics,
      imageUrl: event.imagePath, // This would be an uploaded URL in a real app
      createdAt: DateTime.now(),
      isArticle: event.isArticle,
    );

    final failureOrSuccess = await createPostUseCase(newPost);

    failureOrSuccess.fold(
      (failure) => emit(CreatePostFailure(failure.message)),
      (_) => emit(CreatePostSuccess()),
    );
  }

  Future<void> _onUpdatePostSubmitted(
    UpdatePostEvent event,
    Emitter<PostCrudState> emit,
  ) async {
    emit(CreatePostInProgress());

    final updatedPost = Post(
      id: event.postId,
      authorId: '', // Placeholder
      authorName: 'غير محدد', // Placeholder
      text: event.text,
      categories: event.categories,
      topics: event.topics,
      imageUrl: event.imagePath, // This would be an uploaded URL in a real app
      createdAt: DateTime.now(),
      isArticle: event.isArticle,
    );

    final failureOrSuccess = await updatePostUseCase(updatedPost);

    failureOrSuccess.fold(
      (failure) => emit(CreatePostFailure(failure.message)),
      (_) => emit(CreatePostSuccess()),
    );
  }

  Future<void> _onDeletePostSubmitted(
    DeletePostEvent event,
    Emitter<PostCrudState> emit,
  ) async {
    emit(CreatePostInProgress());

    final failureOrSuccess = await deletePostUseCase(event.postId);

    failureOrSuccess.fold(
      (failure) => emit(CreatePostFailure(failure.message)),
      (_) => emit(CreatePostSuccess()),
    );
  }
}
