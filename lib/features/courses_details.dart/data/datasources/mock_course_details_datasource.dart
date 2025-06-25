import 'package:tatbeeqi/features/courses_details.dart/data/models/course_details_model.dart';

class MockCourseDetailsDataSource {
  final CourseDetailsModel courseDetails = CourseDetailsModel(
    id: '1',
    title: 'Introduction to Flutter Development',
    description: 'This course covers the fundamentals of Flutter development, including widgets, state management, and UI design principles.',
    instructorName: 'Dr. Jane Smith',
    instructorImageUrl: 'https://i.pravatar.cc/150?u=jane_smith',
    instructorTitle: 'Professor of Computer Science',
    credits: 3,
    duration: '12 weeks',
    startDate: DateTime(2023, 9, 1),
  );
}
