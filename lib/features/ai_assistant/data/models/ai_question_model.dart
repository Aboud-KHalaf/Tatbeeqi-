import '../../domain/entities/ai_question.dart';

class AiQuestionModel extends AiQuestion {
  const AiQuestionModel({
    required super.question,
    required super.timestamp,
    super.context,
  });

  factory AiQuestionModel.fromJson(Map<String, dynamic> json) {
    return AiQuestionModel(
      question: json['question'] ?? '',
      timestamp: DateTime.parse(json['timestamp']),
      context: json['context'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'question': question,
      'timestamp': timestamp.toIso8601String(),
      'context': context,
    };
  }

  factory AiQuestionModel.fromEntity(AiQuestion entity) {
    return AiQuestionModel(
      question: entity.question,
      timestamp: entity.timestamp,
      context: entity.context,
    );
  }

  factory AiQuestionModel.create(String question, {String? context}) {
    return AiQuestionModel(
      question: question,
      timestamp: DateTime.now(),
      context: context,
    );
  }
}
