import 'package:equatable/equatable.dart';
import '../../domain/entities/ai_response.dart';

abstract class AiAssistantState extends Equatable {
  const AiAssistantState();

  @override
  List<Object?> get props => [];
}

class AiAssistantInitial extends AiAssistantState {
  const AiAssistantInitial();
}

class AiAssistantLoading extends AiAssistantState {
  const AiAssistantLoading();
}

class AiAssistantSuccess extends AiAssistantState {
  final AiResponse response;

  const AiAssistantSuccess({required this.response});

  @override
  List<Object?> get props => [response];
}

class AiAssistantError extends AiAssistantState {
  final String message;

  const AiAssistantError({required this.message});

  @override
  List<Object?> get props => [message];
}
