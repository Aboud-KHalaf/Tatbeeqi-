import 'package:equatable/equatable.dart';

class Lecture extends Equatable {
  final int id;
  final int courseId;
  final String title;
  final String? description;
  final int orderIndex;

  const Lecture({
    required this.id,
    required this.courseId,
    required this.title,
    this.description,
    required this.orderIndex,
  });

  @override
  List<Object?> get props => [id, courseId, title, description, orderIndex];
}
