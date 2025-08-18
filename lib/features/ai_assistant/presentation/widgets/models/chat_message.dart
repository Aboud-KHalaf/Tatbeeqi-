
import 'package:tatbeeqi/features/ai_assistant/domain/entities/ai_response.dart';

class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime timestamp;
  final AiResponse? aiResponse;

  ChatMessage({
    required this.text,
    required this.isUser,
    required this.timestamp,
    this.aiResponse,
  });
}
