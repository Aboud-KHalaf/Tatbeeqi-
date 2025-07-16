import 'package:dartz/dartz.dart';
import 'package:tatbeeqi/core/error/exceptions.dart';
import 'package:tatbeeqi/core/error/failures.dart';
import 'package:tatbeeqi/core/network/network_info.dart';
import 'package:tatbeeqi/features/posts/data/datasources/post_local_data_source.dart';
import 'package:tatbeeqi/features/posts/data/datasources/post_remote_data_source.dart';
import 'package:tatbeeqi/features/posts/data/models/comment_model.dart';
import 'package:tatbeeqi/features/posts/data/models/post_model.dart';
import 'package:tatbeeqi/features/posts/domain/entities/comment.dart';
import 'package:tatbeeqi/features/posts/domain/entities/comment_reply.dart';
import 'package:tatbeeqi/features/posts/domain/entities/post.dart';
import 'package:tatbeeqi/features/posts/domain/repositories/post_repository.dart';

class PostRepositoryImpl implements PostRepository {
  final PostRemoteDataSource remoteDataSource;
  final PostLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  PostRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, Post>> createPost(Post post) async {
    if (await networkInfo.isConnected()) {
      try {
        final newPost = await remoteDataSource.createPost(post as PostModel);
        await syncLatestPosts(); // Refresh cache
        return Right(newPost);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return const Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, Post>> updatePost(Post post) async {
    if (await networkInfo.isConnected()) {
      try {
        final updatedPost =
            await remoteDataSource.updatePost(post as PostModel);
        await syncLatestPosts(); // Refresh cache
        return Right(updatedPost);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return const Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, void>> deletePost(String postId) async {
    if (await networkInfo.isConnected()) {
      try {
        await remoteDataSource.deletePost(postId);
        await syncLatestPosts();
        return const Right(null);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return const Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, List<Post>>> getPosts(
      {int start = 0, int limit = 10}) async {
    if (await networkInfo.isConnected()) {
      try {
        final remotePosts =
            await remoteDataSource.fetchPosts(start: start, limit: limit);
        print(remotePosts.length);
        // await localDataSource.cachePosts(remotePosts);
        return Right(remotePosts);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      try {
        final localPosts = await localDataSource.getCachedPosts();
        return Right(localPosts);
      } on CacheException catch (e) {
        return Left(CacheFailure(e.message));
      }
    }
  }

  @override
  Future<Either<Failure, Post>> getPostById(String postId) async {
    if (await networkInfo.isConnected()) {
      try {
        final remotePost = await remoteDataSource.fetchPostById(postId);
        return Right(remotePost);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return const Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, List<Post>>> getPostsByCategories(
    List<String> categories, {
    int start = 0,
    int limit = 10,
  }) async {
    if (await networkInfo.isConnected()) {
      try {
        final remotePosts = await remoteDataSource.fetchPostsByCategories(
          categories,
          start: start,
          limit: limit,
        );
        return Right(remotePosts);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      try {
        final localPosts =
            await localDataSource.getCachedPostsByCategories(categories);
        return Right(localPosts);
      } on CacheException catch (e) {
        return Left(CacheFailure(e.message));
      }
    }
  }

  @override
  Future<Either<Failure, void>> likePost(String postId) async {
    if (await networkInfo.isConnected()) {
      try {
        await remoteDataSource.likePost(postId);
        return const Left(
            ServerFailure('Authentication error: User ID not available.'));
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return const Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, void>> unlikePost(String postId) async {
    if (await networkInfo.isConnected()) {
      try {
        await remoteDataSource.unlikePost(postId);
        return const Left(
            ServerFailure('Authentication error: User ID not available.'));
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return const Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, Comment>> addComment(Comment comment) async {
    if (await networkInfo.isConnected()) {
      try {
        final newComment =
            await remoteDataSource.addComment(CommentModel.fromEntity(comment));
        return Right(newComment);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return const Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, List<Comment>>> getComments(String postId) async {
    if (await networkInfo.isConnected()) {
      try {
        final comments = await remoteDataSource.fetchComments(postId);
        return Right(comments);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return const Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, List<Post>>> syncLatestPosts() async {
    if (await networkInfo.isConnected()) {
      try {
        final remotePosts = await remoteDataSource.fetchPosts(limit: 10);
        await localDataSource.cachePosts(remotePosts);
        return Right(remotePosts);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return const Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, void>> removeComment(String commentId) async {
    if (await networkInfo.isConnected()) {
      try {
        await remoteDataSource.removeComment(commentId);
        return const Right(null);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return const Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, void>> updateComment(Comment comment) async {
    if (await networkInfo.isConnected()) {
      try {
        await remoteDataSource.updateComment(comment as CommentModel);
        return const Right(null);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return const Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, List<CommentReply>>> getRepliesForComment(
      String commentId) async {
    if (await networkInfo.isConnected()) {
      try {
        final remoteReplies =
            await remoteDataSource.getRepliesForComment(commentId);
        return Right(remoteReplies);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return const Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> replyOnComment(
      String commentId, String text) async {
    return await _getMessage(() {
      return remoteDataSource.replyOnComment(commentId, text);
    });
  }

  @override
  Future<Either<Failure, Unit>> updateReplyOnComment(
      String replyId, String newText) async {
    return await _getMessage(() {
      return remoteDataSource.updateReplyOnComment(replyId, newText);
    });
  }

  @override
  Future<Either<Failure, Unit>> deleteReplyOnComment(String replyId) async {
    return await _getMessage(() {
      return remoteDataSource.deleteReplyOnComment(replyId);
    });
  }

  Future<Either<Failure, Unit>> _getMessage(
      Future<void> Function() remoteFunction) async {
    if (await networkInfo.isConnected()) {
      try {
        await remoteFunction();
        return const Right(unit);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return const Left(NetworkFailure());
    }
  }
}
