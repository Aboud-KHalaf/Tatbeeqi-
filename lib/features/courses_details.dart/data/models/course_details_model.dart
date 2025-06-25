import 'package:tatbeeqi/features/courses_details.dart/domain/entities/course_details.dart';

class CourseDetailsModel extends CourseDetails {
  const CourseDetailsModel({
    required super.id,
    required super.title,
    required super.description,
    required super.instructorName,
    required super.instructorImageUrl,
    required super.instructorTitle,
    required super.credits,
    required super.duration,
    required super.startDate,
  });

  factory CourseDetailsModel.fromJson(Map<String, dynamic> json) {
    return CourseDetailsModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      instructorName: json['instructorName'],
      instructorImageUrl: json['instructorImageUrl'],
      instructorTitle: json['instructorTitle'],
      credits: json['credits'],
      duration: json['duration'],
      startDate: DateTime.parse(json['startDate']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'instructorName': instructorName,
      'instructorImageUrl': instructorImageUrl,
      'instructorTitle': instructorTitle,
      'credits': credits,
      'duration': duration,
      'startDate': startDate.toIso8601String(),
    };
  }
}
