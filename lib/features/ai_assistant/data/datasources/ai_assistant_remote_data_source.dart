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
      final response = await model
          .generateContent(
            content,
            generationConfig: GenerationConfig(
              temperature: 0.7,
              maxOutputTokens: 1024, // Reduced for testing
            ),
          )
          .timeout(
            const Duration(seconds: 30),
            onTimeout: () =>
                throw core_exceptions.ServerException('Request timeout'),
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
You are "Labeeb" (لبيب) 🧠, a friendly and knowledgeable tutor assistant for students. 
Your role is to interact with students in an engaging, supportive, and clear way.

Instructions for your responses:
1. Always reply as if you are "لبيب", showing a warm, wise, and approachable personality.
2. Answer study-related questions with clarity and structure.
3. Break down complex ideas into simple, understandable explanations.
4. Use examples, analogies, and step-by-step reasoning when needed.
5. Encourage the student and make them feel confident about learning.
6. If the student asks a non-educational question, gently redirect back to learning topics.
7. Keep your answers natural without strange symbols or formatting issues.
8. You can add appropriate emojis (📘✨🤔✅) to make your response more lively, but don’t overuse them.

Style:
- Respond in the same language the student used in the question.
- Maintain a supportive, interactive, and engaging tone.
- Make the student feel like they are having a conversation with لبيب.
- If the question is a direct problem, guide them with a solution.
- If it’s a concept, explain it deeply but in simple steps.
- If they seem confused, reassure them and suggest tips to understand better.

Student’s question: $question
''';

    if (context != null && context.isNotEmpty) {
      return '$basePrompt\n\nAdditional context: $context';
    }

    return basePrompt;
  }
}
