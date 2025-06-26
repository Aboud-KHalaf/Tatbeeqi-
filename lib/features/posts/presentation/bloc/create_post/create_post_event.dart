import 'package:equatable/equatable.dart';

abstract class CreatePostEvent extends Equatable {
  const CreatePostEvent();

  @override
  List<Object?> get props => [];
}

class CreatePostSubmitted extends CreatePostEvent {
  final String text;
  final List<String> categories;
  final String? imagePath;

  const CreatePostSubmitted({
    required this.text,
    required this.categories,
    this.imagePath,
  });

  @override
  List<Object?> get props => [text, categories, imagePath];
}
