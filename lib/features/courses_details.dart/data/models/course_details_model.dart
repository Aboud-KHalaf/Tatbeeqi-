import 'package:tatbeeqi/features/courses_details.dart/domain/entities/course_details.dart';

class CourseDetailsModel extends CourseDetails {
  const CourseDetailsModel({
    required super.id,
    required super.courseId,
    required super.name,
    super.description,
    super.professor,
    super.contributors,
    super.schedule,
    required super.createdAt,
  });

  factory CourseDetailsModel.fromJson(Map<String, dynamic> json) {
    return CourseDetailsModel(
      id: json['id'] as String,
      courseId: json['course_id'] as int,
      name: json['name'] as String,
      description: json['description'] as String?,
      professor: json['professor'] as String?,
      contributors: json['contributors'] != null 
          ? List<String>.from(json['contributors'] as List)
          : null,
      schedule: json['schedule'] as Map<String, dynamic>?,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'course_id': courseId,
      'name': name,
      'description': description,
      'professor': professor,
      'contributors': contributors,
      'schedule': schedule,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
