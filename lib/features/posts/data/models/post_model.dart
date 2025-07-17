import 'dart:convert';

import 'package:tatbeeqi/features/posts/domain/entities/post.dart';

class PostModel extends Post {
  const PostModel({
    required super.id,
    required super.authorId,
    required super.authorName,
    required super.topics,
    super.authorAvatarUrl,
    required super.text,
    super.imageUrl,
    required super.categories,
    required super.createdAt,
    super.likesCount,
    super.commentsCount,
    super.isArticle,
    super.isLiked,
  });

  factory PostModel.fromMap(Map<String, dynamic> map) {
    return PostModel(
      id: map['id'] as String,
      authorId: map['author_id'] as String,
      authorName: map['author_name'] as String,
      authorAvatarUrl: map['author_avatar_url'] as String?,
      text: map['text'] as String,
      imageUrl: map['image_url'] as String?,
      categories: List<String>.from(map['categories'] ?? []),
      topics: List<String>.from(map['topics'] ?? ["all"]),
      createdAt: DateTime.parse(map['created_at'] as String),
      likesCount: map['likes_count'] as int? ?? 0,
      commentsCount: map['comments_count'] as int? ?? 0,
      isArticle: map['is_article'] as bool? ?? false,
      isLiked: map['is_liked'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'author_id': authorId,
      'text': text,
      'image_url': imageUrl,
      'categories': categories,
      'topics': topics,
      'is_article': isArticle,
    };
  }

  factory PostModel.fromDbMap(Map<String, dynamic> map) {
    return PostModel(
      id: map['id'] as String,
      authorId: map['author_id'] as String,
      authorName: map['author_name'] as String,
      authorAvatarUrl: map['author_avatar_url'] as String?,
      text: map['text'] as String,
      imageUrl: map['image_url'] as String?,
      categories: List<String>.from(jsonDecode(map['categories'] as String)),
      topics: List<String>.from(map['topics'] ?? ["all"]),
      createdAt: DateTime.parse(map['created_at'] as String),
      likesCount: map['likes_count'] as int? ?? 0,
      commentsCount: map['comments_count'] as int? ?? 0,
      isArticle: map['is_article'] as bool? ?? false,
      isLiked: map['is_liked'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toDbMap() {
    return {
      'id': id,
      'author_id': authorId,
      'author_avatar_url': authorAvatarUrl,
      'text': text,
      'image_url': imageUrl,
      'categories': jsonEncode(categories),
      'topics': topics,
      'is_article': isArticle,
    };
  }

  @override
  PostModel copyWith({
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
    return PostModel(
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

  factory PostModel.fromEntity(Post post) {
    return PostModel(
      id: post.id,
      authorId: post.authorId,
      authorName: post.authorName,
      authorAvatarUrl: post.authorAvatarUrl,
      text: post.text,
      imageUrl: post.imageUrl,
      categories: post.categories,
      topics: post.topics,
      createdAt: post.createdAt,
      likesCount: post.likesCount,
      commentsCount: post.commentsCount,
      isArticle: post.isArticle,
      isLiked: post.isLiked,
    );
  }

  Post toEntity() {
    return Post(
      id: id,
      authorId: authorId,
      authorName: authorName,
      authorAvatarUrl: authorAvatarUrl,
      text: text,
      imageUrl: imageUrl,
      categories: categories,
      topics: topics,
      createdAt: createdAt,
      likesCount: likesCount,
      commentsCount: commentsCount,
      isArticle: isArticle,
      isLiked: isLiked,
    );
  }
}
