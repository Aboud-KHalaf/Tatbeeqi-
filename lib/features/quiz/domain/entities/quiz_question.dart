import 'quiz_answer.dart';

enum QuestionType { multipleChoice, trueFalse }

class QuizQuestion {
  final String id;
  final String lessonId;
  final String questionText;
  final QuestionType questionType;
  final int orderIndex;
  final List<QuizAnswer> answers;

  QuizQuestion({
    required this.id,
    required this.lessonId,
    required this.questionText,
    required this.questionType,
    required this.orderIndex,
    required this.answers,
  });
}
