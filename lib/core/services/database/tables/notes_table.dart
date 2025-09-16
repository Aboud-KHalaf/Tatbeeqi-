import 'package:sqflite/sqflite.dart';
import 'package:tatbeeqi/core/utils/app_logger.dart';

// Table name
const String notesTableName = 'notes';

// Column names
const String notesColId = 'id';
const String notesColCourseId = 'course_id';
const String notesColTitle = 'title';
const String notesColContent = 'content';
const String notesColLastModified = 'last_modified';
const String notesColColor = 'color';

class NotesTable {
  static Future<void> create(Database db) async {
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
}
