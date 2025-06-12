import 'package:dartz/dartz.dart';
import 'package:tatbeeqi/core/error/failures.dart';
import 'package:tatbeeqi/core/usecases/usecase.dart';
import 'package:tatbeeqi/features/notes/domain/entities/note.dart';
import 'package:tatbeeqi/features/notes/domain/repositories/note_repository.dart';

class GetNotesByCourseId implements UseCase<List<Note>, String> {
  final NoteRepository repository;

  GetNotesByCourseId(this.repository);

  @override
  Future<Either<Failure, List<Note>>> call(String params) async {
    return await repository.getNotesByCourseId(params);
  }
}
