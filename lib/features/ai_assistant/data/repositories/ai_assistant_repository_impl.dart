import 'package:dartz/dartz.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/ai_question.dart';
import '../../domain/entities/ai_response.dart';
import '../../domain/repositories/ai_assistant_repository.dart';
import '../datasources/ai_assistant_remote_data_source.dart';
import '../models/ai_question_model.dart';

class AiAssistantRepositoryImpl implements AiAssistantRepository {
  final AiAssistantRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  AiAssistantRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, AiResponse>> askQuestion(AiQuestion question) async {
    if (await networkInfo.isConnected()) {
      try {
        final questionModel = AiQuestionModel.fromEntity(question);
        final response = await remoteDataSource.askQuestion(questionModel);
        return Right(response);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } catch (e) {
        return Left(ServerFailure('Unexpected error occurred'));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }
}
