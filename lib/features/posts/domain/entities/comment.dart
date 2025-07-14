import 'package:equatable/equatable.dart';

class Comment extends Equatable {
  final String id;
  final String postId;
  final String authorName;
  final String authorId;
  final String? authorAvatarUrl;
  final String text;
  final DateTime createdAt;

  const Comment({
    required this.id,
    required this.postId,
    required this.authorName,
    required this.authorId,
    this.authorAvatarUrl,
    required this.text,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id, postId, authorId, authorAvatarUrl, text, createdAt];
}
