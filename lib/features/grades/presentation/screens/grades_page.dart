import 'package:flutter/material.dart';
import 'package:tatbeeqi/features/grades/data/datasources/mock_grades_datasource.dart';
import 'package:tatbeeqi/features/grades/data/repositories/grades_repository_impl.dart';
import 'package:tatbeeqi/features/grades/domain/entities/grade.dart';
import 'package:tatbeeqi/features/grades/domain/use_cases/fetch_grades_by_lesson_and_course_id_use_case.dart';

class GradesPage extends StatelessWidget {
  const GradesPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Manual dependency injection for now
    final dataSource = MockGradesDataSource();
    final repository = GradesRepositoryImpl(dataSource);
    final fetchGradesUseCase = FetchGradesByLessonAndCourseIdUseCase(repository);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Grades'),
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).colorScheme.onSurface,
      ),
      body: FutureBuilder<List<Grade>>(
        future: fetchGradesUseCase('1', '1'), // Using mock IDs
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No grades found.'));
          } else {
            final grades = snapshot.data!;
            return ListView.separated(
              padding: const EdgeInsets.all(16.0),
              itemCount: grades.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final grade = grades[index];
                return Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 16,
                    ),
                    title: Text(
                      'Lesson ${grade.lessonId}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      'Submitted on: ${grade.submissionDate.toLocal().toString().split(' ')[0]}',
                    ),
                    trailing: Chip(
                      label: Text(
                        '${grade.score.toStringAsFixed(1)}%',
                        style: const TextStyle(color: Colors.white),
                      ),
                      backgroundColor: grade.score >= 80 ? Colors.green : Colors.orange,
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
