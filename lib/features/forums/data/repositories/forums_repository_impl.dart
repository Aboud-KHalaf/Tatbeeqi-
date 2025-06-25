import 'package:tatbeeqi/features/forums/data/datasources/mock_forums_datasource.dart';
import 'package:tatbeeqi/features/forums/domain/entities/forum_discussion.dart';
import 'package:tatbeeqi/features/forums/domain/repositories/forums_repository.dart';

class ForumsRepositoryImpl implements ForumsRepository {
  final MockForumsDataSource dataSource;

  ForumsRepositoryImpl(this.dataSource);

  @override
  Future<List<ForumDiscussion>> fetchForumDiscussions(String courseId) async {
    return dataSource.discussions
        .where((discussion) => discussion.courseId == courseId)
        .toList();
  }
}
