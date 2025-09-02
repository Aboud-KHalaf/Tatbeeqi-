import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/ai_question.dart';
import '../entities/ai_response.dart';
import '../repositories/ai_assistant_repository.dart';

class AskAiQuestion implements UseCase<AiResponse, AiQuestionParams> {
  final AiAssistantRepository repository;

  AskAiQuestion(this.repository);

  @override
  Future<Either<Failure, AiResponse>> call(AiQuestionParams params) async {
    return await repository.askQuestion(params.question , params.userName);
  }
}

class AiQuestionParams {
  final AiQuestion question;
  final String userName;

  AiQuestionParams({required this.question , required this.userName});
}
