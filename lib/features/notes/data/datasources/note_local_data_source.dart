import 'package:sqflite/sqflite.dart';
import 'package:tatbeeqi/core/error/exceptions.dart';
import 'package:tatbeeqi/core/services/database_service.dart';
import 'package:tatbeeqi/features/notes/data/models/note_model.dart';

abstract class NoteLocalDataSource {
  Future<List<NoteModel>> getNotesByCourseId(String courseId);
  Future<void> addNote(NoteModel note);
  Future<void> updateNote(NoteModel note);
  Future<void> deleteNote(int id);
}

class NoteLocalDataSourceImpl implements NoteLocalDataSource {
  final DatabaseService _databaseService;

  NoteLocalDataSourceImpl({required DatabaseService databaseService})
      : _databaseService = databaseService;

  @override
  Future<void> addNote(NoteModel note) async {
    final db = await _databaseService.database;
    await db.insert(
      notesTableName,
      note.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<void> deleteNote(int id) async {
    final db = await _databaseService.database;
    final result = await db.delete(
      notesTableName,
      where: '$notesColId = ?',
      whereArgs: [id],
    );
    if (result == 0) {
      throw NotFoundException('Note not found');
    }
  }

  @override
  Future<List<NoteModel>> getNotesByCourseId(String courseId) async {
    final db = await _databaseService.database;
    final maps = await db.query(
      notesTableName,
      where: '$notesColCourseId = ?',
      whereArgs: [courseId],
      orderBy: '$notesColLastModified DESC',
    );
    return maps.map((map) => NoteModel.fromMap(map)).toList();
  }

  @override
  Future<void> updateNote(NoteModel note) async {
    final db = await _databaseService.database;
    final result = await db.update(
      notesTableName,
      note.toMap(),
      where: '$notesColId = ?',
      whereArgs: [note.id],
    );
    if (result == 0) {
      throw NotFoundException('Note not found');
    }
  }
}
