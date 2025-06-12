import 'package:dartz/dartz.dart';
import 'package:tatbeeqi/core/error/exceptions.dart';
import 'package:tatbeeqi/core/error/failures.dart';
import 'package:tatbeeqi/features/notes/data/datasources/note_local_data_source.dart';
import 'package:tatbeeqi/features/notes/data/models/note_model.dart';
import 'package:tatbeeqi/features/notes/domain/entities/note.dart';
import 'package:tatbeeqi/features/notes/domain/repositories/note_repository.dart';

class NoteRepositoryImpl implements NoteRepository {
  final NoteLocalDataSource localDataSource;

  NoteRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, Unit>> addNote(Note note) async {
    try {
      final noteModel = NoteModel.fromEntity(note);
      await localDataSource.addNote(noteModel);
      return const Right(unit);
    } on Exception {
      return const Left(CacheFailure('Failed to add note'));
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteNote(int id) async {
    try {
      await localDataSource.deleteNote(id);
      return const Right(unit);
    } on Exception {
      return const Left(CacheFailure('Failed to delete note'));
    }
  }

  @override
  Future<Either<Failure, List<Note>>> getNotesByCourseId(
      String courseId) async {
    try {
      final noteModels = await localDataSource.getNotesByCourseId(courseId);
      return Right(noteModels);
    } on Exception {
      return const Left(CacheFailure('Failed to get notes'));
    }
  }

  @override
  Future<Either<Failure, Unit>> updateNote(Note note) async {
    try {
      final noteModel = NoteModel.fromEntity(note);
      await localDataSource.updateNote(noteModel);
      return const Right(unit);
    } on NotFoundException {
      return const Left(NotFoundFailure('Note not found'));
    } on Exception {
      return const Left(CacheFailure('Failed to update note'));
    }
  }
}
