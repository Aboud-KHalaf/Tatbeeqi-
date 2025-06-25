import 'package:equatable/equatable.dart';

class ForumDiscussion extends Equatable {
  final String id;
  final String courseId;
  final String title;
  final String author;
  final int replies;
  final DateTime lastUpdate;

  const ForumDiscussion({
    required this.id,
    required this.courseId,
    required this.title,
    required this.author,
    required this.replies,
    required this.lastUpdate,
  });

  @override
  List<Object?> get props => [id, courseId, title, author, replies, lastUpdate];
}
