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
      id: json['id']?.toString() ?? '',
      lessonId: json['lessonId']?.toString() ?? '',
      questionText: json['questionText']?.toString() ?? '',
      questionType: _parseQuestionType(json['questionType']),
      orderIndex: json['orderIndex'] ?? 0,
      answers: (json['answers'] as List? ?? [])
          .map((answer) => QuizAnswerModel.fromJson(answer as Map<String, dynamic>))
          .toList(),
    );
  }

  static QuestionType _parseQuestionType(dynamic questionType) {
    if (questionType == null) return QuestionType.multipleChoice;
    
    final typeString = questionType.toString().toLowerCase();
    
    switch (typeString) {
      case 'multiplechoice':
      case 'multiple_choice':
      case 'multiple choice':
        return QuestionType.multipleChoice;
      case 'truefalse':
      case 'true_false':
      case 'true false':
        return QuestionType.trueFalse;
      default:
        print('Warning: Unknown question type "$questionType", defaulting to multipleChoice');
        return QuestionType.multipleChoice;
    }
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
