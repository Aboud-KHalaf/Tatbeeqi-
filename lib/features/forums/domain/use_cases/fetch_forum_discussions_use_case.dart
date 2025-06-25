import 'package:tatbeeqi/features/forums/domain/entities/forum_discussion.dart';
import 'package:tatbeeqi/features/forums/domain/repositories/forums_repository.dart';

class FetchForumDiscussionsUseCase {
  final ForumsRepository repository;

  FetchForumDiscussionsUseCase(this.repository);

  Future<List<ForumDiscussion>> call(String courseId) {
    return repository.fetchForumDiscussions(courseId);
  }
}
