import 'package:tatbeeqi/features/posts/data/models/post_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:tatbeeqi/core/error/exceptions.dart';
import 'package:tatbeeqi/core/services/database/database_service.dart';


abstract class PostLocalDataSource {
  Future<void> cachePosts(List<PostModel> posts); // keep ≤10 newest
  Future<List<PostModel>> getCachedPosts(); // all cached
  Future<List<PostModel>> getCachedPostsByCategories(
    List<String> categories,
  ); // filter locally
}

class PostLocalDataSourceImpl implements PostLocalDataSource {
  final DatabaseService dbService;

  PostLocalDataSourceImpl(this.dbService);

  @override
  Future<void> cachePosts(List<PostModel> posts) async {
    try {
      final db = await dbService.database;
      await db.transaction((txn) async {
        // Clear existing cache
        await txn.delete(cachedPostsTableName);

        // Insert new posts
        final batch = txn.batch();
        for (final post in posts) {
          batch.insert(cachedPostsTableName, post.toDbMap(),
              conflictAlgorithm: ConflictAlgorithm.replace);
        }
        await batch.commit(noResult: true);
      });
    } catch (e) {
      throw CacheException('Failed to cache posts.');
    }
  }

  @override
  Future<List<PostModel>> getCachedPosts() async {
    try {
      final db = await dbService.database;
      final maps = await db.query(
        cachedPostsTableName,
        orderBy: '$cachedPostsColCreatedAt DESC',
      );
      return maps.map((map) => PostModel.fromDbMap(map)).toList();
    } catch (e) {
      throw CacheException('Failed to get cached posts.');
    }
  }

  @override
  Future<List<PostModel>> getCachedPostsByCategories(
      List<String> categories) async {
    try {
      final db = await dbService.database;
      // Build the WHERE clause to find posts containing any of the categories
      final whereClause = categories
          .map((category) => "$cachedPostsColCategories LIKE '%$category%'")
          .join(' OR ');

      final maps = await db.query(
        cachedPostsTableName,
        where: whereClause,
        orderBy: '$cachedPostsColCreatedAt DESC',
      );
      return maps.map((map) => PostModel.fromDbMap(map)).toList();
    } catch (e) {
      throw CacheException('Failed to get cached posts by categories.');
    }
  }
}
