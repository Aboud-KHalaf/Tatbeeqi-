// Export all migration functions for easy importing
import 'migration_v12.dart' as v12;
import 'migration_v13.dart' as v13;

// Re-export with different names to avoid conflicts
Future<void> upgradeV12(dynamic db) => v12.upgrade(db);
Future<void> upgradeV13(dynamic db) => v13.upgrade(db);
