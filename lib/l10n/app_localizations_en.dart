// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get homeGreeting => 'Hello Aboud';

  @override
  String get homeContinueLearning => 'Continue learning, you\'re makeing your future';

  @override
  String get homeLatestNewsAndEvents => 'Latest News and Events';

  @override
  String get homeNoNewsAvailable => 'No news available';

  @override
  String get homeAnotherNewsItem => 'Another News Item';

  @override
  String get homeNewsDescription => 'Description for the second news item goes here.';

  @override
  String get homeThirdEvent => 'Third Event';

  @override
  String get homeThirdEventDetails => 'Details about the third event happening soon.';

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
  String get homeAdvancedSoftwareEngineering => 'Advanced Software Engineering - Chapter 3';

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
  String get todoAddFirstTask => 'Add your first task by tapping the + button below';

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
  String get quizEmptyTryAnotherLesson => 'Please check back later or try another lesson.';

  @override
  String get quizErrorTitle => 'Oops! Something went wrong.';

  @override
  String get quizErrorBody => 'We couldn\'t load the quiz. Please try again later.';

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
  String get todoDeleteConfirmation => 'Are you sure you want to delete this item?';

  @override
  String get todoCancel => 'Cancel';

  @override
  String get todoDelete => 'Delete';

  @override
  String errorCouldNotLaunch(Object url) {
    return 'Could not launch $url';
  }

  @override
  String get postsFeedTitle => 'Feed';

  @override
  String get postsWelcomeToFeed => 'Welcome to the Feed';

  @override
  String get postsNoPostsAvailable => 'No posts available';

  @override
  String get postsLoadingMorePosts => 'Loading more posts...';

  @override
  String get postsEndReachedTitle => 'You\'re all caught up!';

  @override
  String get postsEndReachedSubtitle => 'No more posts to load';

  @override
  String get createPostAppBarTitlePost => 'Create Post';

  @override
  String get createPostAppBarTitleArticle => 'Create Article';

  @override
  String get createPostPreview => 'Preview';

  @override
  String get createPostPlaceholder => 'What\'s on your mind?';

  @override
  String get createPostPhoto => 'Photo';

  @override
  String get createPostPost => 'Post';

  @override
  String get createPostArticle => 'Article';

  @override
  String get createPostPostType => 'Post Type';

  @override
  String get createPostValidationEnterContent => 'Please enter some content';

  @override
  String get createPostAddContentToPreview => 'Add some content to preview';

  @override
  String get imageSectionTitle => 'Image';

  @override
  String get imageSectionAddImage => 'Add Image';

  @override
  String get imageSectionCamera => 'Camera';

  @override
  String get imageSectionGallery => 'Gallery';

  @override
  String get commonChange => 'Change';

  @override
  String get commonRemove => 'Remove';

  @override
  String get createPostTextFieldArticleContent => 'Article Content';

  @override
  String get createPostTextFieldArticleHint => 'Write your article content here...';

  @override
  String get createPostTextFieldPostHint => 'Share your thoughts...';

  @override
  String get commentsEmptyTitle => 'Start the conversation';

  @override
  String get commentsEmptySubtitle => 'Be the first to share your thoughts\nand get the discussion going!';

  @override
  String get commentsEmptyHint => 'Write your comment below';

  @override
  String get commentsHeaderTitle => 'Comments';

  @override
  String get commentsLoadingMore => 'Loading more comments...';

  @override
  String get addCommentHint => 'Add a thoughtful comment...';

  @override
  String get addCommentSendTooltip => 'Send comment';

  @override
  String get postCardCopied => 'Text copied to clipboard';

  @override
  String get postCardShare => 'Share';

  @override
  String get postCardSharePost => 'Share Post';

  @override
  String get postCardCopyLink => 'Copy Link';

  @override
  String get postCardShareVia => 'Share via...';

  @override
  String get postCardLinkCopied => 'Link copied to clipboard';

  @override
  String get postCardMoreOptions => 'More options';

  @override
  String get postCardShowDetails => 'Show Details';

  @override
  String get postCardReadMore => 'Read more';

  @override
  String get postCategoryLabel => 'Categories';

  @override
  String get postCategoryHint => 'Add a category...';

  @override
  String get postImagePickerCoverOptional => 'Cover Image (Optional)';

  @override
  String get publishButtonPublishingArticle => 'Publishing...';

  @override
  String get publishButtonPosting => 'Posting...';

  @override
  String get publishButtonPublishArticle => 'Publish Article';

  @override
  String get publishButtonPost => 'Post';

  @override
  String get createPostSuccessArticle => 'Article published successfully!';

  @override
  String get createPostSuccessPost => 'Post created successfully!';

  @override
  String get unsavedChangesTitle => 'Discard changes?';

  @override
  String get unsavedChangesBody => 'You have unsaved changes that will be lost if you leave now.';

  @override
  String get unsavedChangesKeepEditing => 'Keep editing';

  @override
  String get unsavedChangesDiscard => 'Discard';

  @override
  String get topicsLabel => 'Topics';

  @override
  String get markdownHeader1 => 'Header 1';

  @override
  String get markdownHeader2 => 'Header 2';

  @override
  String get markdownHeader3 => 'Header 3';

  @override
  String get markdownBold => 'Bold';

  @override
  String get markdownItalic => 'Italic';

  @override
  String get markdownStrikethrough => 'Strikethrough';

  @override
  String get markdownInlineCode => 'Inline Code';

  @override
  String get markdownCodeBlock => 'Code Block';

  @override
  String get markdownUnorderedList => 'Unordered List';

  @override
  String get markdownOrderedList => 'Ordered List';

  @override
  String get markdownQuote => 'Quote';

  @override
  String get markdownLink => 'Link';

  @override
  String get markdownImage => 'Image';

  @override
  String get markdownHorizontalRule => 'Horizontal Rule';

  @override
  String get editProfile => 'Edit Profile';

  @override
  String get fullName => 'Full Name';

  @override
  String get fullNameRequired => 'Full name is required';

  @override
  String get academicYear => 'Academic Year';

  @override
  String get academicYearRequired => 'Academic year is required';

  @override
  String get department => 'Department';

  @override
  String get departmentRequired => 'Department is required';

  @override
  String get phoneNumber => 'Phone Number';

  @override
  String get optional => 'Optional';

  @override
  String get invalidPhoneNumber => 'Invalid phone number';

  @override
  String get bio => 'Bio';

  @override
  String get save => 'Save';

  @override
  String get saveChanges => 'Save Changes';

  @override
  String get profileUpdatedSuccessfully => 'Profile updated successfully';

  @override
  String get tapToChangePhoto => 'Tap to change photo';

  @override
  String get signOut => 'Sign Out';

  @override
  String get signOutConfirmation => 'Are you sure you want to sign out?';

  @override
  String get studyYearLabel => 'Study Year';

  @override
  String get studyYearHint => 'Select your study year';

  @override
  String get studyYearValidation => 'Please select your study year';

  @override
  String get studyYear1 => 'First Year';

  @override
  String get studyYear2 => 'Second Year';

  @override
  String get studyYear3 => 'Third Year';

  @override
  String get studyYear4 => 'Fourth Year';

  @override
  String get departmentLabel => 'Department';

  @override
  String get departmentHint => 'Select your department';

  @override
  String get departmentValidation => 'Please select your department';

  @override
  String get departmentCS => 'Computer Science';

  @override
  String get departmentIT => 'Information Technology';

  @override
  String get quickActions => 'Quick Actions';

  @override
  String get myCourses => 'My Courses';

  @override
  String get myNotes => 'My Notes';

  @override
  String get viewAndEdit => 'View and edit';

  @override
  String get savedPosts => 'Saved Posts';

  @override
  String get yourBookmarks => 'Your bookmarks';

  @override
  String get reminders => 'Reminders';

  @override
  String get upcomingTasks => 'Upcoming tasks';

  @override
  String get settings => 'Settings';

  @override
  String get accountAndSecurity => 'Account & Security';

  @override
  String get profilePasswordSessions => 'Profile, password, sessions';

  @override
  String get notifications => 'Notifications';

  @override
  String get manageNotificationPreferences => 'Manage notification preferences';

  @override
  String get email => 'Email';

  @override
  String get emailRequired => 'Email is required';

  @override
  String get newPassword => 'New Password';

  @override
  String get passwordMinLength => 'Minimum 6 characters';

  @override
  String get appearance => 'Appearance';

  @override
  String get themeColorsFont => 'Theme, colors, font';

  @override
  String get languageAndRegion => 'Language & Region';

  @override
  String get languageDateFormat => 'Language, date format';

  @override
  String get studyPreferences => 'Study Preferences';

  @override
  String get autoplaySpeedQuizzes => 'Autoplay, speed, quizzes';

  @override
  String get dataAndStorage => 'Data & Storage';

  @override
  String get cacheDownloadsBackup => 'Cache, downloads, backup';

  @override
  String get privacy => 'Privacy';

  @override
  String get profileVisibilityBlocked => 'Profile visibility, blocked users';

  @override
  String get aboutAndSupport => 'About & Support';

  @override
  String get versionHelpContact => 'Version, help, contact';

  @override
  String get errorLoadingSettings => 'Error loading settings';

  @override
  String get generalNotifications => 'General Notifications';

  @override
  String get enableNotifications => 'Enable Notifications';

  @override
  String get receiveAllNotifications => 'Receive all notifications';

  @override
  String get categories => 'Categories';

  @override
  String get newsAndEvents => 'News & Events';

  @override
  String get updatesFromInstitution => 'Updates from institution';

  @override
  String get courseUpdates => 'Course Updates';

  @override
  String get newLessonsAssignments => 'New lessons and assignments';

  @override
  String get postsCommentsLikes => 'Posts, comments, and likes';

  @override
  String get studyRemindersDeadlines => 'Study reminders and deadlines';

  @override
  String get quietHours => 'Quiet Hours';

  @override
  String get quietHoursDescription => 'Set times when you don\'t want to receive notifications';

  @override
  String get startTime => 'Start Time';

  @override
  String get endTime => 'End Time';

  @override
  String get clearQuietHours => 'Clear Quiet Hours';

  @override
  String get themeMode => 'Theme Mode';

  @override
  String get systemTheme => 'System';

  @override
  String get lightTheme => 'Light';

  @override
  String get darkTheme => 'Dark';

  @override
  String get colors => 'Colors';

  @override
  String get dynamicColor => 'Dynamic Color';

  @override
  String get dynamicColorDescription => 'Use colors from your wallpaper';

  @override
  String get fontSize => 'Font Size';

  @override
  String get small => 'Small';

  @override
  String get normal => 'Normal';

  @override
  String get large => 'Large';

  @override
  String get fontSizePreview => 'This is how text will look';

  @override
  String get primaryColor => 'Primary Color';

  @override
  String get purple => 'Purple';

  @override
  String get blue => 'Blue';

  @override
  String get green => 'Green';

  @override
  String get orange => 'Orange';

  @override
  String get red => 'Red';

  @override
  String get teal => 'Teal';

  @override
  String get lessonPlayback => 'Lesson Playback';

  @override
  String get autoplayNextLesson => 'Autoplay Next Lesson';

  @override
  String get autoplayDescription => 'Automatically play the next lesson';

  @override
  String get playbackSpeed => 'Playback Speed';

  @override
  String get playbackSpeedDescription => 'Default speed for video lessons';

  @override
  String get quizSettings => 'Quiz Settings';

  @override
  String get confirmBeforeSubmitting => 'Confirm Before Submitting';

  @override
  String get confirmSubmissionDescription => 'Show confirmation dialog before submitting quiz answers';

  @override
  String get continueStudying => 'Continue Studying';

  @override
  String get continueStudyingDescription => 'What to show when you tap \'Continue Studying\'';

  @override
  String get lastCourse => 'Last Course';

  @override
  String get lastLesson => 'Last Lesson';

  @override
  String get downloadSettings => 'Download Settings';

  @override
  String get wifiOnlyDownloads => 'Wi-Fi Only Downloads';

  @override
  String get wifiOnlyDescription => 'Only download content when connected to Wi-Fi';

  @override
  String get cacheManagement => 'Cache Management';

  @override
  String get cacheSize => 'Cache Size';

  @override
  String get cacheSizeDescription => 'Temporary files stored on your device';

  @override
  String get clearCache => 'Clear Cache';

  @override
  String get clearCacheDescription => 'Free up storage space';

  @override
  String get clearCacheConfirmation => 'This will clear all cached data. Are you sure?';

  @override
  String get clear => 'Clear';

  @override
  String get cacheCleared => 'Cache cleared successfully';

  @override
  String get errorClearingCache => 'Error clearing cache';

  @override
  String get dataBackup => 'Data Backup';

  @override
  String get exportNotes => 'Export Notes';

  @override
  String get exportNotesDescription => 'Save your notes as a JSON file';

  @override
  String get importNotes => 'Import Notes';

  @override
  String get importNotesDescription => 'Restore notes from a JSON file';

  @override
  String get notesExported => 'Notes exported successfully';

  @override
  String get notesImported => 'Notes imported successfully';

  @override
  String get errorExportingNotes => 'Error exporting notes';

  @override
  String get errorImportingNotes => 'Error importing notes';

  @override
  String get profileVisibility => 'Profile Visibility';

  @override
  String get profileVisibilityDescription => 'Who can see your profile information';

  @override
  String get activitySettings => 'Activity Settings';

  @override
  String get showActivityStatus => 'Show Activity Status';

  @override
  String get activityStatusDescription => 'Let others see when you\'re online';

  @override
  String get blockedUsers => 'Blocked Users';

  @override
  String get noBlockedUsers => 'No Blocked Users';

  @override
  String get noBlockedUsersDescription => 'You haven\'t blocked anyone yet';

  @override
  String get blockedUser => 'Blocked user';

  @override
  String get unblock => 'Unblock';

  @override
  String get blockedUsersNote => 'Blocked users cannot see your profile or contact you';

  @override
  String get campusOnly => 'Campus Only';

  @override
  String get campusOnlyDescription => 'Only students and staff from your institution';

  @override
  String get publicProfile => 'Public';

  @override
  String get publicProfileDescription => 'Anyone can see your profile';

  @override
  String get privateProfile => 'Private';

  @override
  String get privateProfileDescription => 'Only you can see your profile';

  @override
  String get support => 'Support';

  @override
  String get faq => 'FAQ';

  @override
  String get frequentlyAskedQuestions => 'Frequently asked questions';

  @override
  String get contactSupport => 'Contact Support';

  @override
  String get getHelpFromTeam => 'Get help from our team';

  @override
  String get reportBug => 'Report Bug';

  @override
  String get reportIssueOrBug => 'Report an issue or bug';

  @override
  String get legal => 'Legal';

  @override
  String get termsOfService => 'Terms of Service';

  @override
  String get readTermsOfService => 'Read our terms of service';

  @override
  String get privacyPolicy => 'Privacy Policy';

  @override
  String get readPrivacyPolicy => 'Read our privacy policy';

  @override
  String get openSourceLicenses => 'Open Source Licenses';

  @override
  String get viewThirdPartyLicenses => 'View third-party licenses';

  @override
  String get followUs => 'Follow Us';

  @override
  String get website => 'Website';

  @override
  String get version => 'Version';

  @override
  String get appDescription => 'Your comprehensive learning companion for academic success';
}
