import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en')
  ];

  /// No description provided for @homeGreeting.
  ///
  /// In en, this message translates to:
  /// **'Hello Aboud'**
  String get homeGreeting;

  /// No description provided for @homeContinueLearning.
  ///
  /// In en, this message translates to:
  /// **'Continue learning, you\'re makeing your future'**
  String get homeContinueLearning;

  /// No description provided for @homeLatestNewsAndEvents.
  ///
  /// In en, this message translates to:
  /// **'Latest News and Events'**
  String get homeLatestNewsAndEvents;

  /// No description provided for @homeNoNewsAvailable.
  ///
  /// In en, this message translates to:
  /// **'No news available'**
  String get homeNoNewsAvailable;

  /// No description provided for @homeAnotherNewsItem.
  ///
  /// In en, this message translates to:
  /// **'Another News Item'**
  String get homeAnotherNewsItem;

  /// No description provided for @homeNewsDescription.
  ///
  /// In en, this message translates to:
  /// **'Description for the second news item goes here.'**
  String get homeNewsDescription;

  /// No description provided for @homeThirdEvent.
  ///
  /// In en, this message translates to:
  /// **'Third Event'**
  String get homeThirdEvent;

  /// No description provided for @homeThirdEventDetails.
  ///
  /// In en, this message translates to:
  /// **'Details about the third event happening soon.'**
  String get homeThirdEventDetails;

  /// No description provided for @homeTodayTasks.
  ///
  /// In en, this message translates to:
  /// **'Today\'s Tasks'**
  String get homeTodayTasks;

  /// No description provided for @homeStartNewChallenge.
  ///
  /// In en, this message translates to:
  /// **'Start a new challenge today'**
  String get homeStartNewChallenge;

  /// No description provided for @homeNoTasksForToday.
  ///
  /// In en, this message translates to:
  /// **'No tasks for today!'**
  String get homeNoTasksForToday;

  /// No description provided for @homeReviewChapterOne.
  ///
  /// In en, this message translates to:
  /// **'Review Chapter 1'**
  String get homeReviewChapterOne;

  /// No description provided for @homeSolveMathHomework.
  ///
  /// In en, this message translates to:
  /// **'Solve Math homework'**
  String get homeSolveMathHomework;

  /// No description provided for @homeContinueStudying.
  ///
  /// In en, this message translates to:
  /// **'Continue Studying'**
  String get homeContinueStudying;

  /// No description provided for @homeRecentlyAdded.
  ///
  /// In en, this message translates to:
  /// **'Recently Added'**
  String get homeRecentlyAdded;

  /// No description provided for @homeAdvancedSoftwareEngineering.
  ///
  /// In en, this message translates to:
  /// **'Advanced Software Engineering - Chapter 3'**
  String get homeAdvancedSoftwareEngineering;

  /// No description provided for @seeAll.
  ///
  /// In en, this message translates to:
  /// **'See all'**
  String get seeAll;

  /// No description provided for @navHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// No description provided for @navCourses.
  ///
  /// In en, this message translates to:
  /// **'Courses'**
  String get navCourses;

  /// No description provided for @navCommunity.
  ///
  /// In en, this message translates to:
  /// **'Community'**
  String get navCommunity;

  /// No description provided for @navMore.
  ///
  /// In en, this message translates to:
  /// **'More'**
  String get navMore;

  /// No description provided for @todoMyToDos.
  ///
  /// In en, this message translates to:
  /// **'My ToDos'**
  String get todoMyToDos;

  /// No description provided for @todoEditTask.
  ///
  /// In en, this message translates to:
  /// **'Edit Task'**
  String get todoEditTask;

  /// No description provided for @todoAddNewTask.
  ///
  /// In en, this message translates to:
  /// **'Add New Task'**
  String get todoAddNewTask;

  /// Text shown when there are no tasks
  ///
  /// In en, this message translates to:
  /// **'No Tasks Yet'**
  String get todoNoTasks;

  /// Instruction for adding first task
  ///
  /// In en, this message translates to:
  /// **'Add your first task by tapping the + button below'**
  String get todoAddFirstTask;

  /// Label for setting due date
  ///
  /// In en, this message translates to:
  /// **'Set Due Date (Optional)'**
  String get todoSetDueDate;

  /// Due date with formatted date
  ///
  /// In en, this message translates to:
  /// **'Due: {date}'**
  String todoDueDate(String date);

  /// Button text for updating a task
  ///
  /// In en, this message translates to:
  /// **'Update Task'**
  String get todoUpdateTask;

  /// Button text for adding a task
  ///
  /// In en, this message translates to:
  /// **'Add Task'**
  String get todoAddTask;

  /// Label for completion checkbox
  ///
  /// In en, this message translates to:
  /// **'Mark as completed'**
  String get todoMarkAsCompleted;

  /// Text shown when loading tasks
  ///
  /// In en, this message translates to:
  /// **'Loading tasks...'**
  String get todoLoadingTasks;

  /// Text shown when no data is available
  ///
  /// In en, this message translates to:
  /// **'No data available'**
  String get todoNoDataAvailable;

  /// Text shown when there are no news
  ///
  /// In en, this message translates to:
  /// **'No news available'**
  String get newsNoNewsAvailable;

  /// Message to check back later for news updates
  ///
  /// In en, this message translates to:
  /// **'Check back later for updates'**
  String get newsCheckBackLater;

  /// No description provided for @tryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try Again'**
  String get tryAgain;

  /// No description provided for @quizTitle.
  ///
  /// In en, this message translates to:
  /// **'Quiz'**
  String get quizTitle;

  /// No description provided for @quizResultsTitle.
  ///
  /// In en, this message translates to:
  /// **'Quiz Results'**
  String get quizResultsTitle;

  /// No description provided for @quizEmptyNoQuestions.
  ///
  /// In en, this message translates to:
  /// **'No questions found for this lesson yet!'**
  String get quizEmptyNoQuestions;

  /// No description provided for @quizEmptyTryAnotherLesson.
  ///
  /// In en, this message translates to:
  /// **'Please check back later or try another lesson.'**
  String get quizEmptyTryAnotherLesson;

  /// No description provided for @quizErrorTitle.
  ///
  /// In en, this message translates to:
  /// **'Oops! Something went wrong.'**
  String get quizErrorTitle;

  /// No description provided for @quizErrorBody.
  ///
  /// In en, this message translates to:
  /// **'We couldn\'t load the quiz. Please try again later.'**
  String get quizErrorBody;

  /// No description provided for @quizPrev.
  ///
  /// In en, this message translates to:
  /// **'Previous'**
  String get quizPrev;

  /// No description provided for @quizNext.
  ///
  /// In en, this message translates to:
  /// **'Next Question'**
  String get quizNext;

  /// No description provided for @quizSubmit.
  ///
  /// In en, this message translates to:
  /// **'Submit Quiz'**
  String get quizSubmit;

  /// No description provided for @quizProgressBar.
  ///
  /// In en, this message translates to:
  /// **'Question {current} of {total}'**
  String quizProgressBar(Object current, Object total);

  /// No description provided for @quizGoHome.
  ///
  /// In en, this message translates to:
  /// **'Go Home'**
  String get quizGoHome;

  /// No description provided for @quizResultCardQuestion.
  ///
  /// In en, this message translates to:
  /// **'Question {number}'**
  String quizResultCardQuestion(Object number);

  /// No description provided for @quizResultCardYourAnswer.
  ///
  /// In en, this message translates to:
  /// **'Your answer: '**
  String get quizResultCardYourAnswer;

  /// No description provided for @quizResultCardCorrectAnswer.
  ///
  /// In en, this message translates to:
  /// **'Correct answer: '**
  String get quizResultCardCorrectAnswer;

  /// No description provided for @quizResultCardNoAnswer.
  ///
  /// In en, this message translates to:
  /// **'No answer selected'**
  String get quizResultCardNoAnswer;

  /// No description provided for @quizScoreSummaryTitle.
  ///
  /// In en, this message translates to:
  /// **'Your Score'**
  String get quizScoreSummaryTitle;

  /// No description provided for @quizScoreSummaryScore.
  ///
  /// In en, this message translates to:
  /// **'{score} / {total}'**
  String quizScoreSummaryScore(Object score, Object total);

  /// No description provided for @quizScoreSummaryPassed.
  ///
  /// In en, this message translates to:
  /// **'Great job, you passed!'**
  String get quizScoreSummaryPassed;

  /// No description provided for @quizScoreSummaryTryAgain.
  ///
  /// In en, this message translates to:
  /// **'Keep practicing, you\'ll get there!'**
  String get quizScoreSummaryTryAgain;

  /// Label for task title field
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get todoTitle;

  /// Validation message for empty title
  ///
  /// In en, this message translates to:
  /// **'Please enter a title'**
  String get todoEnterTitle;

  /// Label for task description field
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get todoDescription;

  /// Label for task importance section
  ///
  /// In en, this message translates to:
  /// **'Importance'**
  String get todoImportance;

  /// Label for low importance option
  ///
  /// In en, this message translates to:
  /// **'Low'**
  String get todoImportanceLow;

  /// Label for medium importance option
  ///
  /// In en, this message translates to:
  /// **'Medium'**
  String get todoImportanceMedium;

  /// Label for high importance option
  ///
  /// In en, this message translates to:
  /// **'High'**
  String get todoImportanceHigh;

  /// Text shown when no due date is set
  ///
  /// In en, this message translates to:
  /// **'No due date'**
  String get todoNoDueDate;

  /// Title for delete confirmation dialog
  ///
  /// In en, this message translates to:
  /// **'Confirm Delete'**
  String get todoConfirmDelete;

  /// Message for delete confirmation dialog
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this item?'**
  String get todoDeleteConfirmation;

  /// Label for cancel button
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get todoCancel;

  /// Label for delete button
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get todoDelete;

  /// Error message shown when a URL cannot be launched
  ///
  /// In en, this message translates to:
  /// **'Could not launch {url}'**
  String errorCouldNotLaunch(Object url);

  /// No description provided for @postsFeedTitle.
  ///
  /// In en, this message translates to:
  /// **'Feed'**
  String get postsFeedTitle;

  /// No description provided for @postsWelcomeToFeed.
  ///
  /// In en, this message translates to:
  /// **'Welcome to the Feed'**
  String get postsWelcomeToFeed;

  /// No description provided for @postsNoPostsAvailable.
  ///
  /// In en, this message translates to:
  /// **'No posts available'**
  String get postsNoPostsAvailable;

  /// No description provided for @postsLoadingMorePosts.
  ///
  /// In en, this message translates to:
  /// **'Loading more posts...'**
  String get postsLoadingMorePosts;

  /// No description provided for @postsEndReachedTitle.
  ///
  /// In en, this message translates to:
  /// **'You\'re all caught up!'**
  String get postsEndReachedTitle;

  /// No description provided for @postsEndReachedSubtitle.
  ///
  /// In en, this message translates to:
  /// **'No more posts to load'**
  String get postsEndReachedSubtitle;

  /// No description provided for @createPostAppBarTitlePost.
  ///
  /// In en, this message translates to:
  /// **'Create Post'**
  String get createPostAppBarTitlePost;

  /// No description provided for @createPostAppBarTitleArticle.
  ///
  /// In en, this message translates to:
  /// **'Create Article'**
  String get createPostAppBarTitleArticle;

  /// No description provided for @createPostPreview.
  ///
  /// In en, this message translates to:
  /// **'Preview'**
  String get createPostPreview;

  /// No description provided for @createPostPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'What\'s on your mind?'**
  String get createPostPlaceholder;

  /// No description provided for @createPostPhoto.
  ///
  /// In en, this message translates to:
  /// **'Photo'**
  String get createPostPhoto;

  /// No description provided for @createPostPost.
  ///
  /// In en, this message translates to:
  /// **'Post'**
  String get createPostPost;

  /// No description provided for @createPostArticle.
  ///
  /// In en, this message translates to:
  /// **'Article'**
  String get createPostArticle;

  /// No description provided for @createPostPostType.
  ///
  /// In en, this message translates to:
  /// **'Post Type'**
  String get createPostPostType;

  /// No description provided for @createPostValidationEnterContent.
  ///
  /// In en, this message translates to:
  /// **'Please enter some content'**
  String get createPostValidationEnterContent;

  /// No description provided for @createPostAddContentToPreview.
  ///
  /// In en, this message translates to:
  /// **'Add some content to preview'**
  String get createPostAddContentToPreview;

  /// No description provided for @imageSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Image'**
  String get imageSectionTitle;

  /// No description provided for @imageSectionAddImage.
  ///
  /// In en, this message translates to:
  /// **'Add Image'**
  String get imageSectionAddImage;

  /// No description provided for @imageSectionCamera.
  ///
  /// In en, this message translates to:
  /// **'Camera'**
  String get imageSectionCamera;

  /// No description provided for @imageSectionGallery.
  ///
  /// In en, this message translates to:
  /// **'Gallery'**
  String get imageSectionGallery;

  /// No description provided for @commonChange.
  ///
  /// In en, this message translates to:
  /// **'Change'**
  String get commonChange;

  /// No description provided for @commonRemove.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get commonRemove;

  /// No description provided for @createPostTextFieldArticleContent.
  ///
  /// In en, this message translates to:
  /// **'Article Content'**
  String get createPostTextFieldArticleContent;

  /// No description provided for @createPostTextFieldArticleHint.
  ///
  /// In en, this message translates to:
  /// **'Write your article content here...'**
  String get createPostTextFieldArticleHint;

  /// No description provided for @createPostTextFieldPostHint.
  ///
  /// In en, this message translates to:
  /// **'Share your thoughts...'**
  String get createPostTextFieldPostHint;

  /// No description provided for @commentsEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'Start the conversation'**
  String get commentsEmptyTitle;

  /// No description provided for @commentsEmptySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Be the first to share your thoughts\nand get the discussion going!'**
  String get commentsEmptySubtitle;

  /// No description provided for @commentsEmptyHint.
  ///
  /// In en, this message translates to:
  /// **'Write your comment below'**
  String get commentsEmptyHint;

  /// No description provided for @commentsHeaderTitle.
  ///
  /// In en, this message translates to:
  /// **'Comments'**
  String get commentsHeaderTitle;

  /// No description provided for @commentsLoadingMore.
  ///
  /// In en, this message translates to:
  /// **'Loading more comments...'**
  String get commentsLoadingMore;

  /// No description provided for @addCommentHint.
  ///
  /// In en, this message translates to:
  /// **'Add a thoughtful comment...'**
  String get addCommentHint;

  /// No description provided for @addCommentSendTooltip.
  ///
  /// In en, this message translates to:
  /// **'Send comment'**
  String get addCommentSendTooltip;

  /// No description provided for @postCardCopied.
  ///
  /// In en, this message translates to:
  /// **'Text copied to clipboard'**
  String get postCardCopied;

  /// No description provided for @postCardShare.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get postCardShare;

  /// No description provided for @postCardSharePost.
  ///
  /// In en, this message translates to:
  /// **'Share Post'**
  String get postCardSharePost;

  /// No description provided for @postCardCopyLink.
  ///
  /// In en, this message translates to:
  /// **'Copy Link'**
  String get postCardCopyLink;

  /// No description provided for @postCardShareVia.
  ///
  /// In en, this message translates to:
  /// **'Share via...'**
  String get postCardShareVia;

  /// No description provided for @postCardLinkCopied.
  ///
  /// In en, this message translates to:
  /// **'Link copied to clipboard'**
  String get postCardLinkCopied;

  /// No description provided for @postCardMoreOptions.
  ///
  /// In en, this message translates to:
  /// **'More options'**
  String get postCardMoreOptions;

  /// No description provided for @postCardShowDetails.
  ///
  /// In en, this message translates to:
  /// **'Show Details'**
  String get postCardShowDetails;

  /// No description provided for @postCardReadMore.
  ///
  /// In en, this message translates to:
  /// **'Read more'**
  String get postCardReadMore;

  /// No description provided for @postCategoryLabel.
  ///
  /// In en, this message translates to:
  /// **'Categories'**
  String get postCategoryLabel;

  /// No description provided for @postCategoryHint.
  ///
  /// In en, this message translates to:
  /// **'Add a category...'**
  String get postCategoryHint;

  /// No description provided for @postImagePickerCoverOptional.
  ///
  /// In en, this message translates to:
  /// **'Cover Image (Optional)'**
  String get postImagePickerCoverOptional;

  /// No description provided for @publishButtonPublishingArticle.
  ///
  /// In en, this message translates to:
  /// **'Publishing...'**
  String get publishButtonPublishingArticle;

  /// No description provided for @publishButtonPosting.
  ///
  /// In en, this message translates to:
  /// **'Posting...'**
  String get publishButtonPosting;

  /// No description provided for @publishButtonPublishArticle.
  ///
  /// In en, this message translates to:
  /// **'Publish Article'**
  String get publishButtonPublishArticle;

  /// No description provided for @publishButtonPost.
  ///
  /// In en, this message translates to:
  /// **'Post'**
  String get publishButtonPost;

  /// No description provided for @createPostSuccessArticle.
  ///
  /// In en, this message translates to:
  /// **'Article published successfully!'**
  String get createPostSuccessArticle;

  /// No description provided for @createPostSuccessPost.
  ///
  /// In en, this message translates to:
  /// **'Post created successfully!'**
  String get createPostSuccessPost;

  /// No description provided for @unsavedChangesTitle.
  ///
  /// In en, this message translates to:
  /// **'Discard changes?'**
  String get unsavedChangesTitle;

  /// No description provided for @unsavedChangesBody.
  ///
  /// In en, this message translates to:
  /// **'You have unsaved changes that will be lost if you leave now.'**
  String get unsavedChangesBody;

  /// No description provided for @unsavedChangesKeepEditing.
  ///
  /// In en, this message translates to:
  /// **'Keep editing'**
  String get unsavedChangesKeepEditing;

  /// No description provided for @unsavedChangesDiscard.
  ///
  /// In en, this message translates to:
  /// **'Discard'**
  String get unsavedChangesDiscard;

  /// No description provided for @topicsLabel.
  ///
  /// In en, this message translates to:
  /// **'Topics'**
  String get topicsLabel;

  /// No description provided for @markdownHeader1.
  ///
  /// In en, this message translates to:
  /// **'Header 1'**
  String get markdownHeader1;

  /// No description provided for @markdownHeader2.
  ///
  /// In en, this message translates to:
  /// **'Header 2'**
  String get markdownHeader2;

  /// No description provided for @markdownHeader3.
  ///
  /// In en, this message translates to:
  /// **'Header 3'**
  String get markdownHeader3;

  /// No description provided for @markdownBold.
  ///
  /// In en, this message translates to:
  /// **'Bold'**
  String get markdownBold;

  /// No description provided for @markdownItalic.
  ///
  /// In en, this message translates to:
  /// **'Italic'**
  String get markdownItalic;

  /// No description provided for @markdownStrikethrough.
  ///
  /// In en, this message translates to:
  /// **'Strikethrough'**
  String get markdownStrikethrough;

  /// No description provided for @markdownInlineCode.
  ///
  /// In en, this message translates to:
  /// **'Inline Code'**
  String get markdownInlineCode;

  /// No description provided for @markdownCodeBlock.
  ///
  /// In en, this message translates to:
  /// **'Code Block'**
  String get markdownCodeBlock;

  /// No description provided for @markdownUnorderedList.
  ///
  /// In en, this message translates to:
  /// **'Unordered List'**
  String get markdownUnorderedList;

  /// No description provided for @markdownOrderedList.
  ///
  /// In en, this message translates to:
  /// **'Ordered List'**
  String get markdownOrderedList;

  /// No description provided for @markdownQuote.
  ///
  /// In en, this message translates to:
  /// **'Quote'**
  String get markdownQuote;

  /// No description provided for @markdownLink.
  ///
  /// In en, this message translates to:
  /// **'Link'**
  String get markdownLink;

  /// No description provided for @markdownImage.
  ///
  /// In en, this message translates to:
  /// **'Image'**
  String get markdownImage;

  /// No description provided for @markdownHorizontalRule.
  ///
  /// In en, this message translates to:
  /// **'Horizontal Rule'**
  String get markdownHorizontalRule;

  /// No description provided for @editProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get editProfile;

  /// No description provided for @fullName.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get fullName;

  /// No description provided for @fullNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Full name is required'**
  String get fullNameRequired;

  /// No description provided for @academicYear.
  ///
  /// In en, this message translates to:
  /// **'Academic Year'**
  String get academicYear;

  /// No description provided for @academicYearRequired.
  ///
  /// In en, this message translates to:
  /// **'Academic year is required'**
  String get academicYearRequired;

  /// Department label
  ///
  /// In en, this message translates to:
  /// **'Department'**
  String get department;

  /// No description provided for @departmentRequired.
  ///
  /// In en, this message translates to:
  /// **'Please select department'**
  String get departmentRequired;

  /// No description provided for @phoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phoneNumber;

  /// No description provided for @optional.
  ///
  /// In en, this message translates to:
  /// **'Optional'**
  String get optional;

  /// No description provided for @invalidPhoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Invalid phone number'**
  String get invalidPhoneNumber;

  /// No description provided for @bio.
  ///
  /// In en, this message translates to:
  /// **'Bio'**
  String get bio;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @profileUpdatedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Profile updated successfully'**
  String get profileUpdatedSuccessfully;

  /// No description provided for @tapToChangePhoto.
  ///
  /// In en, this message translates to:
  /// **'Tap to change photo'**
  String get tapToChangePhoto;

  /// No description provided for @signOut.
  ///
  /// In en, this message translates to:
  /// **'Sign Out'**
  String get signOut;

  /// No description provided for @signOutConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to sign out?'**
  String get signOutConfirmation;

  /// No description provided for @quickActions.
  ///
  /// In en, this message translates to:
  /// **'Quick Actions'**
  String get quickActions;

  /// No description provided for @myCourses.
  ///
  /// In en, this message translates to:
  /// **'My Courses'**
  String get myCourses;

  /// No description provided for @myNotes.
  ///
  /// In en, this message translates to:
  /// **'My Notes'**
  String get myNotes;

  /// No description provided for @viewAndEdit.
  ///
  /// In en, this message translates to:
  /// **'View and edit'**
  String get viewAndEdit;

  /// Saved posts shortcut title
  ///
  /// In en, this message translates to:
  /// **'Saved'**
  String get savedPosts;

  /// No description provided for @yourBookmarks.
  ///
  /// In en, this message translates to:
  /// **'Your bookmarks'**
  String get yourBookmarks;

  /// No description provided for @reminders.
  ///
  /// In en, this message translates to:
  /// **'Reminders'**
  String get reminders;

  /// No description provided for @upcomingTasks.
  ///
  /// In en, this message translates to:
  /// **'Upcoming tasks'**
  String get upcomingTasks;

  /// Settings section title
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @accountAndSecurity.
  ///
  /// In en, this message translates to:
  /// **'Account & Security'**
  String get accountAndSecurity;

  /// No description provided for @profilePasswordSessions.
  ///
  /// In en, this message translates to:
  /// **'Profile, password, sessions'**
  String get profilePasswordSessions;

  /// Notifications settings title
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @manageNotificationPreferences.
  ///
  /// In en, this message translates to:
  /// **'Manage notification preferences'**
  String get manageNotificationPreferences;

  /// No description provided for @appearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get appearance;

  /// No description provided for @themeColorsFont.
  ///
  /// In en, this message translates to:
  /// **'Theme, colors, font'**
  String get themeColorsFont;

  /// No description provided for @languageAndRegion.
  ///
  /// In en, this message translates to:
  /// **'Language & Region'**
  String get languageAndRegion;

  /// No description provided for @languageDateFormat.
  ///
  /// In en, this message translates to:
  /// **'Language, date format'**
  String get languageDateFormat;

  /// No description provided for @studyPreferences.
  ///
  /// In en, this message translates to:
  /// **'Study Preferences'**
  String get studyPreferences;

  /// No description provided for @autoplaySpeedQuizzes.
  ///
  /// In en, this message translates to:
  /// **'Autoplay, speed, quizzes'**
  String get autoplaySpeedQuizzes;

  /// No description provided for @dataAndStorage.
  ///
  /// In en, this message translates to:
  /// **'Data & Storage'**
  String get dataAndStorage;

  /// No description provided for @cacheDownloadsBackup.
  ///
  /// In en, this message translates to:
  /// **'Cache, downloads, backup'**
  String get cacheDownloadsBackup;

  /// No description provided for @privacy.
  ///
  /// In en, this message translates to:
  /// **'Privacy'**
  String get privacy;

  /// No description provided for @profileVisibilityBlocked.
  ///
  /// In en, this message translates to:
  /// **'Profile visibility, blocked users'**
  String get profileVisibilityBlocked;

  /// No description provided for @aboutAndSupport.
  ///
  /// In en, this message translates to:
  /// **'About & Support'**
  String get aboutAndSupport;

  /// No description provided for @versionHelpContact.
  ///
  /// In en, this message translates to:
  /// **'Version, help, contact'**
  String get versionHelpContact;

  /// No description provided for @errorLoadingSettings.
  ///
  /// In en, this message translates to:
  /// **'Error loading settings'**
  String get errorLoadingSettings;

  /// No description provided for @generalNotifications.
  ///
  /// In en, this message translates to:
  /// **'General Notifications'**
  String get generalNotifications;

  /// No description provided for @enableNotifications.
  ///
  /// In en, this message translates to:
  /// **'Enable Notifications'**
  String get enableNotifications;

  /// No description provided for @receiveAllNotifications.
  ///
  /// In en, this message translates to:
  /// **'Receive all notifications'**
  String get receiveAllNotifications;

  /// No description provided for @categories.
  ///
  /// In en, this message translates to:
  /// **'Categories'**
  String get categories;

  /// No description provided for @newsAndEvents.
  ///
  /// In en, this message translates to:
  /// **'News & Events'**
  String get newsAndEvents;

  /// No description provided for @updatesFromInstitution.
  ///
  /// In en, this message translates to:
  /// **'Updates from institution'**
  String get updatesFromInstitution;

  /// No description provided for @courseUpdates.
  ///
  /// In en, this message translates to:
  /// **'Course Updates'**
  String get courseUpdates;

  /// No description provided for @newLessonsAssignments.
  ///
  /// In en, this message translates to:
  /// **'New lessons and assignments'**
  String get newLessonsAssignments;

  /// No description provided for @postsCommentsLikes.
  ///
  /// In en, this message translates to:
  /// **'Posts, comments, and likes'**
  String get postsCommentsLikes;

  /// No description provided for @studyRemindersDeadlines.
  ///
  /// In en, this message translates to:
  /// **'Study reminders and deadlines'**
  String get studyRemindersDeadlines;

  /// No description provided for @quietHours.
  ///
  /// In en, this message translates to:
  /// **'Quiet Hours'**
  String get quietHours;

  /// No description provided for @quietHoursDescription.
  ///
  /// In en, this message translates to:
  /// **'Set times when you don\'t want to receive notifications'**
  String get quietHoursDescription;

  /// No description provided for @startTime.
  ///
  /// In en, this message translates to:
  /// **'Start Time'**
  String get startTime;

  /// No description provided for @endTime.
  ///
  /// In en, this message translates to:
  /// **'End Time'**
  String get endTime;

  /// No description provided for @clearQuietHours.
  ///
  /// In en, this message translates to:
  /// **'Clear Quiet Hours'**
  String get clearQuietHours;

  /// No description provided for @themeMode.
  ///
  /// In en, this message translates to:
  /// **'Theme Mode'**
  String get themeMode;

  /// No description provided for @systemTheme.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get systemTheme;

  /// No description provided for @lightTheme.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get lightTheme;

  /// No description provided for @darkTheme.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get darkTheme;

  /// No description provided for @colors.
  ///
  /// In en, this message translates to:
  /// **'Colors'**
  String get colors;

  /// No description provided for @dynamicColor.
  ///
  /// In en, this message translates to:
  /// **'Dynamic Color'**
  String get dynamicColor;

  /// No description provided for @dynamicColorDescription.
  ///
  /// In en, this message translates to:
  /// **'Use colors from your wallpaper'**
  String get dynamicColorDescription;

  /// No description provided for @fontSize.
  ///
  /// In en, this message translates to:
  /// **'Font Size'**
  String get fontSize;

  /// No description provided for @small.
  ///
  /// In en, this message translates to:
  /// **'Small'**
  String get small;

  /// No description provided for @normal.
  ///
  /// In en, this message translates to:
  /// **'Normal'**
  String get normal;

  /// No description provided for @large.
  ///
  /// In en, this message translates to:
  /// **'Large'**
  String get large;

  /// No description provided for @fontSizePreview.
  ///
  /// In en, this message translates to:
  /// **'This is how text will look'**
  String get fontSizePreview;

  /// No description provided for @primaryColor.
  ///
  /// In en, this message translates to:
  /// **'Primary Color'**
  String get primaryColor;

  /// No description provided for @purple.
  ///
  /// In en, this message translates to:
  /// **'Purple'**
  String get purple;

  /// No description provided for @blue.
  ///
  /// In en, this message translates to:
  /// **'Blue'**
  String get blue;

  /// No description provided for @green.
  ///
  /// In en, this message translates to:
  /// **'Green'**
  String get green;

  /// No description provided for @orange.
  ///
  /// In en, this message translates to:
  /// **'Orange'**
  String get orange;

  /// No description provided for @red.
  ///
  /// In en, this message translates to:
  /// **'Red'**
  String get red;

  /// No description provided for @teal.
  ///
  /// In en, this message translates to:
  /// **'Teal'**
  String get teal;

  /// No description provided for @lessonPlayback.
  ///
  /// In en, this message translates to:
  /// **'Lesson Playback'**
  String get lessonPlayback;

  /// No description provided for @autoplayNextLesson.
  ///
  /// In en, this message translates to:
  /// **'Autoplay Next Lesson'**
  String get autoplayNextLesson;

  /// No description provided for @autoplayDescription.
  ///
  /// In en, this message translates to:
  /// **'Automatically play the next lesson'**
  String get autoplayDescription;

  /// No description provided for @playbackSpeed.
  ///
  /// In en, this message translates to:
  /// **'Playback Speed'**
  String get playbackSpeed;

  /// No description provided for @playbackSpeedDescription.
  ///
  /// In en, this message translates to:
  /// **'Default speed for video lessons'**
  String get playbackSpeedDescription;

  /// No description provided for @quizSettings.
  ///
  /// In en, this message translates to:
  /// **'Quiz Settings'**
  String get quizSettings;

  /// No description provided for @confirmBeforeSubmitting.
  ///
  /// In en, this message translates to:
  /// **'Confirm Before Submitting'**
  String get confirmBeforeSubmitting;

  /// No description provided for @confirmSubmissionDescription.
  ///
  /// In en, this message translates to:
  /// **'Show confirmation dialog before submitting quiz answers'**
  String get confirmSubmissionDescription;

  /// No description provided for @continueStudying.
  ///
  /// In en, this message translates to:
  /// **'Continue Studying'**
  String get continueStudying;

  /// No description provided for @continueStudyingDescription.
  ///
  /// In en, this message translates to:
  /// **'What to show when you tap \'Continue Studying\''**
  String get continueStudyingDescription;

  /// No description provided for @lastCourse.
  ///
  /// In en, this message translates to:
  /// **'Last Course'**
  String get lastCourse;

  /// No description provided for @lastLesson.
  ///
  /// In en, this message translates to:
  /// **'Last Lesson'**
  String get lastLesson;

  /// No description provided for @downloadSettings.
  ///
  /// In en, this message translates to:
  /// **'Download Settings'**
  String get downloadSettings;

  /// No description provided for @wifiOnlyDownloads.
  ///
  /// In en, this message translates to:
  /// **'Wi-Fi Only Downloads'**
  String get wifiOnlyDownloads;

  /// No description provided for @wifiOnlyDescription.
  ///
  /// In en, this message translates to:
  /// **'Only download content when connected to Wi-Fi'**
  String get wifiOnlyDescription;

  /// No description provided for @cacheManagement.
  ///
  /// In en, this message translates to:
  /// **'Cache Management'**
  String get cacheManagement;

  /// No description provided for @cacheSize.
  ///
  /// In en, this message translates to:
  /// **'Cache Size'**
  String get cacheSize;

  /// No description provided for @cacheSizeDescription.
  ///
  /// In en, this message translates to:
  /// **'Temporary files stored on your device'**
  String get cacheSizeDescription;

  /// No description provided for @clearCache.
  ///
  /// In en, this message translates to:
  /// **'Clear Cache'**
  String get clearCache;

  /// No description provided for @clearCacheDescription.
  ///
  /// In en, this message translates to:
  /// **'Free up storage space'**
  String get clearCacheDescription;

  /// No description provided for @clearCacheConfirmation.
  ///
  /// In en, this message translates to:
  /// **'This will clear all cached data. Are you sure?'**
  String get clearCacheConfirmation;

  /// No description provided for @clear.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get clear;

  /// No description provided for @cacheCleared.
  ///
  /// In en, this message translates to:
  /// **'Cache cleared successfully'**
  String get cacheCleared;

  /// No description provided for @errorClearingCache.
  ///
  /// In en, this message translates to:
  /// **'Error clearing cache'**
  String get errorClearingCache;

  /// No description provided for @dataBackup.
  ///
  /// In en, this message translates to:
  /// **'Data Backup'**
  String get dataBackup;

  /// No description provided for @exportNotes.
  ///
  /// In en, this message translates to:
  /// **'Export Notes'**
  String get exportNotes;

  /// No description provided for @exportNotesDescription.
  ///
  /// In en, this message translates to:
  /// **'Save your notes as a JSON file'**
  String get exportNotesDescription;

  /// No description provided for @importNotes.
  ///
  /// In en, this message translates to:
  /// **'Import Notes'**
  String get importNotes;

  /// No description provided for @importNotesDescription.
  ///
  /// In en, this message translates to:
  /// **'Restore notes from a JSON file'**
  String get importNotesDescription;

  /// No description provided for @notesExported.
  ///
  /// In en, this message translates to:
  /// **'Notes exported successfully'**
  String get notesExported;

  /// No description provided for @notesImported.
  ///
  /// In en, this message translates to:
  /// **'Notes imported successfully'**
  String get notesImported;

  /// No description provided for @errorExportingNotes.
  ///
  /// In en, this message translates to:
  /// **'Error exporting notes'**
  String get errorExportingNotes;

  /// No description provided for @errorImportingNotes.
  ///
  /// In en, this message translates to:
  /// **'Error importing notes'**
  String get errorImportingNotes;

  /// No description provided for @profileVisibility.
  ///
  /// In en, this message translates to:
  /// **'Profile Visibility'**
  String get profileVisibility;

  /// No description provided for @profileVisibilityDescription.
  ///
  /// In en, this message translates to:
  /// **'Who can see your profile information'**
  String get profileVisibilityDescription;

  /// No description provided for @activitySettings.
  ///
  /// In en, this message translates to:
  /// **'Activity Settings'**
  String get activitySettings;

  /// No description provided for @showActivityStatus.
  ///
  /// In en, this message translates to:
  /// **'Show Activity Status'**
  String get showActivityStatus;

  /// No description provided for @activityStatusDescription.
  ///
  /// In en, this message translates to:
  /// **'Let others see when you\'re online'**
  String get activityStatusDescription;

  /// No description provided for @blockedUsers.
  ///
  /// In en, this message translates to:
  /// **'Blocked Users'**
  String get blockedUsers;

  /// No description provided for @noBlockedUsers.
  ///
  /// In en, this message translates to:
  /// **'No Blocked Users'**
  String get noBlockedUsers;

  /// No description provided for @noBlockedUsersDescription.
  ///
  /// In en, this message translates to:
  /// **'You haven\'t blocked anyone yet'**
  String get noBlockedUsersDescription;

  /// No description provided for @blockedUser.
  ///
  /// In en, this message translates to:
  /// **'Blocked user'**
  String get blockedUser;

  /// No description provided for @unblock.
  ///
  /// In en, this message translates to:
  /// **'Unblock'**
  String get unblock;

  /// No description provided for @blockedUsersNote.
  ///
  /// In en, this message translates to:
  /// **'Blocked users cannot see your profile or contact you'**
  String get blockedUsersNote;

  /// No description provided for @campusOnly.
  ///
  /// In en, this message translates to:
  /// **'Campus Only'**
  String get campusOnly;

  /// No description provided for @campusOnlyDescription.
  ///
  /// In en, this message translates to:
  /// **'Only students and staff from your institution'**
  String get campusOnlyDescription;

  /// No description provided for @publicProfile.
  ///
  /// In en, this message translates to:
  /// **'Public'**
  String get publicProfile;

  /// No description provided for @publicProfileDescription.
  ///
  /// In en, this message translates to:
  /// **'Anyone can see your profile'**
  String get publicProfileDescription;

  /// No description provided for @privateProfile.
  ///
  /// In en, this message translates to:
  /// **'Private'**
  String get privateProfile;

  /// No description provided for @privateProfileDescription.
  ///
  /// In en, this message translates to:
  /// **'Only you can see your profile'**
  String get privateProfileDescription;

  /// No description provided for @support.
  ///
  /// In en, this message translates to:
  /// **'Support'**
  String get support;

  /// No description provided for @faq.
  ///
  /// In en, this message translates to:
  /// **'FAQ'**
  String get faq;

  /// No description provided for @frequentlyAskedQuestions.
  ///
  /// In en, this message translates to:
  /// **'Frequently asked questions'**
  String get frequentlyAskedQuestions;

  /// No description provided for @contactSupport.
  ///
  /// In en, this message translates to:
  /// **'Contact Support'**
  String get contactSupport;

  /// No description provided for @getHelpFromTeam.
  ///
  /// In en, this message translates to:
  /// **'Get help from our team'**
  String get getHelpFromTeam;

  /// No description provided for @reportBug.
  ///
  /// In en, this message translates to:
  /// **'Report Bug'**
  String get reportBug;

  /// No description provided for @reportIssueOrBug.
  ///
  /// In en, this message translates to:
  /// **'Report an issue or bug'**
  String get reportIssueOrBug;

  /// No description provided for @legal.
  ///
  /// In en, this message translates to:
  /// **'Legal'**
  String get legal;

  /// No description provided for @termsOfService.
  ///
  /// In en, this message translates to:
  /// **'Terms of Service'**
  String get termsOfService;

  /// No description provided for @readTermsOfService.
  ///
  /// In en, this message translates to:
  /// **'Read our terms of service'**
  String get readTermsOfService;

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicy;

  /// No description provided for @readPrivacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Read our privacy policy'**
  String get readPrivacyPolicy;

  /// No description provided for @openSourceLicenses.
  ///
  /// In en, this message translates to:
  /// **'Open Source Licenses'**
  String get openSourceLicenses;

  /// No description provided for @viewThirdPartyLicenses.
  ///
  /// In en, this message translates to:
  /// **'View third-party licenses'**
  String get viewThirdPartyLicenses;

  /// No description provided for @followUs.
  ///
  /// In en, this message translates to:
  /// **'Follow Us'**
  String get followUs;

  /// No description provided for @website.
  ///
  /// In en, this message translates to:
  /// **'Website'**
  String get website;

  /// No description provided for @version.
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get version;

  /// No description provided for @appDescription.
  ///
  /// In en, this message translates to:
  /// **'Your comprehensive learning companion for academic success'**
  String get appDescription;

  /// No description provided for @authSignInTitle.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get authSignInTitle;

  /// No description provided for @authSignInSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Sign in to continue your learning journey'**
  String get authSignInSubtitle;

  /// No description provided for @authSignUpTitle.
  ///
  /// In en, this message translates to:
  /// **'Create a New Account'**
  String get authSignUpTitle;

  /// No description provided for @authSignUpSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Create your account and start learning'**
  String get authSignUpSubtitle;

  /// No description provided for @authForgetPasswordTitle.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password'**
  String get authForgetPasswordTitle;

  /// No description provided for @authForgetPasswordSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enter your email to receive a reset link'**
  String get authForgetPasswordSubtitle;

  /// No description provided for @authUpdateProfileTitle.
  ///
  /// In en, this message translates to:
  /// **'Update Profile'**
  String get authUpdateProfileTitle;

  /// No description provided for @authUpdateProfileSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Update your account information'**
  String get authUpdateProfileSubtitle;

  /// No description provided for @authEmailLabel.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get authEmailLabel;

  /// No description provided for @authEmailHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your email'**
  String get authEmailHint;

  /// No description provided for @authEnterEmail.
  ///
  /// In en, this message translates to:
  /// **'Please enter your email'**
  String get authEnterEmail;

  /// No description provided for @authEnterValidEmail.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email'**
  String get authEnterValidEmail;

  /// No description provided for @authPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get authPasswordLabel;

  /// No description provided for @authPasswordHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your password'**
  String get authPasswordHint;

  /// No description provided for @authEnterPassword.
  ///
  /// In en, this message translates to:
  /// **'Please enter your password'**
  String get authEnterPassword;

  /// No description provided for @authPasswordMinChars.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters'**
  String get authPasswordMinChars;

  /// No description provided for @authConfirmPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get authConfirmPasswordLabel;

  /// No description provided for @authConfirmPasswordHint.
  ///
  /// In en, this message translates to:
  /// **'Re-enter your password'**
  String get authConfirmPasswordHint;

  /// No description provided for @authConfirmPasswordRequired.
  ///
  /// In en, this message translates to:
  /// **'Please confirm your password'**
  String get authConfirmPasswordRequired;

  /// No description provided for @authPasswordsDoNotMatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get authPasswordsDoNotMatch;

  /// No description provided for @authFullNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get authFullNameLabel;

  /// No description provided for @authFullNameHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your full name'**
  String get authFullNameHint;

  /// No description provided for @authEnterName.
  ///
  /// In en, this message translates to:
  /// **'Please enter your name'**
  String get authEnterName;

  /// No description provided for @authNameMinChars.
  ///
  /// In en, this message translates to:
  /// **'Name must be at least 2 characters'**
  String get authNameMinChars;

  /// No description provided for @authOr.
  ///
  /// In en, this message translates to:
  /// **'Or'**
  String get authOr;

  /// No description provided for @authForgotPasswordLink.
  ///
  /// In en, this message translates to:
  /// **'Forgot password?'**
  String get authForgotPasswordLink;

  /// No description provided for @authGoogleSignIn.
  ///
  /// In en, this message translates to:
  /// **'Continue with Google'**
  String get authGoogleSignIn;

  /// No description provided for @authCreateAccountButton.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get authCreateAccountButton;

  /// No description provided for @authSignInButton.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get authSignInButton;

  /// No description provided for @authSendResetLink.
  ///
  /// In en, this message translates to:
  /// **'Send reset link'**
  String get authSendResetLink;

  /// No description provided for @authResetLinkSent.
  ///
  /// In en, this message translates to:
  /// **'Password reset link sent'**
  String get authResetLinkSent;

  /// No description provided for @studyYearLabel.
  ///
  /// In en, this message translates to:
  /// **'Academic Year'**
  String get studyYearLabel;

  /// No description provided for @studyYearHint.
  ///
  /// In en, this message translates to:
  /// **'Select academic year'**
  String get studyYearHint;

  /// No description provided for @studyYearRequired.
  ///
  /// In en, this message translates to:
  /// **'Please select academic year'**
  String get studyYearRequired;

  /// No description provided for @departmentLabel.
  ///
  /// In en, this message translates to:
  /// **'Department'**
  String get departmentLabel;

  /// No description provided for @departmentHint.
  ///
  /// In en, this message translates to:
  /// **'Select department'**
  String get departmentHint;

  /// No description provided for @signInFooterNoAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get signInFooterNoAccount;

  /// No description provided for @signInFooterCreateAccount.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get signInFooterCreateAccount;

  /// No description provided for @signUpFooterHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get signUpFooterHaveAccount;

  /// No description provided for @signUpFooterSignIn.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get signUpFooterSignIn;

  /// No description provided for @profileNewPasswordOptional.
  ///
  /// In en, this message translates to:
  /// **'New Password (optional)'**
  String get profileNewPasswordOptional;

  /// No description provided for @profileMin6Chars.
  ///
  /// In en, this message translates to:
  /// **'Min 6 chars'**
  String get profileMin6Chars;

  /// No description provided for @profileSaveChanges.
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get profileSaveChanges;

  /// No description provided for @authNoAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get authNoAccount;

  /// No description provided for @authHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get authHaveAccount;

  /// No description provided for @authInvalidEmail.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email address'**
  String get authInvalidEmail;

  /// No description provided for @authPasswordTooShort.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters'**
  String get authPasswordTooShort;

  /// No description provided for @authFullNameEmpty.
  ///
  /// In en, this message translates to:
  /// **'Please enter your full name'**
  String get authFullNameEmpty;

  /// No description provided for @authFullNameTooShort.
  ///
  /// In en, this message translates to:
  /// **'Name must be at least 2 characters'**
  String get authFullNameTooShort;

  /// No description provided for @authEmailEmpty.
  ///
  /// In en, this message translates to:
  /// **'Please enter your email'**
  String get authEmailEmpty;

  /// No description provided for @authPasswordEmpty.
  ///
  /// In en, this message translates to:
  /// **'Please enter your password'**
  String get authPasswordEmpty;

  /// No description provided for @authConfirmPasswordEmpty.
  ///
  /// In en, this message translates to:
  /// **'Please confirm your password'**
  String get authConfirmPasswordEmpty;

  /// No description provided for @authPasswordMismatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get authPasswordMismatch;

  /// Error message when user data fails to load
  ///
  /// In en, this message translates to:
  /// **'Error loading user data'**
  String get userDataLoadError;

  /// Message when user data is not loaded
  ///
  /// In en, this message translates to:
  /// **'User data not loaded'**
  String get userDataNotLoaded;

  /// Label for study year
  ///
  /// In en, this message translates to:
  /// **'Year'**
  String get year;

  /// Software Engineering department name
  ///
  /// In en, this message translates to:
  /// **'Software Engineering'**
  String get softwareEngineering;

  /// Cyber Security department name
  ///
  /// In en, this message translates to:
  /// **'Cyber Security'**
  String get cyberSecurity;

  /// Shortcuts section title
  ///
  /// In en, this message translates to:
  /// **'Shortcuts'**
  String get shortcuts;

  /// Coming soon message for saved posts
  ///
  /// In en, this message translates to:
  /// **'Coming Soon: Saved Posts'**
  String get comingSoonSavedPosts;

  /// Coming soon message for my reports
  ///
  /// In en, this message translates to:
  /// **'Coming Soon: My Reports'**
  String get comingSoonMyReports;

  /// My reports shortcut title
  ///
  /// In en, this message translates to:
  /// **'My Reports'**
  String get myReports;

  /// Theme and colors settings title
  ///
  /// In en, this message translates to:
  /// **'Theme & Colors'**
  String get themeAndColors;

  /// Subtitle for theme settings
  ///
  /// In en, this message translates to:
  /// **'Customize app appearance'**
  String get customizeAppAppearance;

  /// Dark mode setting label
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get darkMode;

  /// App color setting label
  ///
  /// In en, this message translates to:
  /// **'App Color'**
  String get appColor;

  /// More button text for color picker
  ///
  /// In en, this message translates to:
  /// **'More'**
  String get more;

  /// Reset button tooltip
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get reset;

  /// Color picker dialog title
  ///
  /// In en, this message translates to:
  /// **'Choose App Color'**
  String get chooseAppColor;

  /// Available colors section title in color picker
  ///
  /// In en, this message translates to:
  /// **'Available Colors'**
  String get availableColors;

  /// Cancel button text
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// Apply button text
  ///
  /// In en, this message translates to:
  /// **'Apply'**
  String get apply;

  /// Language setting label
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// Arabic language option
  ///
  /// In en, this message translates to:
  /// **'العربية'**
  String get arabic;

  /// English language option
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// Account settings title
  ///
  /// In en, this message translates to:
  /// **'Account Settings'**
  String get accountSettings;

  /// Account settings subtitle
  ///
  /// In en, this message translates to:
  /// **'Manage your account and data'**
  String get manageAccountData;

  /// Update data option
  ///
  /// In en, this message translates to:
  /// **'Update Data'**
  String get updateData;

  /// Coming soon message for update data
  ///
  /// In en, this message translates to:
  /// **'Coming Soon: Update Data'**
  String get comingSoonUpdateData;

  /// Logout option
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// Logout confirmation message
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to logout?'**
  String get logoutConfirmation;

  /// Notifications settings subtitle
  ///
  /// In en, this message translates to:
  /// **'Manage notifications and alerts'**
  String get manageNotifications;

  /// View notifications option
  ///
  /// In en, this message translates to:
  /// **'View Notifications'**
  String get viewNotifications;

  /// Notification settings option
  ///
  /// In en, this message translates to:
  /// **'Notification Settings'**
  String get notificationSettings;

  /// Coming soon message for notification settings
  ///
  /// In en, this message translates to:
  /// **'Coming Soon: Notification Settings'**
  String get comingSoonNotificationSettings;

  /// Additional settings title
  ///
  /// In en, this message translates to:
  /// **'Additional Settings'**
  String get additionalSettings;

  /// Additional settings subtitle
  ///
  /// In en, this message translates to:
  /// **'More options and settings'**
  String get moreOptionsSettings;

  /// Help and support option
  ///
  /// In en, this message translates to:
  /// **'Help & Support'**
  String get helpSupport;

  /// Coming soon message for help and support
  ///
  /// In en, this message translates to:
  /// **'Coming Soon: Help & Support'**
  String get comingSoonHelpSupport;

  /// About app option
  ///
  /// In en, this message translates to:
  /// **'About App'**
  String get aboutApp;

  /// Coming soon message for about app
  ///
  /// In en, this message translates to:
  /// **'Coming Soon: About App'**
  String get comingSoonAboutApp;

  /// Privacy and security option
  ///
  /// In en, this message translates to:
  /// **'Privacy & Security'**
  String get privacySecurity;

  /// Coming soon message for privacy and security
  ///
  /// In en, this message translates to:
  /// **'Coming Soon: Privacy & Security'**
  String get comingSoonPrivacySecurity;

  /// Title for references empty state
  ///
  /// In en, this message translates to:
  /// **'No References Found'**
  String get referencesEmptyTitle;

  /// Subtitle for references empty state
  ///
  /// In en, this message translates to:
  /// **'You haven\'t added any references yet.'**
  String get referencesEmptySubtitle;

  /// Title for references empty state
  ///
  /// In en, this message translates to:
  /// **'No References Found'**
  String get referencesEmptyStateTitle;

  /// Subtitle for references empty state
  ///
  /// In en, this message translates to:
  /// **'You haven\'t added any references yet.'**
  String get referencesEmptyStateSubtitle;

  /// Title for grades empty state
  ///
  /// In en, this message translates to:
  /// **'No grades yet'**
  String get gradesEmptyTitle;

  /// Subtitle for grades empty state
  ///
  /// In en, this message translates to:
  /// **'Take the quizzes in the lessons to display your grades.'**
  String get gradesEmptySubtitle;

  /// Label for lesson prefix in grades list
  ///
  /// In en, this message translates to:
  /// **'Lesson'**
  String get lessonLabel;

  /// Title for courses page
  ///
  /// In en, this message translates to:
  /// **'Courses'**
  String get coursesTitle;

  /// Error message when courses fail to load
  ///
  /// In en, this message translates to:
  /// **'Error loading courses'**
  String get coursesErrorLoading;

  /// First semester tab
  ///
  /// In en, this message translates to:
  /// **'First Semester'**
  String get coursesFirstSemester;

  /// Second semester tab
  ///
  /// In en, this message translates to:
  /// **'Second Semester'**
  String get coursesSecondSemester;

  /// Other courses tab
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get coursesOther;

  /// Message when no courses are available
  ///
  /// In en, this message translates to:
  /// **'No courses available for this term.'**
  String get coursesEmptyMessage;

  /// Title for add retake courses page
  ///
  /// In en, this message translates to:
  /// **'Add Courses to Retake'**
  String get retakeCoursesTitle;

  /// Subtitle for add retake courses page
  ///
  /// In en, this message translates to:
  /// **'Select the courses you want to retake'**
  String get retakeCoursesSubtitle;

  /// Year label in course card
  ///
  /// In en, this message translates to:
  /// **'Year:'**
  String get retakeCoursesYear;

  /// Semester label in course card
  ///
  /// In en, this message translates to:
  /// **'Semester:'**
  String get retakeCoursesSemester;

  /// Prompt to select courses for retake
  ///
  /// In en, this message translates to:
  /// **'Select courses to retake'**
  String get retakeCoursesSelectPrompt;

  /// Retake button text with count
  ///
  /// In en, this message translates to:
  /// **'Retake {count} courses'**
  String retakeCoursesRetakeCount(int count);

  /// Success message for saving courses
  ///
  /// In en, this message translates to:
  /// **'Courses saved successfully!'**
  String get retakeCoursesSavedSuccess;

  /// Error message with details
  ///
  /// In en, this message translates to:
  /// **'Error: {message}'**
  String retakeCoursesError(String message);

  /// Loading courses message
  ///
  /// In en, this message translates to:
  /// **'Loading courses...'**
  String get retakeCoursesLoading;

  /// General error message
  ///
  /// In en, this message translates to:
  /// **'Something went wrong'**
  String get retakeCoursesErrorGeneral;

  /// Close button
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get retakeCoursesClose;

  /// Message when no courses are available
  ///
  /// In en, this message translates to:
  /// **'No courses available'**
  String get retakeCoursesNoAvailable;

  /// Description when no courses are available for retake
  ///
  /// In en, this message translates to:
  /// **'There are no courses available for retake at this time.'**
  String get retakeCoursesNoAvailableDescription;

  /// Search courses hint text
  ///
  /// In en, this message translates to:
  /// **'Search courses...'**
  String get retakeCoursesSearchHint;

  /// Message when no lectures are available for the course
  ///
  /// In en, this message translates to:
  /// **'No lectures available for this course'**
  String get coursesContentNoLecturesAvailable;

  /// Download feature coming soon message
  ///
  /// In en, this message translates to:
  /// **'Download feature coming soon'**
  String get coursesContentDownloadFeatureComingSoon;

  /// Download button tooltip
  ///
  /// In en, this message translates to:
  /// **'Download'**
  String get coursesContentDownloadTooltip;

  /// Minutes unit
  ///
  /// In en, this message translates to:
  /// **'minutes'**
  String get coursesContentDurationMinutes;

  /// Lectures title
  ///
  /// In en, this message translates to:
  /// **'Lectures'**
  String get coursesContentLectures;

  /// Number of lectures
  ///
  /// In en, this message translates to:
  /// **'{count} lectures'**
  String coursesContentLecturesCount(int count);

  /// Progress text
  ///
  /// In en, this message translates to:
  /// **'Progress: '**
  String get coursesContentProgress;

  /// Progress current of total
  ///
  /// In en, this message translates to:
  /// **'{current} of {total}'**
  String coursesContentProgressOf(int current, int total);

  /// Lecture clicked message
  ///
  /// In en, this message translates to:
  /// **'Lecture {number} clicked'**
  String coursesContentLectureClicked(int number);

  /// Course resources title
  ///
  /// In en, this message translates to:
  /// **'Course Resources'**
  String get coursesContentCourseResources;

  /// Back button tooltip
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get coursesContentBackTooltip;

  /// Schedule and reminders
  ///
  /// In en, this message translates to:
  /// **'Schedule & Reminders'**
  String get coursesContentScheduleReminders;

  /// Lectures tab
  ///
  /// In en, this message translates to:
  /// **'Lectures'**
  String get coursesContentTabLectures;

  /// Grades tab
  ///
  /// In en, this message translates to:
  /// **'Grades'**
  String get coursesContentTabGrades;

  /// Notes tab
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get coursesContentTabNotes;

  /// References tab
  ///
  /// In en, this message translates to:
  /// **'References'**
  String get coursesContentTabReferences;

  /// About course tab
  ///
  /// In en, this message translates to:
  /// **'About Course'**
  String get coursesContentTabAboutCourse;

  /// Lecture description title
  ///
  /// In en, this message translates to:
  /// **'Lecture Description'**
  String get coursesContentLectureDescription;

  /// Show more button
  ///
  /// In en, this message translates to:
  /// **'Show More'**
  String get coursesContentShowMore;

  /// Show less button
  ///
  /// In en, this message translates to:
  /// **'Show Less'**
  String get coursesContentShowLess;

  /// Completed status
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get coursesContentLectureCompleted;

  /// Current status
  ///
  /// In en, this message translates to:
  /// **'Current'**
  String get coursesContentLectureCurrent;

  /// Lesson marked as completed message
  ///
  /// In en, this message translates to:
  /// **'Lesson marked as completed'**
  String get coursesContentLessonCompletedMessage;

  /// Completed tooltip
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get coursesContentCompletedTooltip;

  /// Mark as completed tooltip
  ///
  /// In en, this message translates to:
  /// **'Mark as completed'**
  String get coursesContentMarkAsCompletedTooltip;

  /// Duration in lesson info
  ///
  /// In en, this message translates to:
  /// **'Duration'**
  String get coursesContentLessonInfoDuration;

  /// Status in lesson info
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get coursesContentLessonInfoStatus;

  /// Completed status in lesson info
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get coursesContentLessonInfoStatusCompleted;

  /// Not completed status in lesson info
  ///
  /// In en, this message translates to:
  /// **'Not completed'**
  String get coursesContentLessonInfoStatusNotCompleted;

  /// Lesson summary
  ///
  /// In en, this message translates to:
  /// **'Lesson Summary'**
  String get coursesContentLessonSummary;

  /// Tags
  ///
  /// In en, this message translates to:
  /// **'Tags'**
  String get coursesContentLessonTags;

  /// Additional information
  ///
  /// In en, this message translates to:
  /// **'Additional Information'**
  String get coursesContentAdditionalInfo;

  /// Downloadable
  ///
  /// In en, this message translates to:
  /// **'Downloadable'**
  String get coursesContentDownloadable;

  /// Yes
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get coursesContentYes;

  /// No
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get coursesContentNo;

  /// Creator
  ///
  /// In en, this message translates to:
  /// **'Creator'**
  String get coursesContentCreator;

  /// Published date
  ///
  /// In en, this message translates to:
  /// **'Published Date'**
  String get coursesContentPublishedDate;

  /// Last updated
  ///
  /// In en, this message translates to:
  /// **'Last Updated'**
  String get coursesContentLastUpdated;

  /// Lecture progress
  ///
  /// In en, this message translates to:
  /// **'Lecture Progress'**
  String get coursesContentModuleProgress;

  /// All lessons completed message
  ///
  /// In en, this message translates to:
  /// **'All lessons completed successfully! 🎉'**
  String get coursesContentAllLessonsCompleted;

  /// Continue learning message
  ///
  /// In en, this message translates to:
  /// **'Continue learning to complete the lecture'**
  String get coursesContentContinueLearning;

  /// Excellent completion message
  ///
  /// In en, this message translates to:
  /// **'Excellent! You have completed this lecture with distinction'**
  String get coursesContentExcellentCompletion;

  /// Add category label
  ///
  /// In en, this message translates to:
  /// **'Add Category'**
  String get categoryInputAddCategory;

  /// Text copied confirmation message
  ///
  /// In en, this message translates to:
  /// **'Text copied to clipboard'**
  String get postCardTextCopied;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar': return AppLocalizationsAr();
    case 'en': return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
