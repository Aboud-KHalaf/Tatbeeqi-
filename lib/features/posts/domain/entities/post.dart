import 'package:equatable/equatable.dart';

class Post extends Equatable {
  final String id;
  final String authorId;
  final String authorName;
  final String? authorAvatarUrl;
  final String text;
  final String? imageUrl;
  final List<String> categories;
  final DateTime createdAt;

  const Post({
    required this.id,
    required this.authorId,
    required this.authorName,
    this.authorAvatarUrl,
    required this.text,
    this.imageUrl,
    required this.categories,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
        id,
        authorId,
        authorName,
        authorAvatarUrl,
        text,
        imageUrl,
        categories,
        createdAt,
      ];
}
