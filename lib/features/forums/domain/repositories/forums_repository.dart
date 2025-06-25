import 'package:tatbeeqi/features/forums/domain/entities/forum_discussion.dart';

abstract class ForumsRepository {
  Future<List<ForumDiscussion>> fetchForumDiscussions(String courseId);
}
