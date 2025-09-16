# Database Service Architecture

This directory contains the modular database service architecture for the Tatbeeqi app.

## Structure

```
database/
├── database_service.dart          # Main database service
├── tables/                        # Table definitions
│   ├── tables.dart               # Export all tables
│   ├── table_registry.dart       # Registry for all tables
│   ├── todos_table.dart          # Todos table
│   ├── courses_table.dart        # Courses table
│   ├── notes_table.dart          # Notes table
│   ├── cached_posts_table.dart   # Cached posts table
│   ├── cached_news_table.dart    # Cached news table
│   ├── notifications_table.dart  # Notifications table
│   ├── reminders_table.dart      # Reminders table
│   └── recent_courses_table.dart # Recent courses table
└── migrations/                    # Database migrations
    ├── migrations.dart           # Export all migrations
    ├── migration_v12.dart        # Migration for version 12
    └── migration_v13.dart        # Migration for version 13
```

## Usage

### Importing Tables
```dart
import 'package:tatbeeqi/core/services/database/tables/tables.dart';

// Access table constants
final tableName = todosTableName;
final columnName = todosColId;
```

### Using Database Service
```dart
import 'package:tatbeeqi/core/services/database/database_service.dart';

final dbService = DatabaseService();
final db = await dbService.database;
```

### Adding New Tables

1. Create a new table file in `tables/` directory:
```dart
// tables/my_new_table.dart
const String myNewTableName = 'my_new_table';
const String myNewTableColId = 'id';

class MyNewTable {
  static Future<void> create(Database db) async {
    // Create table SQL here
  }
}
```

2. Add the table to `table_registry.dart`:
```dart
import 'my_new_table.dart';

static final List<Future<void> Function(Database)> _tableCreators = [
  // ... existing tables
  MyNewTable.create,
];
```

### Adding New Migrations

1. Create a new migration file in `migrations/` directory:
```dart
// migrations/migration_v14.dart
Future<void> upgrade(Database db) async {
  // Migration logic here
}
```

2. Add the migration to `migrations.dart`:
```dart
import 'migration_v14.dart' as v14;

Future<void> upgradeV14(dynamic db) => v14.upgrade(db);
```

3. Update `database_service.dart` to call the migration:
```dart
if (oldVersion < 14) {
  await migrations.upgradeV14(db);
}
```

## Benefits

- **Modularity**: Each table is self-contained
- **Maintainability**: Easy to find and modify table definitions
- **Scalability**: Simple to add new tables and migrations
- **Testability**: Individual tables can be tested in isolation
- **Readability**: Clear separation of concerns
