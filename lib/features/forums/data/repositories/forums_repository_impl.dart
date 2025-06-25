import 'package:dartz/dartz.dart';
import 'package:tatbeeqi/core/error/failures.dart';
import 'package:tatbeeqi/features/forums/data/datasources/mock_forums_datasource.dart';
import 'package:tatbeeqi/features/forums/domain/entities/forum_discussion.dart';
import 'package:tatbeeqi/features/forums/domain/repositories/forums_repository.dart';

class ForumsRepositoryImpl implements ForumsRepository {
  final MockForumsDataSource dataSource;

  ForumsRepositoryImpl(this.dataSource);

  @override
  Future<Either<Failure, List<ForumDiscussion>>> fetchForumDiscussions(String courseId) async {
   throw UnimplementedError();
  }
}
