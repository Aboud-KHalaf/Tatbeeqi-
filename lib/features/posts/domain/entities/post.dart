import 'package:equatable/equatable.dart';

class Post extends Equatable {
  final String id;
  final String authorId;
  final String authorName;
  final String? authorAvatarUrl;
  final String text;
  final String? imageUrl;
  final List<String> categories;
  final List<String> topics;
  final DateTime createdAt;
  final int likesCount;
  final int commentsCount;
  final bool isArticle;

  const Post({
    required this.id,
    required this.authorId,
    required this.authorName,
    this.authorAvatarUrl,
    required this.text,
    this.imageUrl,
    required this.categories,
    required this.topics,
    required this.createdAt,
    this.likesCount = 0,
    this.commentsCount = 0,
    this.isArticle = false,
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
        topics,
        createdAt,
        likesCount,
        commentsCount,
        isArticle,
      ];
}
