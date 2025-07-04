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
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'author_id': authorId,
      'author_name': authorName,
      'author_avatar_url': authorAvatarUrl,
      'text': text,
      'image_url': imageUrl,
      'categories': categories,
      'topics': topics,
      'created_at': createdAt.toIso8601String(),
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
    );
  }

  Map<String, dynamic> toDbMap() {
    return {
      'id': id,
      'author_id': authorId,
      'author_name': authorName,
      'author_avatar_url': authorAvatarUrl,
      'text': text,
      'image_url': imageUrl,
      'categories': jsonEncode(categories),
      'topics': topics,
      'created_at': createdAt.toIso8601String(),
    };
  }

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
    );
  }
}
