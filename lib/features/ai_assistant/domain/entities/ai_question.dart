import 'package:equatable/equatable.dart';

class AiQuestion extends Equatable {
  final String question;
  final DateTime timestamp;
  final String? context;

  const AiQuestion({
    required this.question,
    required this.timestamp,
    this.context,
  });

  @override
  List<Object?> get props => [question, timestamp, context];

  @override
  String toString() => 'AiQuestion(question: $question, timestamp: $timestamp, context: $context)';
}
