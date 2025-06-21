import '../../domain/entities/quiz_question.dart';
import 'quiz_answer_model.dart';

class QuizQuestionModel extends QuizQuestion {
  QuizQuestionModel({
    required String id,
    required String lessonId,
    required String questionText,
    required QuestionType questionType,
    required int orderIndex,
    required List<QuizAnswerModel> answers,
  }) : super(
          id: id,
          lessonId: lessonId,
          questionText: questionText,
          questionType: questionType,
          orderIndex: orderIndex,
          answers: answers,
        );

  factory QuizQuestionModel.fromJson(Map<String, dynamic> json) {
    return QuizQuestionModel(
      id: json['id'],
      lessonId: json['lessonId'],
      questionText: json['questionText'],
      questionType: QuestionType.values.firstWhere((e) => e.toString() == 'QuestionType.' + json['questionType']),
      orderIndex: json['orderIndex'],
      answers: (json['answers'] as List)
          .map((answer) => QuizAnswerModel.fromJson(answer))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'lessonId': lessonId,
      'questionText': questionText,
      'questionType': questionType.toString().split('.').last,
      'orderIndex': orderIndex,
      'answers': answers.map((answer) => (answer as QuizAnswerModel).toJson()).toList(),
    };
  }
}
