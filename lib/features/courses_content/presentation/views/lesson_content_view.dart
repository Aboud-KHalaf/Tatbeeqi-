import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tatbeeqi/features/courses_content/domain/entities/lesson_entity.dart';
import 'package:tatbeeqi/features/courses_content/presentation/widgets/video_player_widget.dart';
import 'package:tatbeeqi/features/courses_content/presentation/widgets/pdf_viewer_widget.dart';
import 'package:tatbeeqi/features/quiz/presentation/widgets/quiz_widget.dart';
import 'package:tatbeeqi/features/quiz/presentation/bloc/quiz_bloc.dart';
import 'package:get_it/get_it.dart';

class LessonContentView extends StatelessWidget {
  static const String routePath = '/lesson-content';
  final Lesson lesson;
  const LessonContentView({super.key, required this.lesson});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(lesson.title),
      ),
      body: _lessonContentByType(),
    );
  }

  Widget _lessonContentByType() {
    switch (lesson.lessonType) {
      case ContentType.pdf:
        return PDFViewerWidget(
          pdfUrl: lesson.contentUrl ?? '',
          title: lesson.title,
        );
      
      case ContentType.video:
        return VideoPlayerWidget(
          videoUrl: lesson.contentUrl ?? '',
          title: lesson.title,
        );
      
      case ContentType.quiz:
        return BlocProvider(
          create: (context) => GetIt.instance<QuizBloc>(),
          child: QuizWidget(
            lessonId: lesson.id,
            onQuizCompleted: (score, results, questions, userAnswers) {
              // Handle quiz completion if needed
              // You can add navigation or other logic here
            },
          ),
        );
      
      case ContentType.voice:
        return _VoiceContentWidget(
          audioUrl: lesson.contentUrl ?? '',
          title: lesson.title,
        );
      
      case ContentType.reading:
        return _ReadingContentWidget(
          content: lesson.content ?? '',
          title: lesson.title,
        );
    }
  }
}

// Placeholder widget for voice content
class _VoiceContentWidget extends StatelessWidget {
  final String audioUrl;
  final String? title;

  const _VoiceContentWidget({
    required this.audioUrl,
    this.title,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.headphones,
              size: 64,
              color: colorScheme.primary,
            ),
            const SizedBox(height: 16),
            Text(
              'Audio Content',
              style: theme.textTheme.headlineMedium?.copyWith(
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            if (title != null)
              Text(
                title!,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
            const SizedBox(height: 16),
            Text(
              'Audio player will be implemented here',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

// Placeholder widget for reading content
class _ReadingContentWidget extends StatelessWidget {
  final String content;
  final String? title;

  const _ReadingContentWidget({
    required this.content,
    this.title,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null) ...[
            Text(
              title!,
              style: theme.textTheme.headlineMedium?.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
          ],
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerLowest,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: colorScheme.outlineVariant.withValues(alpha: 0.3),
              ),
            ),
            child: Text(
              content.isNotEmpty ? content : 'No content available',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: colorScheme.onSurface,
                height: 1.6,
              ),
            ),
          ),
        ],
      ),
    );
  }
}


