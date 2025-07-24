import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/lecture_entity.dart';
import '../entities/lesson_entity.dart';

abstract class CoursesContentRepository {
  Future<Either<Failure, List<Lecture>>> fetchLecturesByCourseId(int courseId);
  Future<Either<Failure, List<Lesson>>> fetchLessonsByLectureId(int lectureId);
  Future<Either<Failure, Unit>> markLessonAsCompleted(int lessonId);
}
