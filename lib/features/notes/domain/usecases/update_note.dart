import 'package:dartz/dartz.dart';

import 'package:tatbeeqi/core/error/failures.dart';
import 'package:tatbeeqi/core/usecases/usecase.dart';
import 'package:tatbeeqi/features/notes/domain/entities/note.dart';
import 'package:tatbeeqi/features/notes/domain/repositories/note_repository.dart';

class UpdateNote implements UseCase<Unit, Note> {
  final NoteRepository repository;

  UpdateNote(this.repository);

  @override
  Future<Either<Failure, Unit>> call(Note params) async {
    return await repository.updateNote(params);
  }
}
