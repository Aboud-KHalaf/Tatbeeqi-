import 'package:tatbeeqi/features/posts/domain/entities/comment_reply.dart';

class CommentReplyModel extends CommentReply {
  const CommentReplyModel({
    required super.id,
    required super.commentId,
    required super.authorId,
    required super.authorName,
    required super.text,
    required super.createdAt,
  });

  factory CommentReplyModel.fromJson(Map<String, dynamic> json) {
    return CommentReplyModel(
      id: json['id'],
      commentId: json['comment_id'],
      authorId: json['author_id'],
      authorName: json['author']?['name'] ?? 'Unknown',
      text: json['text'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'comment_id': commentId,
      'author_id': authorId,
      'text': text,
    };
  }
}
