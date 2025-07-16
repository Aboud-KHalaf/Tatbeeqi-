import 'package:equatable/equatable.dart';

class CommentReply extends Equatable {
  final String id;
  final String commentId;
  final String authorId;
  final String authorName;
  final String text;
  final DateTime createdAt;

  const CommentReply({
    required this.id,
    required this.commentId,
    required this.authorId,
    required this.authorName,
    required this.text,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id, commentId, authorId, authorName, text, createdAt];
}
