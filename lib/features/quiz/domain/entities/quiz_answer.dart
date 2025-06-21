class QuizAnswer {
  final String id;
  final String questionId;
  final String answerText;
  final bool isCorrect;

  QuizAnswer({
    required this.id,
    required this.questionId,
    required this.answerText,
    required this.isCorrect,
  });
}
