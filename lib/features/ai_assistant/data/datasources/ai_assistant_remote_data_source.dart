import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import '../../../../core/error/exceptions.dart' as core_exceptions;
import '../models/ai_question_model.dart';
import '../models/ai_response_model.dart';

abstract class AiAssistantRemoteDataSource {
  Future<AiResponseModel> askQuestion(AiQuestionModel question);
  Future<bool> testConnection();
}

class AiAssistantRemoteDataSourceImpl implements AiAssistantRemoteDataSource {
  final GenerativeModel model;

  AiAssistantRemoteDataSourceImpl({required this.model});

  @override
  Future<AiResponseModel> askQuestion(AiQuestionModel question) async {
    try {
      // Create the learning tutor prompt
      final prompt = _buildTutorPrompt(question.question, question.context);
      debugPrint("Sending prompt: $prompt");

      final content = [Content.text(prompt)];
      
      // Add timeout and better error handling
      final response = await model.generateContent(
        content,
        generationConfig: GenerationConfig(
          temperature: 0.7,
          maxOutputTokens: 1024, // Reduced for testing
        ),
      ).timeout(
        const Duration(seconds: 30),
        onTimeout: () => throw core_exceptions.ServerException('Request timeout'),
      );

      debugPrint("Full response object: $response");
      debugPrint("Response candidates: ${response.candidates}");

      if (response.text == null || response.text!.isEmpty) {
        debugPrint("Response text is null or empty");
        throw core_exceptions.ServerException(
            'Empty response from AI assistant');
      }

      debugPrint("Response text: ${response.text!}");
      return AiResponseModel.success(response.text!);
    } on GenerativeAIException catch (e) {
      debugPrint("GenerativeAIException: ${e.message}");
      debugPrint("Exception details: $e");
      throw core_exceptions.ServerException('AI service error: ${e.message}');
    } on FormatException catch (e) {
      debugPrint("FormatException: ${e.message}");
      debugPrint("FormatException source: ${e.source}");
      debugPrint("FormatException offset: ${e.offset}");
      throw core_exceptions.ServerException(
          'Response format error: ${e.message}');
    } catch (e, stackTrace) {
      debugPrint("General exception: ${e.toString()}");
      debugPrint("Stack trace: $stackTrace");
      throw core_exceptions.ServerException(
          'Failed to get AI response: ${e.toString()}');
    }
  }

  @override
  Future<bool> testConnection() async {
    try {
      debugPrint("Testing Gemini API connection...");
      final content = [Content.text("Hello")];
      final response = await model.generateContent(content).timeout(
        const Duration(seconds: 10),
      );
      
      debugPrint("Test response: ${response.text}");
      return response.text != null && response.text!.isNotEmpty;
    } catch (e) {
      debugPrint("Connection test failed: $e");
      return false;
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
