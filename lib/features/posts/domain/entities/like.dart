import 'package:equatable/equatable.dart';

class Like extends Equatable {
  final String id;
  final String postId;
  final String userId;
  final DateTime createdAt;

  const Like({
    required this.id,
    required this.postId,
    required this.userId,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id, postId, userId, createdAt];
}
