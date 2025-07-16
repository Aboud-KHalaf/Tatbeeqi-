import 'package:tatbeeqi/features/posts/domain/entities/comment.dart';

class CommentModel extends Comment {
  const CommentModel({
    required super.id,
    required super.postId,
    required super.authorId,
    required super.text,
    required super.createdAt,
    required super.authorName,
  });

  factory CommentModel.fromMap(Map<String, dynamic> map) {
    return CommentModel(
      id: map['id'] as String,
      postId: map['post_id'] as String,
      authorId: map['author_id'] as String,
      text: map['text'] as String,
      createdAt: DateTime.parse(map['created_at'] as String),
      authorName: map['author_name'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'post_id': postId,
      'author_id': authorId,
      'text': text,
    };
  }

  factory CommentModel.fromEntity(Comment comment) {
    return CommentModel(
      id: comment.id,
      postId: comment.postId,
      authorId: comment.authorId,
      text: comment.text,
      createdAt: comment.createdAt,
      authorName: comment.authorName,
    );
  }

  copyWith({
    String? id,
    String? postId,
    String? authorId,
    String? text,
    DateTime? createdAt,
    String? authorName,
  }) {
    return CommentModel(
      id: id ?? this.id,
      postId: postId ?? this.postId,
      authorId: authorId ?? this.authorId,
      text: text ?? this.text,
      createdAt: createdAt ?? this.createdAt,
      authorName: authorName ?? this.authorName,
    );
  }

  Comment toEntity() {
    return Comment(
      id: id,
      postId: postId,
      authorId: authorId,
      text: text,
      createdAt: createdAt,
      authorName: authorName,
      authorAvatarUrl: authorAvatarUrl,
    );
  }
}
