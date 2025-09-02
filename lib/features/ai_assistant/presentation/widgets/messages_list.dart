import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tatbeeqi/features/ai_assistant/domain/entities/chat_message.dart';
import 'package:tatbeeqi/features/ai_assistant/presentation/cubit/ai_assistant_cubit.dart';
import 'package:tatbeeqi/features/ai_assistant/presentation/cubit/ai_assistant_state.dart';
import 'package:tatbeeqi/features/ai_assistant/presentation/widgets/message_bubble.dart';
import 'package:tatbeeqi/features/ai_assistant/presentation/widgets/typing_indicator.dart';

class MessagesList extends StatelessWidget {
  const MessagesList({
    super.key,
    required this.messages,
    required this.scrollController,
  });

  final List<ChatMessage> messages;
  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    final isLoading =
        context.watch<AiAssistantCubit>().state is AiAssistantLoading;

    if (messages.isEmpty && !isLoading) {
      return const SizedBox.shrink();
    }

    return ListView.builder(
      controller: scrollController,
      padding: const EdgeInsets.all(16),
      itemCount: messages.length + (isLoading ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == messages.length && isLoading) {
          return const TypingIndicator();
        }
        return MessageBubble(message: messages[index]);
      },
    );
  }
}
