import 'package:dartz/dartz.dart';
import 'package:tatbeeqi/core/error/exceptions.dart';
import 'package:tatbeeqi/core/error/failures.dart';
import 'package:tatbeeqi/core/network/network_info.dart';
import 'package:tatbeeqi/features/posts/data/datasources/post_local_data_source.dart';
import 'package:tatbeeqi/features/posts/data/datasources/post_remote_data_source.dart';
import 'package:tatbeeqi/features/posts/data/models/comment_model.dart';
import 'package:tatbeeqi/features/posts/data/models/post_model.dart';
import 'package:tatbeeqi/features/posts/domain/entities/comment.dart';
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
      return Left(NetworkFailure());
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
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, void>> deletePost(String postId) async {
    if (await networkInfo.isConnected()) {
      try {
        await remoteDataSource.deletePost(postId);
        await syncLatestPosts(); // Refresh cache
        return const Right(null);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, List<Post>>> getPosts({int limit = 10}) async {
    if (await networkInfo.isConnected()) {
      try {
        final remotePosts = await remoteDataSource.fetchPosts(limit: limit);
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
      // Cannot get a single post from cache if offline, as it may not be there.
      // This could be extended to search the cache, but for now, we require network.
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, List<Post>>> getPostsByCategories(
    List<String> categories, {
    int limit = 10,
  }) async {
    if (await networkInfo.isConnected()) {
      try {
        final remotePosts = await remoteDataSource.fetchPostsByCategories(
          categories,
          limit: limit,
        );
        // We don't cache category-specific results to avoid complex cache management
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
  @override
  Future<Either<Failure, void>> likePost(String postId) async {
    // This requires the user's ID, which should be passed from the presentation layer.
    // For now, we'll simulate a failure until auth is integrated.
    if (await networkInfo.isConnected()) {
      try {
        // final userId = ... get from an auth service
        // await remoteDataSource.likePost(postId, userId);
        return Left(
            ServerFailure('Authentication error: User ID not available.'));
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  @override
  Future<Either<Failure, void>> unlikePost(String postId) async {
    if (await networkInfo.isConnected()) {
      try {
        // final userId = ... get from an auth service
        // await remoteDataSource.unlikePost(postId, userId);
        return Left(
            ServerFailure('Authentication error: User ID not available.'));
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, Comment>> addComment(Comment comment) async {
    if (await networkInfo.isConnected()) {
      try {
        final newComment =
            await remoteDataSource.addComment(comment as CommentModel);
        return Right(newComment);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return Left(NetworkFailure());
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
      return Left(NetworkFailure());
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
      return Left(NetworkFailure());
    }
  }
}
