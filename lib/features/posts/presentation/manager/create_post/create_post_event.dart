import 'dart:io';

import 'package:equatable/equatable.dart';

abstract class PostCrudEvent extends Equatable {
  const PostCrudEvent();

  @override
  List<Object?> get props => [];
}

class CreatePostEvent extends PostCrudEvent {
  final String text;
  final List<String> categories;
  final List<String> topics;
  final File? image;
  final bool isArticle;

  const CreatePostEvent({
    required this.text,
    required this.categories,
    required this.topics,
    this.image,
    required this.isArticle,
  });

  @override
  List<Object?> get props => [text, categories, topics, image, isArticle];
}

class UpdatePostEvent extends PostCrudEvent {
  final String text;
  final List<String> categories;
  final List<String> topics;
  final String? imagePath;
  final bool isArticle;
  final String postId;
  const UpdatePostEvent({
    required this.postId,
    required this.text,
    required this.categories,
    required this.topics,
    this.imagePath,
    required this.isArticle,
  });

  @override
  List<Object?> get props => [text, categories, topics, imagePath, isArticle];
}

class DeletePostEvent extends PostCrudEvent {
  final String postId;

  const DeletePostEvent({required this.postId});

  @override
  List<Object?> get props => [postId];
}
