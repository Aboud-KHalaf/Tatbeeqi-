import 'package:dartz/dartz.dart';

import 'package:tatbeeqi/core/error/failures.dart';
import 'package:tatbeeqi/core/usecases/usecase.dart';
import 'package:tatbeeqi/features/notes/domain/repositories/note_repository.dart';

class DeleteNote implements UseCase<Unit, int> {
  final NoteRepository repository;

  DeleteNote(this.repository);

  @override
  Future<Either<Failure, Unit>> call(int params) async {
    return await repository.deleteNote(params);
  }
}
