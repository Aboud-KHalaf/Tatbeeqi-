import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tatbeeqi/features/courses_content/domain/entities/lesson_entity.dart';
import 'package:tatbeeqi/features/courses_content/presentation/widgets/pdf_viewer_widget.dart';
import 'package:tatbeeqi/features/courses_content/presentation/widgets/reading_content_widget.dart';
import 'package:tatbeeqi/features/courses_content/presentation/widgets/video_player_widget.dart';
import 'package:tatbeeqi/features/courses_content/presentation/widgets/voice_content_widget.dart';
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
      body: _lessonContentByType(context),
    );
  }

  Widget _lessonContentByType(BuildContext context) {
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
          ),
        );

      case ContentType.voice:
        return VoiceContentWidget(
          audioUrl: lesson.contentUrl ?? '',
          title: lesson.title,
        );

      case ContentType.reading:
        return ReadingContentWidget(
          content:
              "https://ayqqtvgloqmykmgthdvs.supabase.co/storage/v1/object/public/voices/Record%20(online-voice-recorder.com).mp3",
          title: lesson.title,
        );
    }
  }
}
