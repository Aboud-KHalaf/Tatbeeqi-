import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tatbeeqi/features/courses/domain/entities/course_entity.dart';
import 'package:tatbeeqi/features/courses_details.dart/data/datasources/mock_course_details_datasource.dart';
import 'package:tatbeeqi/features/courses_details.dart/data/course_details_repository_impl.dart';
import 'package:tatbeeqi/features/courses_details.dart/domain/entities/course_details.dart';
import 'package:tatbeeqi/features/courses_details.dart/domain/use_cases/fetch_course_details_use_case.dart';

class AboutCoursePage extends StatelessWidget {
  final Course course;
  const AboutCoursePage({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    final dataSource = MockCourseDetailsDataSource();
    final repository = CourseDetailsRepositoryImpl(dataSource);

    final fetchDetailsUseCase = FetchCourseDetailsUseCase(repository);

    return Scaffold(
      appBar: AppBar(
        title: const Text('About This Course'),
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).colorScheme.onSurface,
      ),
      body: FutureBuilder<CourseDetails>(
        future: fetchDetailsUseCase('1'), // Mock course ID
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return const Center(child: Text('No course details found.'));
          } else {
            final details = snapshot.data!;
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    details.title,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 16),
                  _buildSectionTitle(context, 'Course Description:'),
                  Text(details.description),
                  const SizedBox(height: 24),
                  _buildSectionTitle(context, 'Instructor:'),
                  ListTile(
                    leading: CircleAvatar(
                      radius: 30,
                      backgroundImage: NetworkImage(details.instructorImageUrl),
                    ),
                    title: Text(details.instructorName,
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text(details.instructorTitle),
                    contentPadding: EdgeInsets.zero,
                  ),
                  const SizedBox(height: 24),
                  _buildSectionTitle(context, 'Course Details:'),
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: DataTable(
                      columns: const [
                        DataColumn(label: Text('Attribute')),
                        DataColumn(label: Text('Value')),
                      ],
                      rows: [
                        DataRow(cells: [
                          const DataCell(Text('Credits')),
                          DataCell(Text(details.credits.toString())),
                        ]),
                        DataRow(cells: [
                          const DataCell(Text('Duration')),
                          DataCell(Text(details.duration)),
                        ]),
                        DataRow(cells: [
                          const DataCell(Text('Start Date')),
                          DataCell(Text(
                              DateFormat.yMMMd().format(details.startDate))),
                        ]),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
      ),
    );
  }
}
