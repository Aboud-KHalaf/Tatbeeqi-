import 'package:dartz/dartz.dart';
import 'package:tatbeeqi/core/error/exceptions.dart';
import 'package:tatbeeqi/core/error/failures.dart'; // Assuming you have this
import 'package:tatbeeqi/features/news/data/models/news_item_model.dart';
import 'package:tatbeeqi/features/news/domain/entities/news_item_entity.dart';
import 'package:tatbeeqi/features/news/data/datasources/news_local_data_source.dart';
import 'package:tatbeeqi/features/news/data/datasources/news_remote_data_source.dart';
 import 'package:tatbeeqi/features/news/domain/repositories/news_repository.dart';

class NewsRepositoryImpl implements NewsRepository {
  final NewsRemoteDataSource remoteDataSource; 
  final NewsLocalDataSource localDataSource;
  // final NetworkInfo networkInfo; 

  NewsRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    // required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<NewsItemEntity>>> getNewsItems() async {
    try {
      final remoteNews = await remoteDataSource.getNewsItems();
      await localDataSource.cacheNews(remoteNews.map((e) =>NewsItemModel.fromEntity(e)).toList());
      return Right(remoteNews);
    } on ServerException {
      try {
        final localNews = await localDataSource.getCachedNews();
        if (localNews.isNotEmpty) {
          return Right(localNews);
        } else {
          return Left(ServerFailure('No cached data found.'));
        }
      } on CacheException catch (e) {
        return Left(CacheFailure(e.message));
      }
    } catch (e) {
      return Left(ServerFailure('An unexpected error occurred: ${e.toString()}'));
    }
    // } else {
    //   return Left(NetworkFailure()); // Define NetworkFailure if needed
    // }
  }
}
