import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tatbeeqi/features/posts/domain/entities/post.dart';
import 'package:tatbeeqi/features/posts/domain/use_cases/create_post_use_case.dart';
import 'package:uuid/uuid.dart';
import 'create_post_event.dart';
import 'create_post_state.dart';

class CreatePostBloc extends Bloc<CreatePostEvent, CreatePostState> {
  final CreatePostUseCase createPostUseCase;

  CreatePostBloc(this.createPostUseCase) : super(CreatePostInitial()) {
    on<CreatePostSubmitted>(_onPostSubmitted);
  }

  Future<void> _onPostSubmitted(
    CreatePostSubmitted event,
    Emitter<CreatePostState> emit,
  ) async {
    emit(CreatePostInProgress());

    // In a real app, authorId, authorName, and authorAvatarUrl would come from an auth service.
    final newPost = Post(
      id: const Uuid().v4(),
      authorId: '257c78e5-98e7-47eb-99de-2ee0a9e40b19', // Placeholder
      authorName: 'عبود', // Placeholder
      authorAvatarUrl: 'https://i.pravatar.cc/150?u=current_user_id', // Placeholder
      text: event.text,
      categories: event.categories,
      topics: event.topics,
      imageUrl: event.imagePath, // This would be an uploaded URL in a real app
      createdAt: DateTime.now(),
    );

    final failureOrSuccess = await createPostUseCase(newPost);

    failureOrSuccess.fold(
      (failure) => emit(CreatePostFailure(failure.message)),
      (_) => emit(CreatePostSuccess()),
    );
  }
}
