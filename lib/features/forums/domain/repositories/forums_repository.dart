import 'package:dartz/dartz.dart';
import 'package:tatbeeqi/features/forums/domain/entities/forum_discussion.dart';
import 'package:tatbeeqi/core/error/failures.dart';

abstract class ForumsRepository {
  Future<Either<Failure, List<ForumDiscussion>>> fetchForumDiscussions(String courseId);
}