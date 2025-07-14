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
  Future<List<PostModel>> fetchPosts({int start = 0, int limit = 10});
  Future<PostModel> fetchPostById(String postId);
  Future<List<PostModel>> fetchPostsByCategories(
    List<String> categories, {
    int start = 0,
    int limit = 10,
  });

  // Likes & Comments
  Future<void> likePost(String postId);
  Future<void> unlikePost(String postId);
  Future<CommentModel> addComment(CommentModel comment);
  Future<List<CommentModel>> fetchComments(String postId);
  Future<void> removeComment(String commentId);
  Future<void> updateComment(CommentModel comment);
}

class PostRemoteDataSourceImpl implements PostRemoteDataSource {
  final SupabaseClient supabase;

  PostRemoteDataSourceImpl(this.supabase);

  @override
  Future<PostModel> createPost(PostModel post) async {
    try {
      final response =
          await supabase.from('posts').insert(post.toMap()).select().single();
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
  Future<List<PostModel>> fetchPosts({int start = 0, int limit = 10}) async {
    try {
      final response = await supabase
          .from('posts')
          .select('*, likes(count), comments(count)')
          .order('created_at', ascending: false)
          .range(start, start + limit);

      return (response as List).map((e) {
        // Extract likes count
        final likesCount = (e['likes'] is List && e['likes'].isNotEmpty)
            ? e['likes'][0]['count'] as int
            : 0;
        // Extract comments count
        final commentsCount =
            (e['comments'] is List && e['comments'].isNotEmpty)
                ? e['comments'][0]['count'] as int
                : 0;
        // Compose map for PostModel
        final postMap = Map<String, dynamic>.from(e)
          ..['likes_count'] = likesCount
          ..['comments_count'] = commentsCount;
        return PostModel.fromMap(postMap);
      }).toList();
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
    int start = 0,
  }) async {
    try {
      final response = await supabase
          .from('posts')
          .select('*, likes(count), comments(count)')
          .contains('categories', categories)
          .order('created_at', ascending: false)
          .range(start, start + limit);
      return (response as List).map((e) {
        // Extract likes count
        final likesCount = (e['likes'] is List && e['likes'].isNotEmpty)
            ? e['likes'][0]['count'] as int
            : 0;
        // Extract comments count
        final commentsCount =
            (e['comments'] is List && e['comments'].isNotEmpty)
                ? e['comments'][0]['count'] as int
                : 0;
        // Compose map for PostModel
        final postMap = Map<String, dynamic>.from(e)
          ..['likes_count'] = likesCount
          ..['comments_count'] = commentsCount;
        return PostModel.fromMap(postMap);
      }).toList();
    } catch (e) {
      if (e is PostgrestException) {
        throw ServerException(e.message);
      }
      throw ServerException('An unexpected error occurred');
    }
  }

  @override
  Future<void> likePost(String postId) async {
    try {
      final userId = supabase.auth.currentUser?.id;
      if (userId == null) {
        throw ServerException('User ID not available');
      }
      await supabase
          .from('likes')
          .insert({'post_id': postId, 'user_id': userId});
    } catch (e) {
      if (e is PostgrestException) {
        throw ServerException(e.message);
      }
      throw ServerException('An unexpected error occurred');
    }
  }

  @override
  Future<void> unlikePost(String postId) async {
    try {
      final userId = supabase.auth.currentUser?.id;
      if (userId == null) {
        throw ServerException('User ID not available');
      }
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

  @override
  Future<void> removeComment(String commentId) async {
    try {
      final userId = supabase.auth.currentUser?.id;
      if (userId == null) {
        throw ServerException('User ID not available');
      }
      await supabase.from('comments').delete().eq('id', commentId);
    } catch (e) {
      if (e is PostgrestException) {
        throw ServerException(e.message);
      }
      throw ServerException('An unexpected error occurred');
    }
  }

  @override
  Future<void> updateComment(CommentModel comment) async {
    try {
      await supabase
          .from('comments')
          .update(comment.toMap())
          .eq('id', comment.id);
    } catch (e) {
      if (e is PostgrestException) {
        throw ServerException(e.message);
      }
      throw ServerException('An unexpected error occurred');
    }
  }
}
