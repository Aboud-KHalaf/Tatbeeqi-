import 'package:sqflite/sqflite.dart';
import 'package:tatbeeqi/core/utils/app_logger.dart';

// Table name
const String todosTableName = 'todos';

// Column names
const String todosColId = 'id';
const String todosColTitle = 'title';
const String todosColDescription = 'description';
const String todosColImportance = 'importance';
const String todosColDueDate = 'dueDate';
const String todosColIsCompleted = 'isCompleted';
const String todosColOrderIndex = 'orderIndex';

class TodosTable {
  static Future<void> create(Database db) async {
    AppLogger.info('Creating database table: $todosTableName');
    await db.execute('''
       CREATE TABLE IF NOT EXISTS $todosTableName (
        $todosColId TEXT PRIMARY KEY,
        $todosColTitle TEXT NOT NULL,
        $todosColDescription TEXT,
        $todosColImportance INTEGER NOT NULL,
        $todosColDueDate TEXT,
        $todosColIsCompleted INTEGER NOT NULL,
        $todosColOrderIndex INTEGER NOT NULL DEFAULT 0
      )
    ''');
    AppLogger.info('Table $todosTableName created successfully.');
  }
}
