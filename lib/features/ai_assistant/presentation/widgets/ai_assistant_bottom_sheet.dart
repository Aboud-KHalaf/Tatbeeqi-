import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../cubit/ai_assistant_cubit.dart';
import '../cubit/ai_assistant_state.dart';
import '../../../notes/presentation/bloc/notes_bloc.dart';
import '../../../notes/domain/entities/note.dart';
import '../../domain/entities/ai_response.dart';
import 'models/chat_message.dart';
import 'chat_header.dart';
import 'chat_bubble.dart';
import 'welcome_message.dart';
import 'loading_message.dart';
import 'error_message.dart';
import 'chat_input.dart';

class AiAssistantBottomSheet extends StatefulWidget {
  final String? lessonContext;
  final String? lessonTitle;
  final String? lessonType; // voice, video, pdf, reading, quiz
  final String? courseId;
  final int? lessonId;

  const AiAssistantBottomSheet({
    super.key,
    this.lessonContext,
    this.lessonTitle,
    this.lessonType,
    this.courseId,
    this.lessonId,
  });

  @override
  State<AiAssistantBottomSheet> createState() => _AiAssistantBottomSheetState();
}

class _AiAssistantBottomSheetState extends State<AiAssistantBottomSheet>
    with SingleTickerProviderStateMixin {
  final TextEditingController _questionController = TextEditingController();
  final FocusNode _questionFocusNode = FocusNode();
  final ScrollController _scrollController = ScrollController();
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  // Chat conversation history
  final List<ChatMessage> _conversation = [];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _animationController.forward();
  }

  @override
  void dispose() {
    _questionController.dispose();
    _questionFocusNode.dispose();
    _scrollController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _askQuestion() {
    final question = _questionController.text.trim();
    if (question.isNotEmpty) {
      HapticFeedback.selectionClick();

      // Add user message to conversation
      setState(() {
        _conversation.add(ChatMessage(
          text: question,
          isUser: true,
          timestamp: DateTime.now(),
        ));
      });

      String contextualQuestion = question;
      String? contextToPass;
      final normalizedType = _normalizedLessonType();

      // Handle context based on lesson type
      if (widget.lessonTitle != null) {
        if (normalizedType == 'reading' && widget.lessonContext != null) {
          // For reading lessons, pass the content as context
          contextualQuestion =
              'Regarding the lesson "${widget.lessonTitle}": $question';
          contextToPass = widget.lessonContext;
        } else {
          // For other lesson types (voice, video, pdf, quiz), just mention the lesson
          contextualQuestion =
              'Regarding the ${normalizedType ?? 'lesson'} "${widget.lessonTitle}": $question';
          contextToPass = null; // No content context for multimedia
        }
      }

      context.read<AiAssistantCubit>().askQuestion(
            contextualQuestion,
            context: contextToPass,
          );
      _questionController.clear();

      // Auto-scroll to bottom when asking a question
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      });
    }
  }

  void _onClose() {
    HapticFeedback.lightImpact();
    context.read<AiAssistantCubit>().reset();
    setState(() {
      _conversation.clear();
    });
    context.pop();
  }

  void _onQuestionSelected(String question) {
    _questionController.text = question;
    _askQuestion();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final screenHeight = MediaQuery.of(context).size.height;

    return FadeTransition(
      opacity: _fadeAnimation,
      child: Container(
        height: screenHeight * 0.85,
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(28),
            topRight: Radius.circular(28),
          ),
        ),
        child: Column(
          children: [
            ChatHeader(onClose: _onClose),
            Expanded(
              child: _buildContent(colorScheme, textTheme),
            ),
            ChatInput(
              controller: _questionController,
              focusNode: _questionFocusNode,
              onSend: _askQuestion,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(ColorScheme colorScheme, TextTheme textTheme) {
    return BlocListener<AiAssistantCubit, AiAssistantState>(
      listener: (context, state) {
        if (state is AiAssistantSuccess) {
          setState(() {
            _conversation.add(ChatMessage(
              text: state.response.response,
              isUser: false,
              timestamp: state.response.timestamp,
              aiResponse: state.response,
            ));
          });

          // Auto-scroll to bottom
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (_scrollController.hasClients) {
              _scrollController.animateTo(
                _scrollController.position.maxScrollExtent,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOut,
              );
            }
          });
        }
      },
      child: BlocBuilder<AiAssistantCubit, AiAssistantState>(
        builder: (context, state) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: _buildChatContent(state, colorScheme, textTheme),
          );
        },
      ),
    );
  }

  Widget _buildChatContent(
      AiAssistantState state, ColorScheme colorScheme, TextTheme textTheme) {
    return ListView.builder(
      controller: _scrollController,
      itemCount: _conversation.length +
          (_conversation.isEmpty ? 1 : 0) + // Initial state
          (state is AiAssistantLoading ? 1 : 0) + // Loading message
          (state is AiAssistantError ? 1 : 0), // Error message
      itemBuilder: (context, index) {
        // Show initial state if no conversation
        if (_conversation.isEmpty &&
            index == 0 &&
            state is! AiAssistantLoading &&
            state is! AiAssistantError) {
          return WelcomeMessage(
            lessonTitle: widget.lessonTitle,
            lessonType: widget.lessonType,
            onQuestionSelected: _onQuestionSelected,
          );
        }

        // Show conversation messages
        if (index < _conversation.length) {
          return ChatBubble(
            message: _conversation[index],
            onSaveNote: (response) =>
                _saveResponseAsNote(response, colorScheme),
          );
        }

        // Show loading indicator
        if (state is AiAssistantLoading) {
          return const LoadingMessage();
        }

        // Show error message
        if (state is AiAssistantError) {
          return ErrorMessage(message: state.message);
        }

        return const SizedBox.shrink();
      },
    );
  }

  void _saveResponseAsNote(AiResponse response, ColorScheme colorScheme) {
    if (widget.courseId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
              const Text('Cannot save note: Course information not available'),
          backgroundColor: colorScheme.error,
        ),
      );
      return;
    }

    final note = Note(
      id: null,
      title: 'AI Response - ${DateTime.now().toString().substring(0, 16)}',
      content: response.response,
      courseId: widget.courseId!,
      lastModified: DateTime.now(),
      colorIndex: 0,
    );

    context.read<NotesBloc>().add(AddNoteEvent(note));

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('AI response saved as note!'),
        backgroundColor: colorScheme.primary,
        behavior: SnackBarBehavior.floating,
      ),
    );

    HapticFeedback.lightImpact();
  }

  String? _normalizedLessonType() {
    final t = widget.lessonType?.toLowerCase();
    if (t == null) return null;
    final parts = t.split('.');
    return parts.isNotEmpty ? parts.last : t;
  }
}
