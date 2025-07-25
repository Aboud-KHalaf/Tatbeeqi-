import 'package:equatable/equatable.dart';

class Course extends Equatable {
  final int id;
  final String courseCode;
  final String courseName;
  final int departmentId;
  final int studyYear;
  final int semester;
  final int? gradeTotal;
  final int? gradeTheoreticalExam;
  final int? weeklyHoursTheory;
  final int? weeklyHoursPractical;
  final int? weeklyHoursTotal;
  final int? gradeStudentWork;
  final double? progressPercent;

  const Course({
    required this.id,
    required this.courseCode,
    required this.courseName,
    required this.departmentId,
    required this.studyYear,
    required this.semester,
    this.gradeTotal,
    this.gradeTheoreticalExam,
    this.weeklyHoursTheory,
    this.weeklyHoursPractical,
    this.weeklyHoursTotal,
    this.gradeStudentWork,
    this.progressPercent,
  });

  @override
  List<Object?> get props => [
        id,
        courseCode,
        courseName,
        departmentId,
        studyYear,
        semester,
        gradeTotal,
        gradeTheoreticalExam,
        weeklyHoursTheory,
        weeklyHoursPractical,
        weeklyHoursTotal,
        gradeStudentWork,
        progressPercent,
      ];
}
