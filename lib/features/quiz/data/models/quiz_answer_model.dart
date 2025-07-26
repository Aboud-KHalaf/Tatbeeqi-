import '../../domain/entities/quiz_answer.dart';

class QuizAnswerModel extends QuizAnswer {
  QuizAnswerModel({
    required String id,
    required String questionId,
    required String answerText,
    required bool isCorrect,
  }) : super(
          id: id,
          questionId: questionId,
          answerText: answerText,
          isCorrect: isCorrect,
        );

  factory QuizAnswerModel.fromJson(Map<String, dynamic> json) {
    return QuizAnswerModel(
      id: json['id']?.toString() ?? '',
      questionId: json['question_id']?.toString() ?? json['questionId']?.toString() ?? '',
      answerText: json['answer_text']?.toString() ?? json['answerText']?.toString() ?? '',
      isCorrect: json['is_correct'] ?? json['isCorrect'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'questionId': questionId,
      'answerText': answerText,
      'isCorrect': isCorrect,
    };
  }
}
