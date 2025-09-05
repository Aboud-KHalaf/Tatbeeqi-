import 'package:equatable/equatable.dart';

class CourseDetails extends Equatable {
  final String id; // UUID from Supabase
  final int courseId; // Foreign key to courses table
  final String name;
  final String? description;
  final String? professor;
  final List<String>? contributors;
  final Map<String, dynamic>? schedule; // JSONB field
  final DateTime createdAt;

  const CourseDetails({
    required this.id,
    required this.courseId,
    required this.name,
    this.description,
    this.professor,
    this.contributors,
    this.schedule,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
        id,
        courseId,
        name,
        description,
        professor,
        contributors,
        schedule,
        createdAt,
      ];
}
