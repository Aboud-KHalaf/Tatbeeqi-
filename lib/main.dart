import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tatbeeqi/core/di/service_locator.dart' as di;
import 'package:tatbeeqi/core/routing/app_router.dart';
import 'package:tatbeeqi/features/courses/presentation/manager/fetch_courses_cubit/fetch_courses_cubit.dart';
import 'package:tatbeeqi/features/courses/presentation/manager/retake_courses_cubit/retake_courses_cubit.dart';
import 'package:tatbeeqi/features/localization/presentation/manager/locale_cubit/locale_cubit.dart';
import 'package:tatbeeqi/features/localization/presentation/manager/locale_cubit/locale_state.dart';
import 'package:tatbeeqi/features/news/presentation/manager/news_cubit.dart';
import 'package:tatbeeqi/features/notes/presentation/bloc/notes_bloc.dart';
import 'package:tatbeeqi/features/navigation/presentation/manager/navigation_cubit/navigation_cubit.dart';
import 'package:tatbeeqi/features/notifications/presentation/manager/initialize_notifications_cubit/initialize_notifications_cubit.dart';
import 'package:tatbeeqi/features/theme/presentation/manager/theme_cubit/theme_cubit.dart';
import 'package:tatbeeqi/features/todo/presentation/manager/todo_cubit.dart';
import 'package:tatbeeqi/l10n/app_localizations.dart';
import 'firebase_options.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

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
  await di.init();
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
            lazy: true,
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
          // should move from main
          BlocProvider(
            // TEMP
            create: (_) => di.sl<FetchCoursesCubit>(),
          ),
          BlocProvider(
            // TEMP
            create: (_) => di.sl<NewsCubit>(),
          ),
          BlocProvider(
            create: (_) => di.sl<RetakeCoursesCubit>(),
          ),
          BlocProvider(
            create: (_) => di.sl<NotesBloc>(),
          ),
          BlocProvider(
            // TEMP
            create: (_) => di.sl<ToDoCubit>(),
          ),
        ],
        child: BlocBuilder<LocaleCubit, LocaleState>(
          builder: (context, localeState) {
            final currentLocale = (localeState is LocaleLoaded)
                ? localeState.locale
                : const Locale('ar');

            return BlocBuilder<ThemeCubit, ThemeData>(
              builder: (context, currentThemeData) {
                return MaterialApp.router(
                  routerConfig: router,
                  debugShowCheckedModeBanner: false,
                  locale: currentLocale,
                  localizationsDelegates: const [
                    AppLocalizations.delegate,
                    GlobalMaterialLocalizations.delegate,
                    GlobalWidgetsLocalizations.delegate,
                    GlobalCupertinoLocalizations.delegate,
                  ],
                  supportedLocales: AppLocalizations.supportedLocales,
                  theme: currentThemeData,
                );
              },
            );
          },
        ));
  }
}
