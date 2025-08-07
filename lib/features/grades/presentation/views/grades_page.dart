import 'package:flutter/material.dart';
import 'package:tatbeeqi/features/courses/domain/entities/course_entity.dart';
import 'package:tatbeeqi/features/grades/domain/entities/grade.dart';

class GradesView extends StatelessWidget {
  final Course course;
  const GradesView({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.separated(
        padding: const EdgeInsets.all(16.0),
        itemCount: 5,
        separatorBuilder: (context, index) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final grade = Grade(
            id: '1',
            lessonId: '1',
            quizId: '1',
            lectureId: '1',
            courseId: '1',
            studentId: 'student1',
            score: 85.0,
            submissionDate: DateTime.now(),
          );
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
                backgroundColor:
                    grade.score >= 80 ? Colors.green : Colors.orange,
                padding: const EdgeInsets.symmetric(horizontal: 8),
              ),
            ),
          );
        },
      ),
    );
  }
}
