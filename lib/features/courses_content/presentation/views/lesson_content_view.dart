import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tatbeeqi/core/helpers/snack_bar_helper.dart';
import 'package:tatbeeqi/features/courses_content/domain/entities/lesson_entity.dart';
import 'package:tatbeeqi/features/courses_content/presentation/widgets/pdf_viewer_widget.dart';
import 'package:tatbeeqi/features/courses_content/presentation/widgets/reading_content_widget.dart';
import 'package:tatbeeqi/features/courses_content/presentation/widgets/video_player_widget.dart';
import 'package:tatbeeqi/features/courses_content/presentation/widgets/voice_content_widget.dart';
import 'package:tatbeeqi/features/notes/presentation/bloc/notes_bloc.dart';
import 'package:tatbeeqi/features/quiz/presentation/widgets/quiz_widget.dart';
import 'package:tatbeeqi/features/notes/presentation/widgets/add_edit_note_dialog.dart';
import 'package:tatbeeqi/features/ai_assistant/presentation/widgets/ai_assistant_bottom_sheet.dart';
import 'package:tatbeeqi/features/ai_assistant/presentation/cubit/ai_assistant_cubit.dart';
import 'package:tatbeeqi/features/courses_content/presentation/widgets/lesson_action_bar.dart';

class LessonContentView extends StatefulWidget {
  static const String routePath = '/lesson-content';
  final List<Lesson> lesson;
  final int courseId;
  final int index;
  const LessonContentView(
      {super.key,
      required this.lesson,
      required this.index,
      required this.courseId});

  @override
  State<LessonContentView> createState() => _LessonContentViewState();
}

class _LessonContentViewState extends State<LessonContentView>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.index;
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.lesson[_currentIndex].title),
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () {
            context.pop();
          },
        ),
        actions: [
          _buildProgressIndicator(colorScheme),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: _lessonContentByType(context),
          ),
          if (widget.lesson[_currentIndex].lessonType != ContentType.quiz)
            SlideTransition(
              position: _slideAnimation,
              child: LessonActionBar(
                lesson : widget.lesson[_currentIndex],
                canGoPrevious: _currentIndex > 0,
                canGoNext: _currentIndex < widget.lesson.length - 1,
                onPrevious: _goToPreviousLesson,
                onNext: _goToNextLesson,
                onAddNote: () => _showAddNoteDialog(context),
                onAskAi: () => _showAiAssistantBottomSheet(context),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildProgressIndicator(ColorScheme colorScheme) {
    final progress = (_currentIndex + 1) / widget.lesson.length;

    return Container(
      margin: const EdgeInsets.only(right: 16),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(
              value: progress,
              strokeWidth: 2,
              backgroundColor: colorScheme.onPrimaryContainer.withOpacity(0.3),
              valueColor:
                  AlwaysStoppedAnimation<Color>(colorScheme.onPrimaryContainer),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            '${_currentIndex + 1}/${widget.lesson.length}',
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: colorScheme.onPrimaryContainer,
                  fontWeight: FontWeight.w600,
                ),
          ),
        ],
      ),
    );
  }

  Widget _lessonContentByType(BuildContext context) {
    switch (widget.lesson[_currentIndex].lessonType) {
      case ContentType.pdf:
        return PDFViewerWidget(
          pdfUrl: widget.lesson[_currentIndex].contentUrl ?? '',
          title: widget.lesson[_currentIndex].title,
        );

      case ContentType.video:
        return VideoPlayerWidget(
          videoUrl: widget.lesson[_currentIndex].contentUrl ?? '',
          title: widget.lesson[_currentIndex].title,
        );

      case ContentType.quiz:
        return QuizWidget(
          lessonId: widget.lesson[_currentIndex].id,
        );

      case ContentType.voice:
        return VoiceContentWidget(
          audioUrl: widget.lesson[_currentIndex].contentUrl ?? '',
          title: widget.lesson[_currentIndex].title,
        );

      case ContentType.reading:
        return ReadingContentWidget(
          content: widget.lesson[_currentIndex].content ?? '',
          title: widget.lesson[_currentIndex].title,
        );
    }
  }

  // Action buttons UI moved to LessonActionBar widget

  void _goToPreviousLesson() {
    if (_currentIndex > 0) {
      HapticFeedback.selectionClick();
      setState(() {
        _currentIndex -= 1;
      });
    }
  }

  void _goToNextLesson() {
    if (_currentIndex < widget.lesson.length - 1) {
      HapticFeedback.selectionClick();
      setState(() {
        _currentIndex += 1;
      });
    }
  }

  void _showAddNoteDialog(BuildContext context) {
    HapticFeedback.selectionClick();
    showDialog(
      context: context,
      builder: (context) => AddEditNoteDialog(
        courseId: widget.courseId.toString(),
        onSave: (note) {
          context.read<NotesBloc>().addNote(note);
          SnackBarHelper.showSuccess(
            context: context,
            message: 'Note "${note.courseId}" saved successfully!',
          );
        },
      ),
    );
  }

  void _showAiAssistantBottomSheet(BuildContext context) {
    HapticFeedback.selectionClick();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => BlocProvider.value(
        value: context.read<AiAssistantCubit>(),
        child:AiAssistantBottomSheet(
  lessonContext: widget.lesson[_currentIndex].content, // Only for reading type
  lessonTitle: widget.lesson[_currentIndex].title,
  lessonType: widget.lesson[_currentIndex].lessonType.toString(), // or "voice", "video", "pdf", "quiz"
  courseId: widget.courseId.toString(),
  lessonId: widget.lesson[_currentIndex].id,
)
      ),
    );
  }
}
