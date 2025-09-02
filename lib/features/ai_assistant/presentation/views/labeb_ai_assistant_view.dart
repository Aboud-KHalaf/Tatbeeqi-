// AI Assistant Chat Interface
// Modern chat UI for AI learning assistant - Fixed keyboard overflow issue

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tatbeeqi/features/ai_assistant/domain/entities/chat_message.dart';
import '../cubit/ai_assistant_cubit.dart';
import '../cubit/ai_assistant_state.dart';
import 'package:tatbeeqi/features/ai_assistant/presentation/widgets/messages_list.dart';





class LabebAiAssistantView extends StatefulWidget {
  const LabebAiAssistantView({super.key});

  @override
  State<LabebAiAssistantView> createState() => _LabebAiAssistantViewState();
}

class _LabebAiAssistantViewState extends State<LabebAiAssistantView> {
  final _messageController = TextEditingController();
  final _scrollController = ScrollController();
  final List<ChatMessage> _messages = [];

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    final message = _messageController.text.trim();
    if (message.isNotEmpty) {
      setState(() {
        _messages.add(ChatMessage(
          text: message,
          isUser: true,
          timestamp: DateTime.now(),
        ));
      });

      // 1) Build context from conversation (last few messages)
      final contextText = _buildConversationContext();

      // 2) Send with context
      context.read<AiAssistantCubit>().askQuestion(
        message,
        context: contextText, // <- pass context here
      );

      _messageController.clear();
      _scrollToBottom();
    }
  }

  String _buildConversationContext() {
    // Use last 5 messages as brief context (without extension helpers)
    final int count = _messages.length;
    final int start = count > 5 ? count - 5 : 0;
    final List<String> lines = [];
    for (int i = start; i < count; i++) {
      final m = _messages[i];
      lines.add('${m.isUser ? 'User' : 'Assistant'}: ${m.text}');
    }
    return lines.join('\n');
  }

  void _scrollToBottom() {
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('لبيب Ai'),
        backgroundColor: colorScheme.surface,
        elevation: 0,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                _messages.clear();
              });
              context.read<AiAssistantCubit>().reset();
            },
            tooltip: 'مسح المحادثة',
          ),
        ],
      ),
      body: Column(
        children: [
          // Chat messages area - This will shrink when keyboard appears
          Expanded(
            child: BlocListener<AiAssistantCubit, AiAssistantState>(
              listener: (context, state) {
                if (state is AiAssistantSuccess) {
                  setState(() {
                    _messages.add(ChatMessage(
                      text: state.response.response,
                      isUser: false,
                      timestamp: DateTime.now(),
                    ));
                  });
                  _scrollToBottom();
                } else if (state is AiAssistantError) {
                  setState(() {
                    _messages.add(ChatMessage(
                      text: 'عذراً، حدث خطأ: ${state.message}',
                      isUser: false,
                      timestamp: DateTime.now(),
                    ));
                  });
                  _scrollToBottom();
                }
              },
              child: _messages.isEmpty
                  ? _buildWelcomeScreen()
                  : MessagesList(
                      messages: _messages,
                      scrollController: _scrollController,
                    ),
            ),
          ),
          // Message input area - Fixed to bottom
          _buildMessageInput(),
        ],
      ),
    );
  }

  Widget _buildWelcomeScreen() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer.withOpacity(0.3),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.smart_toy_rounded,
                size: 64,
                color: colorScheme.primary,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'مرحباً بك في لبيب Ai!',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              'اسألني أي سؤال متعلق بالدراسة وسأساعدك!\n\nيمكنني مساعدتك في:\n• شرح المفاهيم\n• حل المسائل\n• نصائح الدراسة\n• المواضيع التقنية',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: colorScheme.onSurfaceVariant,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  // extracted MessageBubble and TypingIndicator moved to widgets/

  Widget _buildMessageInput() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          border: Border(
            top: BorderSide(
              color: colorScheme.outline.withOpacity(0.2),
              width: 1,
            ),
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxHeight: 120, // Limit maximum height
                ),
                child: TextField(
                  controller: _messageController,
                  decoration: InputDecoration(
                    hintText: 'اكتب رسالتك هنا...',
                    hintStyle: TextStyle(
                      color: colorScheme.onSurfaceVariant,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                      borderSide: BorderSide(
                        color: colorScheme.outline.withOpacity(0.3),
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                      borderSide: BorderSide(
                        color: colorScheme.outline.withOpacity(0.3),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                      borderSide: BorderSide(
                        color: colorScheme.primary,
                        width: 2,
                      ),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    filled: true,
                    fillColor: colorScheme.surfaceContainerHighest.withOpacity(0.3),
                  ),
                  maxLines: null,
                  minLines: 1,
                  textInputAction: TextInputAction.send,
                  onSubmitted: (_) => _sendMessage(),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Container(
              decoration: BoxDecoration(
                color: colorScheme.primary,
                shape: BoxShape.circle,
              ),
              child: IconButton(
                onPressed: _sendMessage,
                icon: Icon(
                  Icons.send_rounded,
                  color: colorScheme.onPrimary,
                ),
                tooltip: 'إرسال',
              ),
            ),
          ],
        ),
      ),
    );
  }
}