import 'package:equatable/equatable.dart';

class CourseDetails extends Equatable {
  final String id;
  final String title;
  final String description;
  final String instructorName;
  final String instructorImageUrl;
  final String instructorTitle;
  final int credits;
  final String duration;
  final DateTime startDate;

  const CourseDetails({
    required this.id,
    required this.title,
    required this.description,
    required this.instructorName,
    required this.instructorImageUrl,
    required this.instructorTitle,
    required this.credits,
    required this.duration,
    required this.startDate,
  });

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        instructorName,
        instructorImageUrl,
        instructorTitle,
        credits,
        duration,
        startDate,
      ];
}
