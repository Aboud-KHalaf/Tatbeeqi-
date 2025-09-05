// ignore: depend_on_referenced_packages
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:tatbeeqi/core/utils/app_logger.dart';

const String _dbName = 'app_database.db'; // Renamed for more general use

// Todos Table
const String _todosTableName = 'todos';
const String _todosColId = 'id';
const String _todosColTitle = 'title';
const String _todosColDescription = 'description';
const String _todosColImportance = 'importance';
const String _todosColDueDate = 'dueDate';
const String _todosColIsCompleted = 'isCompleted';
const String _todosColOrderIndex = 'orderIndex';

// Courses Table
const String coursesTableName = 'courses';
const String coursesColId = 'id';
const String coursesColCourseCode = 'course_code';
const String coursesColCourseName = 'course_name';
const String coursesColDepartmentId = 'department_id';
const String coursesColStudyYear = 'study_year';
const String coursesColSemester = 'semester';
const String coursesColGradeTotal = 'grade_total';
const String coursesColGradeTheoreticalExam = 'grade_theoretical_exam';
const String coursesColWeeklyHoursTheory = 'weekly_hours_theory';
const String coursesColWeeklyHoursPractical = 'weekly_hours_practical';
const String coursesColWeeklyHoursTotal = 'weekly_hours_total';
const String coursesColGradeStudentWork = 'grade_student_work';
const String coursesColProgressPercent = 'progress_percent';

// Notes Table
const String notesTableName = 'notes';
const String notesColId = 'id';
const String notesColCourseId = 'course_id';
const String notesColTitle = 'title';
const String notesColContent = 'content';
const String notesColLastModified = 'last_modified';
const String notesColColor = 'color';

// Cached Posts Table
const String cachedPostsTableName = 'cached_posts';
const String cachedPostsColId = 'id';
const String cachedPostsColAuthorId = 'author_id';
const String cachedPostsColAuthorName = 'author_name';
const String cachedPostsColAuthorAvatarUrl = 'author_avatar_url';
const String cachedPostsColText = 'text';
const String cachedPostsColImageUrl = 'image_url';
const String cachedPostsColCategories = 'categories'; // Stored as JSON string
const String cachedPostsColCreatedAt = 'created_at';
const String cachedPostsColLikesCount = 'likes_count';
const String cachedPostsColCommentsCount = 'comments_count';
const String cachedPostsColIsArticle = 'is_article';
const String cachedPostsColIsLiked = 'is_liked';
const String cachedPostsColTopics = 'topics';

// Cached News Table
const String cachedNewsTableName = 'cached_news';
const String cachedNewsColId = 'id';
const String cachedNewsColTitle = 'title';
const String cachedNewsColContent = 'content';
const String cachedNewsColImageUrl = 'image_url';
const String cachedNewsColAuthor = 'author';
const String cachedNewsColPublicationDate = 'publication_date';
const String cachedNewsColCategory = 'category';
const String cachedNewsColDescription = 'description';

// Notifications Table (local cache)
const String notificationsTableName = 'notifications';
const String notificationsColLocalId = 'local_id'; // local autoincrement id
const String notificationsColId = 'id'; // uuid from server
const String notificationsColTitle = 'title';
const String notificationsColBody = 'body';
const String notificationsColImageUrl = 'image_url';
const String notificationsColHtml = 'html';
const String notificationsColDate = 'date'; // ISO8601 string
const String notificationsColType = 'type';
const String notificationsColTargetUserIds = 'target_user_ids'; // json string
const String notificationsColTargetTopics = 'target_topics'; // json string
const String notificationsColSentBy = 'sent_by';
const String notificationsColCreatedAt = 'created_at';
const String notificationsColSeen = 'seen'; // 0/1

// Reminders Table
const String remindersTableName = 'reminders';
const String remindersColId = 'id';
const String remindersColDays = 'days'; // comma-separated string
const String remindersColHour = 'hour';
const String remindersColMinute = 'minute';
const String remindersColTitle = 'title';
const String remindersColBody = 'body';
const String remindersColIsActive = 'isActive'; // 0/1
const String remindersColCourseId = 'courseId';
const String remindersColCreatedAt = 'createdAt';

// Recent Courses Table
const String recentCoursesTableName = 'recent_courses';
const String recentCoursesColId = 'id';
const String recentCoursesColUserId = 'user_id';
const String recentCoursesColCourseId = 'course_id';
const String recentCoursesColLastVisit = 'last_visit';
 class DatabaseService {
  Database? _database;
  bool _isInitializing = false; // Prevent race conditions during init

  // Lazy initialization of the database
  Future<Database> get database async {
    // If already initialized, return it
    if (_database != null) return _database!;
    // If currently initializing, wait for it to complete
    while (_isInitializing) {
      await Future.delayed(const Duration(milliseconds: 50));
    }
    // If initialized by another caller while waiting, return it
    if (_database != null) return _database!;

    // Start initialization
    _isInitializing = true;
    try {
      _database = await _initDB();
      _isInitializing = false;
      return _database!;
    } catch (e) {
      _isInitializing = false;
      AppLogger.error('Database Initialization Error: $e');
      // Consider re-throwing a specific initialization exception
      throw Exception('Failed to initialize database: ${e.toString()}');
    }
  }

  Future<void> _createNotificationsTable(Database db) async {
    AppLogger.info('Creating database table: $notificationsTableName');
    await db.execute('''
      CREATE TABLE IF NOT EXISTS $notificationsTableName (
        $notificationsColLocalId INTEGER PRIMARY KEY AUTOINCREMENT,
        $notificationsColId TEXT UNIQUE,
        $notificationsColTitle TEXT NOT NULL,
        $notificationsColBody TEXT,
        $notificationsColImageUrl TEXT,
        $notificationsColHtml TEXT,
        $notificationsColDate TEXT NOT NULL,
        $notificationsColType TEXT,
        $notificationsColTargetUserIds TEXT,
        $notificationsColTargetTopics TEXT,
        $notificationsColSentBy TEXT,
        $notificationsColCreatedAt TEXT,
        $notificationsColSeen INTEGER NOT NULL DEFAULT 0
      )
    ''');
    await db.execute('''
      CREATE INDEX IF NOT EXISTS idx_notifications_date
      ON $notificationsTableName($notificationsColDate DESC)
    ''');
    AppLogger.info('Table $notificationsTableName created successfully.');
  }

  Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, _dbName);
    return await openDatabase(
      path,
      version: 13,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  // Define the schema creation logic
  Future<void> _onCreate(Database db, int version) async {
    if (version == 10) {
      await db.execute(''' DROP TABLE IF EXISTS $cachedNewsTableName''');
      debugPrint('Dropping cached news table');
    }
    AppLogger.info('Creating database tables for version $version');
    await _createTodosTable(db);
    await _createCoursesTable(db);
    await _createNotesTable(db);
    await _createCachedPostsTable(db);
    await _createRecentCoursesTable(db);
    await _createCachedNewsTable(db);
    await _createNotificationsTable(db);
    await _createRemindersTable(db);
    AppLogger.info('All tables created successfully.');
  }

  Future<void> _createTodosTable(Database db) async {
    AppLogger.info('Creating database table: $_todosTableName');
    await db.execute('''
       CREATE TABLE IF NOT EXISTS $_todosTableName (
        $_todosColId TEXT PRIMARY KEY,
        $_todosColTitle TEXT NOT NULL,
        $_todosColDescription TEXT,
        $_todosColImportance INTEGER NOT NULL,
        $_todosColDueDate TEXT,
        $_todosColIsCompleted INTEGER NOT NULL,
        $_todosColOrderIndex INTEGER NOT NULL DEFAULT 0
      )
    ''');
    AppLogger.info('Table $_todosTableName created successfully.');
  }

  Future<void> _createCoursesTable(Database db) async {
    AppLogger.info('Creating database table: $coursesTableName');
    await db.execute('''
       CREATE TABLE IF NOT EXISTS $coursesTableName (
        $coursesColId INTEGER PRIMARY KEY,
        $coursesColCourseCode TEXT NOT NULL,
        $coursesColCourseName TEXT NOT NULL,
        $coursesColDepartmentId INTEGER NOT NULL,
        $coursesColStudyYear INTEGER NOT NULL,
        $coursesColSemester INTEGER NOT NULL,
        $coursesColGradeTotal INTEGER,
        $coursesColGradeTheoreticalExam INTEGER,
        $coursesColWeeklyHoursTheory INTEGER,
        $coursesColWeeklyHoursPractical INTEGER,
        $coursesColWeeklyHoursTotal INTEGER,
        $coursesColGradeStudentWork INTEGER,
        $coursesColProgressPercent REAL
      )
    ''');
    AppLogger.info('Table $coursesTableName created successfully.');
  }

  Future<void> _createNotesTable(Database db) async {
    AppLogger.info('Creating database table: $notesTableName');
    await db.execute('''
       CREATE TABLE IF NOT EXISTS $notesTableName (
        $notesColId INTEGER PRIMARY KEY AUTOINCREMENT,
        $notesColCourseId TEXT NOT NULL,
        $notesColTitle TEXT NOT NULL,
        $notesColContent TEXT NOT NULL,
        $notesColLastModified TEXT NOT NULL,
        $notesColColor INTEGER NOT NULL DEFAULT 0
      )
    ''');
    AppLogger.info('Table $notesTableName created successfully.');
  }

  Future<void> _createCachedPostsTable(Database db) async {
    AppLogger.info('Creating database table: $cachedPostsTableName');
    await db.execute('''
    CREATE TABLE IF NOT EXISTS $cachedPostsTableName (
      $cachedPostsColId TEXT PRIMARY KEY,
      $cachedPostsColAuthorId TEXT NOT NULL,
      $cachedPostsColAuthorName TEXT NOT NULL,
      $cachedPostsColAuthorAvatarUrl TEXT,
      $cachedPostsColText TEXT NOT NULL,
      $cachedPostsColImageUrl TEXT,
      $cachedPostsColCategories TEXT NOT NULL,
      $cachedPostsColTopics TEXT NOT NULL,
      $cachedPostsColCreatedAt TEXT NOT NULL,
      $cachedPostsColLikesCount INTEGER NOT NULL DEFAULT 0,
      $cachedPostsColCommentsCount INTEGER NOT NULL DEFAULT 0,
      $cachedPostsColIsArticle INTEGER NOT NULL DEFAULT 0,
      $cachedPostsColIsLiked INTEGER NOT NULL DEFAULT 0
    )
  ''');
    AppLogger.info('Table $cachedPostsTableName created successfully.');
  }

  Future<void> _createCachedNewsTable(Database db) async {
    AppLogger.info('Creating database table: $cachedNewsTableName');
    await db.execute('''
      CREATE TABLE IF NOT EXISTS $cachedNewsTableName (
        $cachedNewsColId TEXT PRIMARY KEY,
        $cachedNewsColTitle TEXT NOT NULL,
        $cachedNewsColContent TEXT NOT NULL,
        $cachedNewsColImageUrl TEXT,
        $cachedNewsColAuthor TEXT,
        $cachedNewsColPublicationDate TEXT NOT NULL,
        $cachedNewsColCategory TEXT,
        $cachedNewsColDescription TEXT
      )
    ''');
    AppLogger.info('Table $cachedNewsTableName created successfully.');
  }

  Future<void> _createRecentCoursesTable(Database db) async {
    AppLogger.info('Creating database table: $recentCoursesTableName');
    await db.execute('''
      CREATE TABLE IF NOT EXISTS $recentCoursesTableName (
        $recentCoursesColId INTEGER PRIMARY KEY AUTOINCREMENT,
        $recentCoursesColUserId TEXT NOT NULL,
        $recentCoursesColCourseId INTEGER NOT NULL,
        $recentCoursesColLastVisit INTEGER NOT NULL,
        UNIQUE($recentCoursesColUserId, $recentCoursesColCourseId) ON CONFLICT REPLACE,
        FOREIGN KEY($recentCoursesColCourseId) REFERENCES $coursesTableName($coursesColId)
      )
    ''');
    await db.execute('''
      CREATE INDEX IF NOT EXISTS idx_recent_courses_user_last
      ON $recentCoursesTableName($recentCoursesColUserId, $recentCoursesColLastVisit DESC)
    ''');
    AppLogger.info('Table $recentCoursesTableName created successfully.');
  }

  Future<void> _createRemindersTable(Database db) async {
    AppLogger.info('Creating database table: $remindersTableName');
    await db.execute('''
      CREATE TABLE IF NOT EXISTS $remindersTableName (
        $remindersColId TEXT PRIMARY KEY,
        $remindersColDays TEXT NOT NULL,
        $remindersColHour INTEGER NOT NULL,
        $remindersColMinute INTEGER NOT NULL,
        $remindersColTitle TEXT NOT NULL,
        $remindersColBody TEXT NOT NULL,
        $remindersColIsActive INTEGER NOT NULL DEFAULT 1,
        $remindersColCourseId TEXT,
        $remindersColCreatedAt TEXT NOT NULL
      )
    ''');
    await db.execute('''
      CREATE INDEX IF NOT EXISTS idx_reminders_course
      ON $remindersTableName($remindersColCourseId)
    ''');
    await db.execute('''
      CREATE INDEX IF NOT EXISTS idx_reminders_active
      ON $remindersTableName($remindersColIsActive)
    ''');
    AppLogger.info('Table $remindersTableName created successfully.');
  }

  // Add migration logic for schema changes
  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    AppLogger.info('Upgrading database from version $oldVersion to $newVersion');
    if (oldVersion < 12) {
      await _createNotificationsTable(db);
    }
    if (oldVersion < 13) {
      await _createRemindersTable(db);
    }
  }

  // Method to close the database connection
  Future<void> close() async {
    if (_database != null && _database!.isOpen) {
      await _database!.close();
      _database = null; // Reset the instance
      AppLogger.info('Database closed.');
    }
  }
}
