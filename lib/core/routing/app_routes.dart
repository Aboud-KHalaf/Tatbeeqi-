import 'package:tatbeeqi/features/courses_content/presentation/screens/course_overview_screen.dart';
import 'package:tatbeeqi/features/home/presentation/views/home_view.dart';
import 'package:tatbeeqi/features/news/presentation/views/all_news_view.dart';
import 'package:tatbeeqi/features/news/presentation/views/news_details_view.dart';
import 'package:tatbeeqi/features/notes/presentation/views/add_update_note_view.dart';
import 'package:tatbeeqi/features/notes/presentation/views/notes_view.dart';
import 'package:tatbeeqi/features/quiz/presentation/views/quiz_view.dart';
import 'package:tatbeeqi/features/quiz/presentation/views/result_view.dart';
import 'package:tatbeeqi/features/settings/presentation/screens/settings_screen.dart';
import 'package:tatbeeqi/features/todo/presentation/views/todo_view.dart';

class AppRoutes {
  // Static Routes
  static const String home = HomeView.routePath;
  static const String settingsPath = SettingsView.routePath;
  static const String allNewsPath = AllNewsView.routeId;
  static const String todoPath = TodoView.routePath;
  static const String courseOverviewPath = CourseOverviewScreen.routePath;
  static const String notesPath = NotesView.routePath;
  static const String newsDetailsPath = NewsDetailsView.routeId;
  static const String addUpdateNotePath = AddOrUpdateNoteView.routePath;
  static const String quizPath = QuizView.routeName;
  static const String quizResultPath = ResultView.routeName;
  
  // Auth
  static const String signInPath = '/auth/signin';
  static const String signUpPath = '/auth/signup';
  static const String forgetPasswordPath = '/auth/forget';
}
