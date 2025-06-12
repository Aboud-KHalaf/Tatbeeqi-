import 'package:dartz/dartz.dart';
import 'package:tatbeeqi/core/error/failures.dart';
import 'package:tatbeeqi/features/notes/domain/entities/note.dart';

abstract class NoteRepository {
  Future<Either<Failure, List<Note>>> getNotesByCourseId(String courseId);
  Future<Either<Failure, Unit>> addNote(Note note);
  Future<Either<Failure, Unit>> updateNote(Note note);
  Future<Either<Failure, Unit>> deleteNote(int id);
}
