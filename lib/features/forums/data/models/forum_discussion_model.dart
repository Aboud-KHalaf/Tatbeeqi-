import 'package:tatbeeqi/features/forums/domain/entities/forum_discussion.dart';

class ForumDiscussionModel extends ForumDiscussion {
  const ForumDiscussionModel({
    required super.id,
    required super.courseId,
    required super.title,
    required super.author,
    required super.replies,
    required super.lastUpdate,
  });

  factory ForumDiscussionModel.fromJson(Map<String, dynamic> json) {
    return ForumDiscussionModel(
      id: json['id'],
      courseId: json['courseId'],
      title: json['title'],
      author: json['author'],
      replies: json['replies'],
      lastUpdate: DateTime.parse(json['lastUpdate']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'courseId': courseId,
      'title': title,
      'author': author,
      'replies': replies,
      'lastUpdate': lastUpdate.toIso8601String(),
    };
  }
}
