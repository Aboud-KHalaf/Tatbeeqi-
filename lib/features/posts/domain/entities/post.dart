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
  final bool isLiked;
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
    this.isLiked = false,
  });

  Post copyWith({
    String? id,
    String? authorId,
    String? authorName,
    String? authorAvatarUrl,
    String? text,
    String? imageUrl,
    List<String>? categories,
    List<String>? topics,
    DateTime? createdAt,
    int? likesCount,
    int? commentsCount,
    bool? isArticle,
    bool? isLiked,
  }) {
    return Post(
      id: id ?? this.id,
      authorId: authorId ?? this.authorId,
      authorName: authorName ?? this.authorName,
      authorAvatarUrl: authorAvatarUrl ?? this.authorAvatarUrl,
      text: text ?? this.text,
      imageUrl: imageUrl ?? this.imageUrl,
      categories: categories ?? this.categories,
      topics: topics ?? this.topics,
      createdAt: createdAt ?? this.createdAt,
      likesCount: likesCount ?? this.likesCount,
      commentsCount: commentsCount ?? this.commentsCount,
      isArticle: isArticle ?? this.isArticle,
      isLiked: isLiked ?? this.isLiked,
    );
  }

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
        isLiked,
      ];
}
