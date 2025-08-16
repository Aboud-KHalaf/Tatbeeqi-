import 'package:google_generative_ai/google_generative_ai.dart';
import '../models/ai_question_model.dart';
import '../models/ai_response_model.dart';

abstract class AiAssistantRemoteDataSource {
  Future<AiResponseModel> askQuestion(AiQuestionModel question);
}

class AiAssistantRemoteDataSourceImpl implements AiAssistantRemoteDataSource {
  final GenerativeModel model;

  AiAssistantRemoteDataSourceImpl({required this.model});

  @override
  Future<AiResponseModel> askQuestion(AiQuestionModel question) async {
    try {
      // Create the learning tutor prompt
      final prompt = _buildTutorPrompt(question.question, question.context);

      final content = [Content.text(prompt)];
      final response = await model.generateContent(content);

      if (response.text == null || response.text!.isEmpty) {
        throw ServerException('Empty response from AI assistant');
      }

      return AiResponseModel.success(response.text!);
    } on GenerativeAIException catch (e) {
      throw ServerException('AI service error: ${e.message}');
    } catch (e) {
      throw ServerException('Failed to get AI response: ${e.toString()}');
    }
  }

  String _buildTutorPrompt(String question, String? context) {
    final basePrompt = '''
You are a helpful learning tutor assistant for students. Your role is to:

1. Provide clear, concise, and structured answers to study-related questions
2. Focus only on educational and technical topics
3. Break down complex concepts into understandable parts
4. Use examples when helpful
5. Encourage learning and understanding rather than just giving answers
6. If a question is not study-related, politely redirect to educational topics

Guidelines:
- Keep responses well-structured with clear sections
- Use bullet points or numbered lists when appropriate
- Provide step-by-step explanations for complex topics
- Include relevant examples or analogies
- Maintain an encouraging and supportive tone

Student's question: $question
''';

    if (context != null && context.isNotEmpty) {
      return '$basePrompt\n\nAdditional context: $context';
    }

    return basePrompt;
  }
}
