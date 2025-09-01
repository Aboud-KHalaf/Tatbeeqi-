import 'package:sqflite/sqflite.dart';
import 'package:tatbeeqi/core/error/exceptions.dart';
import 'package:tatbeeqi/core/services/database/database_service.dart';
import 'package:tatbeeqi/features/news/data/models/news_item_model.dart';

abstract class NewsLocalDataSource {
  Future<void> cacheNews(List<NewsItemModel> news);
  Future<List<NewsItemModel>> getCachedNews();
}

class NewsLocalDataSourceImpl implements NewsLocalDataSource {
  final DatabaseService dbService;

  NewsLocalDataSourceImpl(this.dbService);

  @override
  Future<void> cacheNews(List<NewsItemModel> news) async {
    try {
      final db = await dbService.database;
      await db.transaction((txn) async {
        await txn.delete(cachedNewsTableName);
        
        final batch = txn.batch();
        for (final newsItem in news) {
          print(newsItem.title);
          batch.insert(cachedNewsTableName, newsItem.toDbMap(),
              conflictAlgorithm: ConflictAlgorithm.replace);
        }
        await batch.commit(noResult: true);
      });
    } catch (e) {
      throw CacheException('Failed to cache news.');
    }
  }

  @override
  Future<List<NewsItemModel>> getCachedNews() async {
    try {
      final db = await dbService.database;
      final maps = await db.query(
        cachedNewsTableName,
        orderBy: '$cachedNewsColPublicationDate DESC',
      );
      return maps.map((map) => NewsItemModel.fromDbMap(map)).toList();
    } catch (e) {
      throw CacheException('Failed to get cached news.');
    }
  }
}
