// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get home => 'Home';

  @override
  String get homeContinueLearning =>
      'Continue learning, you\'re makeing your future';

  @override
  String get homeLatestNewsAndEvents => 'Latest News and Events';

  @override
  String get homeNoNewsAvailable => 'No news available';

  @override
  String get homeAnotherNewsItem => 'Another News Item';

  @override
  String get homeNewsDescription =>
      'Description for the second news item goes here.';

  @override
  String get homeThirdEvent => 'Third Event';

  @override
  String get homeThirdEventDetails =>
      'Details about the third event happening soon.';

  @override
  String get homeTodayTasks => 'Today\'s Tasks';

  @override
  String get homeStartNewChallenge => 'Start a new challenge today';

  @override
  String get homeNoTasksForToday => 'No tasks for today!';

  @override
  String get homeReviewChapterOne => 'Review Chapter 1';

  @override
  String get homeSolveMathHomework => 'Solve Math homework';

  @override
  String get homeContinueStudying => 'Continue Studying';

  @override
  String get homeRecentlyAdded => 'Recently Added';

  @override
  String get homeAdvancedSoftwareEngineering =>
      'Advanced Software Engineering - Chapter 3';

  @override
  String get seeAll => 'See all';

  @override
  String get navHome => 'Home';

  @override
  String get navCourses => 'Courses';

  @override
  String get navCommunity => 'Community';

  @override
  String get navMore => 'More';

  @override
  String get todoMyToDos => 'My ToDos';

  @override
  String get todoEditTask => 'Edit Task';

  @override
  String get todoAddNewTask => 'Add New Task';

  @override
  String get todoNoTasks => 'No Tasks Yet';

  @override
  String get todoAddFirstTask =>
      'Add your first task by tapping the + button below';

  @override
  String get todoSetDueDate => 'Set Due Date (Optional)';

  @override
  String todoDueDate(String date) {
    return 'Due: $date';
  }

  @override
  String get todoUpdateTask => 'Update Task';

  @override
  String get todoAddTask => 'Add Task';

  @override
  String get todoMarkAsCompleted => 'Mark as completed';

  @override
  String get todoLoadingTasks => 'Loading tasks...';

  @override
  String get todoNoDataAvailable => 'No data available';

  @override
  String get newsNoNewsAvailable => 'No news available';

  @override
  String get newsCheckBackLater => 'Check back later for updates';

  @override
  String get tryAgain => 'Try Again';

  @override
  String get quizTitle => 'Quiz';

  @override
  String get quizResultsTitle => 'Quiz Results';

  @override
  String get quizEmptyNoQuestions => 'No questions found for this lesson yet!';

  @override
  String get quizEmptyTryAnotherLesson =>
      'Please check back later or try another lesson.';

  @override
  String get quizErrorTitle => 'Oops! Something went wrong.';

  @override
  String get quizErrorBody =>
      'We couldn\'t load the quiz. Please try again later.';

  @override
  String get quizPrev => 'Previous';

  @override
  String get quizNext => 'Next Question';

  @override
  String get quizSubmit => 'Submit Quiz';

  @override
  String quizProgressBar(Object current, Object total) {
    return 'Question $current of $total';
  }

  @override
  String get quizGoHome => 'Go Home';

  @override
  String quizResultCardQuestion(Object number) {
    return 'Question $number';
  }

  @override
  String get quizResultCardYourAnswer => 'Your answer: ';

  @override
  String get quizResultCardCorrectAnswer => 'Correct answer: ';

  @override
  String get quizResultCardNoAnswer => 'No answer selected';

  @override
  String get quizScoreSummaryTitle => 'Your Score';

  @override
  String quizScoreSummaryScore(Object score, Object total) {
    return '$score / $total';
  }

  @override
  String get quizScoreSummaryPassed => 'Great job, you passed!';

  @override
  String get quizScoreSummaryTryAgain => 'Keep practicing, you\'ll get there!';

  @override
  String get todoTitle => 'Title';

  @override
  String get todoEnterTitle => 'Please enter a title';

  @override
  String get todoDescription => 'Description';

  @override
  String get todoImportance => 'Importance';

  @override
  String get todoImportanceLow => 'Low';

  @override
  String get todoImportanceMedium => 'Medium';

  @override
  String get todoImportanceHigh => 'High';

  @override
  String get todoNoDueDate => 'No due date';

  @override
  String get todoConfirmDelete => 'Confirm Delete';

  @override
  String get todoDeleteConfirmation =>
      'Are you sure you want to delete this item?';

  @override
  String get todoCancel => 'Cancel';

  @override
  String get todoDelete => 'Delete';

  @override
  String errorCouldNotLaunch(Object url) {
    return 'Could not launch $url';
  }
}
