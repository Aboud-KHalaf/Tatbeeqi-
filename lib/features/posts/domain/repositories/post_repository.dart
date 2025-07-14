import 'package:dartz/dartz.dart';
import 'package:tatbeeqi/core/error/failures.dart';
import 'package:tatbeeqi/features/posts/domain/entities/comment.dart';
import 'package:tatbeeqi/features/posts/domain/entities/post.dart';

abstract class PostRepository {
  // CRUD
  Future<Either<Failure, Post>> createPost(Post post);
  Future<Either<Failure, Post>> updatePost(Post post);
  Future<Either<Failure, void>> deletePost(String postId);

  // Reads
  Future<Either<Failure, List<Post>>> getPosts({int limit = 10});
  Future<Either<Failure, Post>> getPostById(String postId);
  Future<Either<Failure, List<Post>>> getPostsByCategories(
    List<String> categories, {
    int limit = 10,
  });

  // Likes & Comments
  Future<Either<Failure, void>> likePost(String postId);
  Future<Either<Failure, void>> unlikePost(String postId);
  Future<Either<Failure, Comment>> addComment(Comment comment);
  Future<Either<Failure, void>> removeComment(String commentId);
  Future<Either<Failure, void>> updateComment(Comment comment);
  Future<Either<Failure, List<Comment>>> getComments(String postId);

  // Sync (remote → local)
  Future<Either<Failure, List<Post>>> syncLatestPosts();
}
