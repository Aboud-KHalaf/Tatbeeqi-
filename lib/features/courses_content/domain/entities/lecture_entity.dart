import 'package:equatable/equatable.dart';

class Lecture extends Equatable {
  final int id;
  final int courseId;
  final String title;
  final String? description;
  final int orderIndex;
//  final List<Lesson> lessons;

  const Lecture({
    required this.id,
    required this.courseId,
    required this.title,
    this.description,
    required this.orderIndex,
    // this.lessons = const [],
  });

  @override
  List<Object?> get props => [id, courseId, title, description, orderIndex];
}
