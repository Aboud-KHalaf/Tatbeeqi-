import 'package:get_it/get_it.dart';
import 'package:tatbeeqi/core/di/ai_assistant_dependencies.dart';
import 'package:tatbeeqi/core/di/auth_dependencies.dart';
import 'package:tatbeeqi/core/di/course_content_dependencies.dart';
import 'package:tatbeeqi/core/di/localization_dependencies.dart';
import 'package:tatbeeqi/core/di/navigation_dependencies.dart';
import 'package:tatbeeqi/core/di/news_dependencies.dart';
import 'package:tatbeeqi/core/di/notification_dependencies.dart';
import 'package:tatbeeqi/core/di/theme_dependencies.dart';
import 'package:tatbeeqi/core/di/todo_dependencies.dart';
import 'package:tatbeeqi/core/di/courses_dependencies.dart';
import 'package:tatbeeqi/core/di/notes_dependencies.dart';
import 'package:tatbeeqi/core/di/quizes_dependencies.dart';
import 'package:tatbeeqi/core/di/posts_dependencies.dart';

void initFeatureDependencies(GetIt sl) {
  initThemeDependencies(sl);
  initLocalizationDependencies(sl);
  initNotificationDependencies(sl);
  initNavigationDependencies(sl);
  initNewsDependencies(sl);
  initTDoDependencies(sl);
  initCoursesDependencies(sl);
  initNotesDependencies(sl);
  initAuthDependencies(sl);
  initQuizzesDependencies(sl);
  initPostsDependencies(sl);
  initCourseContentDependencies(sl);
  initAiAssistantDependencies(sl);
}
