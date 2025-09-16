// ignore: depend_on_referenced_packages
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:tatbeeqi/core/utils/app_logger.dart';
import 'tables/table_registry.dart';
import 'migrations/migrations.dart' as migrations;

const String _dbName = 'app_database.db'; // Renamed for more general use

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
      await db.execute(''' DROP TABLE IF EXISTS cached_news''');
      debugPrint('Dropping cached news table');
    }
    AppLogger.info('Creating database tables for version $version');
    await TableRegistry.createAllTables(db);
    AppLogger.info('All tables created successfully.');
  }

  // Add migration logic for schema changes
  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    AppLogger.info(
        'Upgrading database from version $oldVersion to $newVersion');

    // Run migrations in order
    if (oldVersion < 12) {
      await migrations.upgradeV12(db);
    }
    if (oldVersion < 13) {
      await migrations.upgradeV13(db);
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
