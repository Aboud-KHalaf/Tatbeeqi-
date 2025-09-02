import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/ai_question.dart';
import '../entities/ai_response.dart';

abstract class AiAssistantRepository {
  Future<Either<Failure, AiResponse>> askQuestion(AiQuestion question , String userName);
}
