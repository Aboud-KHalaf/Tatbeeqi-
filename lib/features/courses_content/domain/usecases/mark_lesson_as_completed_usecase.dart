import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repository/courses_content_repository.dart';

class MarkLessonAsCompletedUseCase implements UseCase<Unit, MarkLessonParams> {
  final CoursesContentRepository repository;

  MarkLessonAsCompletedUseCase(this.repository);

  @override
  Future<Either<Failure, Unit>> call(MarkLessonParams params) async {
    return await repository.markLessonAsCompleted(params.lessonId);
  }
}

class MarkLessonParams extends Equatable {
  final int lessonId;

  const MarkLessonParams({required this.lessonId});

  @override
  List<Object?> get props => [lessonId];
}
