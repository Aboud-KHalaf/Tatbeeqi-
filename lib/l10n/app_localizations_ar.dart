// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get homeGreeting => 'تطبيقي';

  @override
  String get homeContinueLearning => 'واصل التعلم, انت تصنع مستقبلك';

  @override
  String get homeLatestNewsAndEvents => 'آخر الاخبار والاحداث';

  @override
  String get homeNoNewsAvailable => 'لا توجد أخبار متاحة';

  @override
  String get homeAnotherNewsItem => 'خبر آخر';

  @override
  String get homeNewsDescription => 'وصف للخبر الثاني هنا.';

  @override
  String get homeThirdEvent => 'الحدث الثالث';

  @override
  String get homeThirdEventDetails => 'تفاصيل حول الحدث الثالث القادم قريبًا.';

  @override
  String get homeTodayTasks => 'مهام اليوم';

  @override
  String get homeStartNewChallenge => 'ابدأ تحدي جديد اليوم';

  @override
  String get homeNoTasksForToday => 'لا توجد مهام لليوم!';

  @override
  String get homeReviewChapterOne => 'مراجعة الفصل الاول';

  @override
  String get homeSolveMathHomework => 'حل واجب الرياضيات';

  @override
  String get homeContinueStudying => 'تابع الدراسة';

  @override
  String get homeRecentlyAdded => 'المضافة مؤخرا';

  @override
  String get homeAdvancedSoftwareEngineering => 'هندسة برمجيات متقدمة - الفصل 3';

  @override
  String get seeAll => 'عرض الكل';

  @override
  String get navHome => 'الرئيسية';

  @override
  String get navCourses => 'المقررات';

  @override
  String get navCommunity => 'المجتمع';

  @override
  String get navMore => 'المزيد';

  @override
  String get todoMyToDos => 'مهامي';

  @override
  String get todoEditTask => 'تعديل المهمة';

  @override
  String get todoAddNewTask => 'اضافة مهمة جديدة';

  @override
  String get todoNoTasks => 'لا توجد مهام بعد';

  @override
  String get todoAddFirstTask => 'أضف مهمتك الأولى بالنقر على زر + أدناه';

  @override
  String get todoSetDueDate => 'تعيين تاريخ الاستحقاق (اختياري)';

  @override
  String todoDueDate(String date) {
    return 'الاستحقاق: $date';
  }

  @override
  String get todoUpdateTask => 'تحديث المهمة';

  @override
  String get todoAddTask => 'إضافة مهمة';

  @override
  String get todoMarkAsCompleted => 'وضع علامة كمكتمل';

  @override
  String get todoLoadingTasks => 'جاري تحميل المهام...';

  @override
  String get todoNoDataAvailable => 'لا توجد بيانات متاحة';

  @override
  String get newsNoNewsAvailable => 'لا توجد أخبار متاحة';

  @override
  String get newsCheckBackLater => 'تحقق لاحقًا للحصول على التحديثات';

  @override
  String get tryAgain => 'حاول مرة اخرى';

  @override
  String get quizTitle => 'الاختبار';

  @override
  String get quizResultsTitle => 'نتائج الاختبار';

  @override
  String get quizEmptyNoQuestions => 'لا توجد أسئلة متاحة لهذا الدرس بعد!';

  @override
  String get quizEmptyTryAnotherLesson => 'يرجى العودة لاحقًا أو تجربة درس آخر.';

  @override
  String get quizErrorTitle => 'حدث خطأ!';

  @override
  String get quizErrorBody => 'تعذر تحميل الاختبار. يرجى المحاولة مرة أخرى لاحقًا.';

  @override
  String get quizPrev => 'السابق';

  @override
  String get quizNext => 'السؤال التالي';

  @override
  String get quizSubmit => 'إرسال الاختبار';

  @override
  String quizProgressBar(Object current, Object total) {
    return 'السؤال $current من $total';
  }

  @override
  String get quizGoHome => 'العودة للرئيسية';

  @override
  String quizResultCardQuestion(Object number) {
    return 'السؤال $number';
  }

  @override
  String get quizResultCardYourAnswer => 'إجابتك: ';

  @override
  String get quizResultCardCorrectAnswer => 'الإجابة الصحيحة: ';

  @override
  String get quizResultCardNoAnswer => 'لم يتم اختيار إجابة';

  @override
  String get quizScoreSummaryTitle => 'درجتك';

  @override
  String quizScoreSummaryScore(Object score, Object total) {
    return '$score / $total';
  }

  @override
  String get quizScoreSummaryPassed => 'عمل رائع، لقد نجحت!';

  @override
  String get quizScoreSummaryTryAgain => 'استمر في المحاولة، ستنجح قريبًا!';

  @override
  String get todoTitle => 'العنوان';

  @override
  String get todoEnterTitle => 'الرجاء إدخال عنوان';

  @override
  String get todoDescription => 'الوصف';

  @override
  String get todoImportance => 'الأهمية';

  @override
  String get todoImportanceLow => 'منخفضة';

  @override
  String get todoImportanceMedium => 'متوسطة';

  @override
  String get todoImportanceHigh => 'عالية';

  @override
  String get todoNoDueDate => 'لا يوجد تاريخ استحقاق';

  @override
  String get todoConfirmDelete => 'تأكيد الحذف';

  @override
  String get todoDeleteConfirmation => 'هل أنت متأكد أنك تريد حذف هذا العنصر؟';

  @override
  String get todoCancel => 'إلغاء';

  @override
  String get todoDelete => 'حذف';

  @override
  String errorCouldNotLaunch(Object url) {
    return 'تعذر فتح الرابط $url';
  }

  @override
  String get postsFeedTitle => 'المجمتع';

  @override
  String get postsWelcomeToFeed => 'مرحبًا بك في صفحة المنشورات';

  @override
  String get postsNoPostsAvailable => 'لا توجد منشورات متاحة';

  @override
  String get postsLoadingMorePosts => 'جاري تحميل المزيد من المنشورات...';

  @override
  String get postsEndReachedTitle => 'لقد اطلعت على كل شيء!';

  @override
  String get postsEndReachedSubtitle => 'لا توجد منشورات أخرى للتحميل';

  @override
  String get createPostAppBarTitlePost => 'إنشاء منشور';

  @override
  String get createPostAppBarTitleArticle => 'إنشاء مقال';

  @override
  String get createPostPreview => 'معاينة';

  @override
  String get createPostPlaceholder => 'بماذا تفكر؟';

  @override
  String get createPostPhoto => 'صورة';

  @override
  String get createPostPost => 'منشور';

  @override
  String get createPostArticle => 'مقال';

  @override
  String get createPostPostType => 'نوع المنشور';

  @override
  String get createPostValidationEnterContent => 'الرجاء إدخال محتوى';

  @override
  String get createPostAddContentToPreview => 'أضف بعض المحتوى للمعاينة';

  @override
  String get imageSectionTitle => 'الصورة';

  @override
  String get imageSectionAddImage => 'إضافة صورة';

  @override
  String get imageSectionCamera => 'الكاميرا';

  @override
  String get imageSectionGallery => 'المعرض';

  @override
  String get commonChange => 'تغيير';

  @override
  String get commonRemove => 'إزالة';

  @override
  String get createPostTextFieldArticleContent => 'محتوى المقال';

  @override
  String get createPostTextFieldArticleHint => 'اكتب محتوى مقالك هنا...';

  @override
  String get createPostTextFieldPostHint => 'شارك أفكارك...';

  @override
  String get commentsEmptyTitle => 'ابدأ المحادثة';

  @override
  String get commentsEmptySubtitle => 'كن أول من يشارك رأيه\nولنبدأ النقاش!';

  @override
  String get commentsEmptyHint => 'اكتب تعليقك بالأسفل';

  @override
  String get commentsHeaderTitle => 'التعليقات';

  @override
  String get commentsLoadingMore => 'جاري تحميل المزيد من التعليقات...';

  @override
  String get addCommentHint => 'أضف تعليقًا مفيدًا...';

  @override
  String get addCommentSendTooltip => 'إرسال التعليق';

  @override
  String get postCardCopied => 'تم نسخ النص إلى الحافظة';

  @override
  String get postCardShare => 'مشاركة';

  @override
  String get postCardSharePost => 'مشاركة المنشور';

  @override
  String get postCardCopyLink => 'نسخ الرابط';

  @override
  String get postCardShareVia => 'المشاركة عبر...';

  @override
  String get postCardLinkCopied => 'تم نسخ الرابط إلى الحافظة';

  @override
  String get postCardMoreOptions => 'المزيد من الخيارات';

  @override
  String get postCardShowDetails => 'عرض التفاصيل';

  @override
  String get postCardReadMore => 'اقرأ المزيد';

  @override
  String get postCategoryLabel => 'الفئات';

  @override
  String get postCategoryHint => 'أضف فئة...';

  @override
  String get postImagePickerCoverOptional => 'صورة الغلاف (اختياري)';

  @override
  String get publishButtonPublishingArticle => 'جارٍ النشر...';

  @override
  String get publishButtonPosting => 'جارٍ الإرسال...';

  @override
  String get publishButtonPublishArticle => 'نشر المقال';

  @override
  String get publishButtonPost => 'إرسال';

  @override
  String get createPostSuccessArticle => 'تم نشر المقال بنجاح!';

  @override
  String get createPostSuccessPost => 'تم إنشاء المنشور بنجاح!';

  @override
  String get unsavedChangesTitle => 'هل تريد تجاهل التغييرات؟';

  @override
  String get unsavedChangesBody => 'لديك تغييرات غير محفوظة ستُفقد إذا غادرت الآن.';

  @override
  String get unsavedChangesKeepEditing => 'تابع التحرير';

  @override
  String get unsavedChangesDiscard => 'تجاهل';

  @override
  String get topicsLabel => 'المواضيع';

  @override
  String get markdownHeader1 => 'عنوان 1';

  @override
  String get markdownHeader2 => 'عنوان 2';

  @override
  String get markdownHeader3 => 'عنوان 3';

  @override
  String get markdownBold => 'عريض';

  @override
  String get markdownItalic => 'مائل';

  @override
  String get markdownStrikethrough => 'يتوسطه خط';

  @override
  String get markdownInlineCode => 'كود ضمني';

  @override
  String get markdownCodeBlock => 'كتلة كود';

  @override
  String get markdownUnorderedList => 'قائمة غير مرتبة';

  @override
  String get markdownOrderedList => 'قائمة مرتبة';

  @override
  String get markdownQuote => 'اقتباس';

  @override
  String get markdownLink => 'رابط';

  @override
  String get markdownImage => 'صورة';

  @override
  String get markdownHorizontalRule => 'فاصل أفقي';

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
  String get department => 'قسم';

  @override
  String get departmentRequired => 'يرجى اختيار القسم';

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
  String get profileUpdatedSuccessfully => 'Profile updated successfully';

  @override
  String get tapToChangePhoto => 'Tap to change photo';

  @override
  String get signOut => 'Sign Out';

  @override
  String get signOutConfirmation => 'Are you sure you want to sign out?';

  @override
  String get quickActions => 'Quick Actions';

  @override
  String get myCourses => 'My Courses';

  @override
  String get myNotes => 'My Notes';

  @override
  String get viewAndEdit => 'View and edit';

  @override
  String get savedPosts => 'المحفوظات';

  @override
  String get yourBookmarks => 'Your bookmarks';

  @override
  String get reminders => 'Reminders';

  @override
  String get upcomingTasks => 'Upcoming tasks';

  @override
  String get settings => 'الإعدادات';

  @override
  String get accountAndSecurity => 'Account & Security';

  @override
  String get profilePasswordSessions => 'Profile, password, sessions';

  @override
  String get notifications => 'الإشعارات';

  @override
  String get manageNotificationPreferences => 'Manage notification preferences';

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

  @override
  String get authSignInTitle => 'تسجيل الدخول';

  @override
  String get authSignInSubtitle => 'سجل دخولك لمتابعة رحلتك التعليمية';

  @override
  String get authSignUpTitle => 'إنشاء حساب جديد';

  @override
  String get authSignUpSubtitle => 'أنشئ حسابك الجديد وابدأ رحلتك التعليمية';

  @override
  String get authForgetPasswordTitle => 'استعادة كلمة المرور';

  @override
  String get authForgetPasswordSubtitle => 'أدخل بريدك الإلكتروني لإرسال رابط الاستعادة';

  @override
  String get authUpdateProfileTitle => 'تحديث الملف الشخصي';

  @override
  String get authUpdateProfileSubtitle => 'قم بتحديث معلومات حسابك';

  @override
  String get authEmailLabel => 'البريد الإلكتروني';

  @override
  String get authEmailHint => 'أدخل بريدك الإلكتروني';

  @override
  String get authEnterEmail => 'يرجى إدخال البريد الإلكتروني';

  @override
  String get authEnterValidEmail => 'يرجى إدخال بريد إلكتروني صحيح';

  @override
  String get authPasswordLabel => 'كلمة المرور';

  @override
  String get authPasswordHint => 'أدخل كلمة المرور';

  @override
  String get authEnterPassword => 'يرجى إدخال كلمة المرور';

  @override
  String get authPasswordMinChars => 'كلمة المرور يجب أن تكون 6 أحرف على الأقل';

  @override
  String get authConfirmPasswordLabel => 'تأكيد كلمة المرور';

  @override
  String get authConfirmPasswordHint => 'أعد إدخال كلمة المرور';

  @override
  String get authConfirmPasswordRequired => 'يرجى تأكيد كلمة المرور';

  @override
  String get authPasswordsDoNotMatch => 'كلمة المرور غير متطابقة';

  @override
  String get authFullNameLabel => 'الاسم الكامل';

  @override
  String get authFullNameHint => 'أدخل اسمك الكامل';

  @override
  String get authEnterName => 'يرجى إدخال الاسم';

  @override
  String get authNameMinChars => 'الاسم يجب أن يكون حرفين على الأقل';

  @override
  String get authOr => 'أو';

  @override
  String get authForgotPasswordLink => 'نسيت كلمة المرور؟';

  @override
  String get authGoogleSignIn => 'المتابعة مع جوجل';

  @override
  String get authCreateAccountButton => 'إنشاء الحساب';

  @override
  String get authSignInButton => 'تسجيل الدخول';

  @override
  String get authSendResetLink => 'إرسال رابط الاستعادة';

  @override
  String get authResetLinkSent => 'تم إرسال رابط إعادة تعيين كلمة المرور';

  @override
  String get studyYearLabel => 'السنة الدراسية';

  @override
  String get studyYearHint => 'اختر السنة الدراسية';

  @override
  String get studyYearRequired => 'يرجى اختيار السنة الدراسية';

  @override
  String get departmentLabel => 'القسم';

  @override
  String get departmentHint => 'اختر القسم';

  @override
  String get signInFooterNoAccount => 'ليس لديك حساب؟';

  @override
  String get signInFooterCreateAccount => 'إنشاء حساب';

  @override
  String get signUpFooterHaveAccount => 'لديك حساب بالفعل؟';

  @override
  String get signUpFooterSignIn => 'تسجيل الدخول';

  @override
  String get profileNewPasswordOptional => 'كلمة مرور جديدة (اختياري)';

  @override
  String get profileMin6Chars => 'حد أدنى 6 أحرف';

  @override
  String get profileSaveChanges => 'حفظ التغييرات';

  @override
  String get authNoAccount => 'ليس لديك حساب؟';

  @override
  String get authHaveAccount => 'لديك حساب بالفعل؟';

  @override
  String get authInvalidEmail => 'يرجى إدخال عنوان بريد إلكتروني صالح';

  @override
  String get authPasswordTooShort => 'يجب أن تتكون كلمة المرور من 6 أحرف على الأقل';

  @override
  String get authFullNameEmpty => 'يرجى إدخال اسمك الكامل';

  @override
  String get authFullNameTooShort => 'يجب أن يتكون الاسم من حرفين على الأقل';

  @override
  String get authEmailEmpty => 'يرجى إدخال بريدك الإلكتروني';

  @override
  String get authPasswordEmpty => 'يرجى إدخال كلمة المرور الخاصة بك';

  @override
  String get authConfirmPasswordEmpty => 'يرجى تأكيد كلمة المرور الخاصة بك';

  @override
  String get authPasswordMismatch => 'كلمات المرور غير متطابقة';

  @override
  String get userDataLoadError => 'خطأ في تحميل بيانات المستخدم';

  @override
  String get userDataNotLoaded => 'لم يتم تحميل بيانات المستخدم';

  @override
  String get year => 'السنة';

  @override
  String get softwareEngineering => 'هندسة برمجيات';

  @override
  String get cyberSecurity => 'أمن سيبراني';

  @override
  String get shortcuts => 'الاختصارات';

  @override
  String get comingSoonSavedPosts => 'قريباً: المنشورات المحفوظة';

  @override
  String get comingSoonMyReports => 'قريباً: تقاريري';

  @override
  String get myReports => 'ابلاغاتي';

  @override
  String get themeAndColors => 'المظهر والألوان';

  @override
  String get customizeAppAppearance => 'تخصيص شكل التطبيق';

  @override
  String get darkMode => 'الوضع الليلي';

  @override
  String get appColor => 'لون التطبيق';

  @override
  String get more => 'المزيد';

  @override
  String get reset => 'إعادة تعيين';

  @override
  String get chooseAppColor => 'اختيار لون التطبيق';

  @override
  String get availableColors => 'الألوان المتاحة';

  @override
  String get cancel => 'إلغاء';

  @override
  String get apply => 'تطبيق';

  @override
  String get language => 'اللغة';

  @override
  String get arabic => 'العربية';

  @override
  String get english => 'English';

  @override
  String get accountSettings => 'إعدادات الحساب';

  @override
  String get manageAccountData => 'إدارة حسابك وبياناتك';

  @override
  String get updateData => 'تحديث البيانات';

  @override
  String get comingSoonUpdateData => 'قريباً: تحديث البيانات';

  @override
  String get logout => 'تسجيل الخروج';

  @override
  String get logoutConfirmation => 'هل أنت متأكد من رغبتك في تسجيل الخروج؟';

  @override
  String get manageNotifications => 'إدارة الإشعارات والتنبيهات';

  @override
  String get viewNotifications => 'عرض الإشعارات';

  @override
  String get notificationSettings => 'إعدادات الإشعارات';

  @override
  String get comingSoonNotificationSettings => 'قريباً: إعدادات الإشعارات';

  @override
  String get additionalSettings => 'إعدادات إضافية';

  @override
  String get moreOptionsSettings => 'المزيد من الخيارات والإعدادات';

  @override
  String get helpSupport => 'المساعدة والدعم';

  @override
  String get comingSoonHelpSupport => 'قريباً: المساعدة والدعم';

  @override
  String get aboutApp => 'حول التطبيق';

  @override
  String get comingSoonAboutApp => 'قريباً: حول التطبيق';

  @override
  String get privacySecurity => 'الخصوصية والأمان';

  @override
  String get comingSoonPrivacySecurity => 'قريباً: الخصوصية والأمان';

  @override
  String get referencesEmptyTitle => 'لا توجد مراجع';

  @override
  String get referencesEmptySubtitle => 'لم تتم إضافة أي مراجع بعد.';

  @override
  String get referencesEmptyStateTitle => 'No References Found';

  @override
  String get referencesEmptyStateSubtitle => 'You haven\'t added any references yet.';

  @override
  String get gradesEmptyTitle => 'لا توجد درجات حتى الآن';

  @override
  String get gradesEmptySubtitle => 'خذ الاختبارات في الدروس لعرض درجاتك.';

  @override
  String get lessonLabel => 'الدرس';
}
