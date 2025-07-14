import 'package:get_it/get_it.dart';
import 'package:tatbeeqi/features/posts/data/datasources/post_local_data_source.dart';
import 'package:tatbeeqi/features/posts/data/datasources/post_remote_data_source.dart';
import 'package:tatbeeqi/features/posts/data/repositories/post_repository_impl.dart';
import 'package:tatbeeqi/features/posts/domain/repositories/post_repository.dart';
import 'package:tatbeeqi/features/posts/domain/use_cases/add_comment_use_case.dart';
import 'package:tatbeeqi/features/posts/domain/use_cases/create_post_use_case.dart';
import 'package:tatbeeqi/features/posts/domain/use_cases/delete_post_use_case.dart';
import 'package:tatbeeqi/features/posts/domain/use_cases/get_comments_use_case.dart';
import 'package:tatbeeqi/features/posts/domain/use_cases/get_post_by_id_use_case.dart';
import 'package:tatbeeqi/features/posts/domain/use_cases/get_posts_by_categories_use_case.dart';
import 'package:tatbeeqi/features/posts/domain/use_cases/get_posts_use_case.dart';
import 'package:tatbeeqi/features/posts/domain/use_cases/like_post_use_case.dart';
import 'package:tatbeeqi/features/posts/domain/use_cases/remove_comment_use_case.dart';
import 'package:tatbeeqi/features/posts/domain/use_cases/sync_latest_posts_use_case.dart';
import 'package:tatbeeqi/features/posts/domain/use_cases/unlike_post_use_case.dart';
import 'package:tatbeeqi/features/posts/domain/use_cases/update_comment_use_case.dart';
import 'package:tatbeeqi/features/posts/domain/use_cases/update_post_use_case.dart';
import 'package:tatbeeqi/features/posts/presentation/bloc/comments/comments_bloc.dart';
import 'package:tatbeeqi/features/posts/presentation/bloc/create_post/create_post_bloc.dart';
import 'package:tatbeeqi/features/posts/presentation/bloc/post_feed/post_feed_bloc.dart';

void initPostsDependencies(GetIt sl) {
  // Use Cases
  sl.registerLazySingleton(() => CreatePostUseCase(sl()));
  sl.registerLazySingleton(() => UpdatePostUseCase(sl()));
  sl.registerLazySingleton(() => DeletePostUseCase(sl()));
  sl.registerLazySingleton(() => GetPostsUseCase(sl()));
  sl.registerLazySingleton(() => GetPostByIdUseCase(sl()));
  sl.registerLazySingleton(() => GetPostsByCategoriesUseCase(sl()));
  sl.registerLazySingleton(() => LikePostUseCase(sl()));
  sl.registerLazySingleton(() => UnlikePostUseCase(sl()));
  sl.registerLazySingleton(() => AddCommentUseCase(sl()));
  sl.registerLazySingleton(() => GetCommentsUseCase(sl()));
  sl.registerLazySingleton(() => SyncLatestPostsUseCase(sl()));
  sl.registerLazySingleton(() => RemoveCommentUseCase(sl()));
  sl.registerLazySingleton(() => UpdateCommentUseCase(sl()));
  // BLoCs
  sl.registerFactory(
    () => PostsBloc(
      getPostsUseCase: sl(),
      likePostUseCase: sl(),
      unlikePostUseCase: sl(),
    ),
  );
  sl.registerFactory(() => CreatePostBloc(sl()));
  sl.registerFactory(() => CommentsBloc(sl(), sl(), sl()));

  // Repository
  sl.registerLazySingleton<PostRepository>(
    () => PostRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  // Data Sources
  sl.registerLazySingleton<PostRemoteDataSource>(
    () => PostRemoteDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<PostLocalDataSource>(
    () => PostLocalDataSourceImpl(sl()),
  );
}
