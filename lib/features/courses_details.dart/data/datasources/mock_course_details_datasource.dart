import 'package:tatbeeqi/features/courses_details.dart/data/models/course_details_model.dart';

class MockCourseDetailsDataSource {
  final CourseDetailsModel courseDetails = CourseDetailsModel(
    id: 'uuid-1234-5678-9012',
    courseId: 1,
    name: 'Introduction to Flutter Development',
    description: 'This course covers the fundamentals of Flutter development, including widgets, state management, and UI design principles.',
    professor: 'Dr. Jane Smith',
    contributors: ['Dr. Jane Smith', 'Prof. John Doe'],
    schedule: {
      'days': ['Monday', 'Wednesday', 'Friday'],
      'time': '10:00 AM - 11:30 AM',
      'duration': '12 weeks'
    },
    createdAt: DateTime(2023, 9, 1),
  );
}
