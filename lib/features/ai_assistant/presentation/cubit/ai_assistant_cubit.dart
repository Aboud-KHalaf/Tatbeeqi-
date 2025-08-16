import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/ai_question.dart';
import '../../domain/usecases/ask_ai_question.dart';
import 'ai_assistant_state.dart';

class AiAssistantCubit extends Cubit<AiAssistantState> {
  final AskAiQuestion askAiQuestion;

  AiAssistantCubit({required this.askAiQuestion}) : super(const AiAssistantInitial());

  Future<void> askQuestion(String question, {String? context}) async {
    if (question.trim().isEmpty) {
      emit(const AiAssistantError(message: 'Please enter a question'));
      return;
    }

    emit(const AiAssistantLoading());

    final aiQuestion = AiQuestion(
      question: question.trim(),
      timestamp: DateTime.now(),
      context: context,
    );

    final result = await askAiQuestion(AiQuestionParams(question: aiQuestion));

    result.fold(
      (failure) => emit(AiAssistantError(message: failure.message)),
      (response) => emit(AiAssistantSuccess(response: response)),
    );
  }

  void reset() {
    emit(const AiAssistantInitial());
  }

  void clearError() {
    if (state is AiAssistantError) {
      emit(const AiAssistantInitial());
    }
  }
}
