import 'package:get_it/get_it.dart';
import 'package:tatbeeqi/features/posts/data/datasources/post_local_data_source.dart';
import 'package:tatbeeqi/features/posts/data/datasources/post_remote_data_source.dart';
import 'package:tatbeeqi/features/posts/data/repositories/post_repository_impl.dart';
import 'package:tatbeeqi/features/posts/domain/repositories/post_repository.dart';
import 'package:tatbeeqi/features/posts/domain/use_cases/add_comment_use_case.dart';
import 'package:tatbeeqi/features/posts/domain/use_cases/create_post_use_case.dart';
import 'package:tatbeeqi/features/posts/domain/use_cases/delete_post_use_case.dart';
import 'package:tatbeeqi/features/posts/domain/use_cases/delete_reply_on_comment.dart';
import 'package:tatbeeqi/features/posts/domain/use_cases/get_comments_use_case.dart';
import 'package:tatbeeqi/features/posts/domain/use_cases/get_post_by_id_use_case.dart';
import 'package:tatbeeqi/features/posts/domain/use_cases/get_posts_by_categories_use_case.dart';
import 'package:tatbeeqi/features/posts/domain/use_cases/get_posts_use_case.dart';
import 'package:tatbeeqi/features/posts/domain/use_cases/get_my_posts_use_case.dart';
import 'package:tatbeeqi/features/posts/domain/use_cases/get_replies_for_comment.dart';
import 'package:tatbeeqi/features/posts/domain/use_cases/like_post_use_case.dart';
import 'package:tatbeeqi/features/posts/domain/use_cases/remove_comment_use_case.dart';
import 'package:tatbeeqi/features/posts/domain/use_cases/reply_on_comment.dart';
import 'package:tatbeeqi/features/posts/domain/use_cases/sync_latest_posts_use_case.dart';
import 'package:tatbeeqi/features/posts/domain/use_cases/unlike_post_use_case.dart';
import 'package:tatbeeqi/features/posts/domain/use_cases/update_comment_use_case.dart';
import 'package:tatbeeqi/features/posts/domain/use_cases/update_post_use_case.dart';
import 'package:tatbeeqi/features/posts/domain/use_cases/update_reply_on_comment.dart';
import 'package:tatbeeqi/features/posts/domain/use_cases/upload_image_use_case.dart';
import 'package:tatbeeqi/features/posts/presentation/manager/comments/comments_bloc.dart';
import 'package:tatbeeqi/features/posts/presentation/manager/create_post/create_post_bloc.dart';
import 'package:tatbeeqi/features/posts/presentation/manager/post_feed/post_feed_bloc.dart';
import 'package:tatbeeqi/features/posts/presentation/manager/comment_replies/comment_replies_bloc.dart';
import 'package:tatbeeqi/features/posts/presentation/manager/my_posts/my_posts_cubit.dart';

void initPostsDependencies(GetIt sl) {
  // Use cases
  sl.registerLazySingleton(() => CreatePostUseCase(sl()));
  sl.registerLazySingleton(() => GetPostsUseCase(sl()));
  sl.registerLazySingleton(() => GetMyPostsUseCase(sl()));
  sl.registerLazySingleton(() => GetPostsByCategoriesUseCase(sl()));
  sl.registerLazySingleton(() => GetPostByIdUseCase(sl()));
  sl.registerLazySingleton(() => UpdatePostUseCase(sl()));
  sl.registerLazySingleton(() => DeletePostUseCase(sl()));
  sl.registerLazySingleton(() => LikePostUseCase(sl()));
  sl.registerLazySingleton(() => UnlikePostUseCase(sl()));
  sl.registerLazySingleton(() => AddCommentUseCase(sl()));
  sl.registerLazySingleton(() => GetCommentsUseCase(sl()));
  sl.registerLazySingleton(() => UpdateCommentUseCase(sl()));
  sl.registerLazySingleton(() => RemoveCommentUseCase(sl()));
  sl.registerLazySingleton(() => ReplyOnCommentUseCase(sl()));
  sl.registerLazySingleton(() => GetRepliesForCommentUseCase(sl()));
  sl.registerLazySingleton(() => UpdateReplyOnCommentUseCase(sl()));
  sl.registerLazySingleton(() => DeleteReplyOnCommentUseCase(sl()));
  sl.registerLazySingleton(() => SyncLatestPostsUseCase(sl()));
  sl.registerLazySingleton(() => UploadImageUseCase(sl()));
  // BLoCs
  sl.registerFactory(
    () => PostsBloc(
      getPostsUseCase: sl(),
      likePostUseCase: sl(),
      unlikePostUseCase: sl(),
    ),
  );



  sl.registerFactory(() => PostCrudBloc(sl(), sl(), sl(), sl()));
  sl.registerFactory(() => CommentsBloc(sl(), sl(), sl(), sl()));
  sl.registerFactory(() => CommentRepliesBloc(sl(), sl(), sl(), sl()));
  sl.registerFactory(() => MyPostsCubit(
        getMyPostsUseCase: sl(),
        deletePostUseCase: sl(),
        updatePostUseCase: sl(),
      ));

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
