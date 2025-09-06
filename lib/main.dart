import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tatbeeqi/features/auth/domain/entities/user.dart';
import 'package:tatbeeqi/core/di/service_locator.dart' as di;
import 'package:tatbeeqi/core/routing/app_router.dart';
import 'package:tatbeeqi/features/ai_assistant/presentation/cubit/ai_assistant_cubit.dart';
import 'package:tatbeeqi/features/auth/presentation/manager/user_cubit/user_cubit.dart';
import 'package:tatbeeqi/features/courses/presentation/manager/fetch_courses_cubit/fetch_courses_cubit.dart';
import 'package:tatbeeqi/features/courses/presentation/manager/recent_courses_cubit/recent_courses_cubit.dart';
import 'package:tatbeeqi/features/courses/presentation/manager/retake_courses_cubit/retake_courses_cubit.dart';
import 'package:tatbeeqi/features/courses_content/presentation/manager/lectures/lectures_cubit.dart';
import 'package:tatbeeqi/features/courses_content/presentation/manager/lesson_completion/lesson_completion_cubit.dart';
import 'package:tatbeeqi/features/courses_content/presentation/manager/lessons/lessons_cubit.dart';
import 'package:tatbeeqi/features/grades/presentation/manager/grades_cubit.dart';
import 'package:tatbeeqi/features/localization/presentation/manager/locale_cubit/locale_cubit.dart';
import 'package:tatbeeqi/features/localization/presentation/manager/locale_cubit/locale_state.dart';
import 'package:tatbeeqi/features/news/presentation/manager/news_cubit.dart';
import 'package:tatbeeqi/features/notes/presentation/bloc/notes_bloc.dart';
import 'package:tatbeeqi/features/navigation/presentation/manager/navigation_cubit/navigation_cubit.dart';
import 'package:tatbeeqi/features/notifications/data/handlers/firebase_messaging_handlers.dart';
import 'package:tatbeeqi/features/notifications/presentation/manager/initialize_notifications_cubit/initialize_notifications_cubit.dart';
import 'package:tatbeeqi/features/posts/presentation/manager/comments/comments_bloc.dart';
import 'package:tatbeeqi/features/posts/presentation/manager/create_post/create_post_bloc.dart';
import 'package:tatbeeqi/features/posts/presentation/manager/post_feed/post_feed_bloc.dart';
import 'package:tatbeeqi/features/posts/presentation/manager/post_feed/post_feed_event.dart';
import 'package:tatbeeqi/features/quiz/presentation/bloc/quiz_bloc.dart';
import 'package:tatbeeqi/features/reports/presentation/manager/reports_cubit.dart';
import 'package:tatbeeqi/features/theme/presentation/manager/theme_cubit/theme_cubit.dart';
import 'package:tatbeeqi/features/todo/presentation/manager/todo_cubit.dart';
import 'package:tatbeeqi/features/auth/presentation/manager/bloc/auth_bloc.dart';
import 'package:tatbeeqi/l10n/app_localizations.dart';
import 'package:tatbeeqi/core/observers/recent_courses_observer.dart';
import 'package:tatbeeqi/core/observers/multi_bloc_observer.dart';
import 'package:tatbeeqi/core/observers/auth_observer.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'firebase_options.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:tatbeeqi/features/feedbacks/presentation/widgets/feedback_wrapper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();

  //  git rm --cached .env
  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
  );
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  await Hive.initFlutter();
  Hive.registerAdapter(UserAdapter());

  await di.init();
  // Initialize multiple Bloc observers (RecentCourses + Auth)
  Bloc.observer = MultiBlocObserver([
    RecentCoursesObserver(),
    AuthObserver(),
  ]);
  timeago.setLocaleMessages('ar', timeago.ArMessages());
  timeago.setLocaleMessages('en', timeago.EnMessages());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<InitializeNotificationsCubit>(
          create: (_) => di.sl<InitializeNotificationsCubit>()..initialize(),
          lazy: false,
        ),
        BlocProvider(
          create: (_) => di.sl<LocaleCubit>()..getSavedLocale(),
        ),
        BlocProvider(
          create: (_) => di.sl<ThemeCubit>()..loadTheme(),
        ),
        BlocProvider(
          create: (_) => di.sl<NavigationCubit>(),
        ),
        BlocProvider(
          create: (_) => di.sl<AuthBloc>(),
        ),
        // should move from main
        BlocProvider(
          // TEMP
          create: (_) => di.sl<FetchCoursesCubit>()..fetchCourses(),
        ),
        BlocProvider(
          // TEMP
          create: (_) => di.sl<NewsCubit>()..fetchNews(),
        ),
        BlocProvider(create: (_) => di.sl<RetakeCoursesCubit>()),
        BlocProvider(
          create: (_) => di.sl<NotesBloc>(),
        ),
        BlocProvider(
          // TEMP
          create: (_) => di.sl<ToDoCubit>()..fetchToDos(),
        ),
        BlocProvider(
          create: (_) => di.sl<PostCrudBloc>(),
        ),
        BlocProvider(
          create: (_) => di.sl<QuizBloc>(),
        ),
        BlocProvider(
          create: (_) => di.sl<CommentsBloc>(),
        ),
        BlocProvider(
          create: (_) => di.sl<PostsBloc>()..add(FetchPostsEvent()),
        ),
        BlocProvider(
          create: (_) => di.sl<LecturesCubit>(),
        ),
        BlocProvider(
          create: (_) => di.sl<LessonsCubit>(),
        ),
        BlocProvider(
          create: (_) => di.sl<AiAssistantCubit>(),
        ),
        BlocProvider(
          create: (_) => di.sl<LessonCompletionCubit>(),
        ),
        BlocProvider(
          create: (_) => di.sl<RecentCoursesCubit>()..load(),
        ),
        BlocProvider(
          create: (_) => di.sl<UserCubit>()..loadCurrentUser(),
        ),
        BlocProvider(
          create: (_) => di.sl<GradesCubit>(),
        ),
      BlocProvider(
          create: (_) => di.sl<ReportsCubit>(),
        ),
      ],
      child: BlocBuilder<LocaleCubit, LocaleState>(
        builder: (context, localeState) {
          final currentLocale = (localeState is LocaleLoaded)
              ? localeState.locale
              : const Locale('ar');

          return BlocBuilder<ThemeCubit, ThemeData>(
            builder: (context, currentThemeData) {
              return Builder(
                builder: (context) {
                  final authBloc = BlocProvider.of<AuthBloc>(context);
                  final router = createRouter(authBloc);
                  return FeedbackWrapper(
                    child: MaterialApp.router(
                      routerConfig: router,
                      debugShowCheckedModeBanner: false,
                      locale: currentLocale,
                      theme: currentThemeData,
                      localizationsDelegates: const [
                        AppLocalizations.delegate,
                        GlobalMaterialLocalizations.delegate,
                        GlobalWidgetsLocalizations.delegate,
                        GlobalCupertinoLocalizations.delegate,
                      ],
                      supportedLocales: const [
                        Locale('ar'),
                        Locale('en'),
                      ],
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
