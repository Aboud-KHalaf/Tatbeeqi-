import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import '../../features/ai_assistant/data/datasources/ai_assistant_remote_data_source.dart';
import '../../features/ai_assistant/data/repositories/ai_assistant_repository_impl.dart';
import '../../features/ai_assistant/domain/repositories/ai_assistant_repository.dart';
import '../../features/ai_assistant/domain/usecases/ask_ai_question.dart';
import '../../features/ai_assistant/presentation/cubit/ai_assistant_cubit.dart';

void initAiAssistantDependencies(GetIt sl) {
  // External dependencies
  final apiKey = dotenv.env['GEMINI_API_KEY'];
  if (apiKey == null || apiKey.isEmpty) {
    throw Exception('GEMINI_API_KEY not found in environment variables');
  }

  final model = GenerativeModel(
    model: 'gemini-1.5-flash',
    apiKey: apiKey,
    generationConfig: GenerationConfig(
      temperature: 0.7,
      topK: 40,
      topP: 0.95,
      maxOutputTokens: 2048,
    ),
    safetySettings: [
      SafetySetting(HarmCategory.harassment, HarmBlockThreshold.medium),
      SafetySetting(HarmCategory.hateSpeech, HarmBlockThreshold.medium),
      SafetySetting(HarmCategory.sexuallyExplicit, HarmBlockThreshold.medium),
      SafetySetting(HarmCategory.dangerousContent, HarmBlockThreshold.medium),
    ],
  );

  sl.registerLazySingleton<GenerativeModel>(() => model);

  // Data sources
  sl.registerLazySingleton<AiAssistantRemoteDataSource>(
    () => AiAssistantRemoteDataSourceImpl(model: sl()),
  );

  // Repository
  sl.registerLazySingleton<AiAssistantRepository>(
    () => AiAssistantRepositoryImpl(
      remoteDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => AskAiQuestion(sl()));

  // Cubit
  sl.registerFactory(() => AiAssistantCubit(askAiQuestion: sl()));
}
