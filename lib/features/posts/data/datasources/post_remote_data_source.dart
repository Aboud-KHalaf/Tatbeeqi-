import 'package:tatbeeqi/features/posts/data/models/comment_model.dart';
import 'package:tatbeeqi/features/posts/data/models/post_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tatbeeqi/core/error/exceptions.dart';
abstract class PostRemoteDataSource {
  // CRUD
  Future<PostModel> createPost(PostModel post);
  Future<PostModel> updatePost(PostModel post);
  Future<void> deletePost(String postId);

  // Reads
  Future<List<PostModel>> fetchPosts({int limit});
  Future<PostModel> fetchPostById(String postId);
  Future<List<PostModel>> fetchPostsByCategories(
    List<String> categories, {
    int limit,
  });

  // Likes & Comments
  Future<void> likePost(String postId, String userId);
  Future<void> unlikePost(String postId, String userId);
  Future<CommentModel> addComment(CommentModel comment);
  Future<List<CommentModel>> fetchComments(String postId);
}


class PostRemoteDataSourceImpl implements PostRemoteDataSource {
  final SupabaseClient supabase;

  PostRemoteDataSourceImpl(this.supabase);

  @override
  Future<PostModel> createPost(PostModel post) async {
    try {
      final response = await supabase
          .from('posts')
          .insert(post.toMap())
          .select()
          .single();
      return PostModel.fromMap(response);
    } catch (e) {
      if (e is PostgrestException) {
        throw ServerException(e.message);
      }
      throw ServerException('An unexpected error occurred');
    }
  }

  @override
  Future<PostModel> updatePost(PostModel post) async {
    try {
      final response = await supabase
          .from('posts')
          .update(post.toMap())
          .eq('id', post.id)
          .select()
          .single();
      return PostModel.fromMap(response);
    } catch (e) {
      if (e is PostgrestException) {
        throw ServerException(e.message);
      }
      throw ServerException('An unexpected error occurred');
    }
  }

  @override
  Future<void> deletePost(String postId) async {
    try {
      await supabase.from('posts').delete().eq('id', postId);
    } catch (e) {
      if (e is PostgrestException) {
        throw ServerException(e.message);
      }
      throw ServerException('An unexpected error occurred');
    }
  }

  @override
  Future<List<PostModel>> fetchPosts({int limit = 10}) async {
    try {
      final response = await supabase
          .from('posts')
          .select()
          .order('created_at', ascending: false)
          .limit(limit);
      return response.map((e) => PostModel.fromMap(e)).toList();
    } catch (e) {
      if (e is PostgrestException) {
        throw ServerException(e.message);
      }
      throw ServerException('An unexpected error occurred');
    }
  }

  @override
  Future<PostModel> fetchPostById(String postId) async {
    try {
      final response =
          await supabase.from('posts').select().eq('id', postId).single();
      return PostModel.fromMap(response);
    } catch (e) {
      if (e is PostgrestException) {
        throw ServerException(e.message);
      }
      throw ServerException('An unexpected error occurred');
    }
  }

  @override
  Future<List<PostModel>> fetchPostsByCategories(
    List<String> categories, {
    int limit = 10,
  }) async {
    try {
      final response = await supabase
          .from('posts')
          .select()
          .contains('categories', categories)
          .order('created_at', ascending: false)
          .limit(limit);
      return response.map((e) => PostModel.fromMap(e)).toList();
    } catch (e) {
      if (e is PostgrestException) {
        throw ServerException(e.message);
      }
      throw ServerException('An unexpected error occurred');
    }
  }

  @override
  Future<void> likePost(String postId, String userId) async {
    try {
      await supabase.from('likes').insert({'post_id': postId, 'user_id': userId});
    } catch (e) {
      if (e is PostgrestException) {
        throw ServerException(e.message);
      }
      throw ServerException('An unexpected error occurred');
    }
  }

  @override
  Future<void> unlikePost(String postId, String userId) async {
    try {
      await supabase
          .from('likes')
          .delete()
          .eq('post_id', postId)
          .eq('user_id', userId);
    } catch (e) {
      if (e is PostgrestException) {
        throw ServerException(e.message);
      }
      throw ServerException('An unexpected error occurred');
    }
  }

  @override
  Future<CommentModel> addComment(CommentModel comment) async {
    try {
      final response = await supabase
          .from('comments')
          .insert(comment.toMap())
          .select()
          .single();
      return CommentModel.fromMap(response);
    } catch (e) {
      if (e is PostgrestException) {
        throw ServerException(e.message);
      }
      throw ServerException('An unexpected error occurred');
    }
  }

  @override
  Future<List<CommentModel>> fetchComments(String postId) async {
    try {
      final response = await supabase
          .from('comments')
          .select()
          .eq('post_id', postId)
          .order('created_at', ascending: true);
      return response.map((e) => CommentModel.fromMap(e)).toList();
    } catch (e) {
      if (e is PostgrestException) {
        throw ServerException(e.message);
      }
      throw ServerException('An unexpected error occurred');
    }
  }
}
