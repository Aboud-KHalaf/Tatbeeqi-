import '../models/quiz_question_model.dart';

abstract class QuizLocalDataSource {
  Future<List<QuizQuestionModel>> getQuizQuestions(String lessonId);
}

class QuizLocalDataSourceImpl implements QuizLocalDataSource {
  @override
  Future<List<QuizQuestionModel>> getQuizQuestions(String lessonId) async {
    // Mock data
    await Future.delayed(const Duration(seconds: 1)); // Simulate network delay
    final mockData = {
      'questions': [
  {
    'id': 'q1',
    'lessonId': 'l1',
    'questionText': 'ما هي عاصمة فرنسا؟',
    'questionType': 'multipleChoice',
    'orderIndex': 1,
    'answers': [
      {'id': 'a1', 'questionId': 'q1', 'answerText': 'برلين', 'isCorrect': false},
      {'id': 'a2', 'questionId': 'q1', 'answerText': 'مدريد', 'isCorrect': false},
      {'id': 'a3', 'questionId': 'q1', 'answerText': 'باريس', 'isCorrect': true},
      {'id': 'a4', 'questionId': 'q1', 'answerText': 'روما', 'isCorrect': false},
    ],
  },
  {
    'id': 'q2',
    'lessonId': 'l1',
    'questionText': 'الأرض مسطحة.',
    'questionType': 'trueFalse',
    'orderIndex': 2,
    'answers': [
      {'id': 'a5', 'questionId': 'q2', 'answerText': 'صحيح', 'isCorrect': false},
      {'id': 'a6', 'questionId': 'q2', 'answerText': 'خطأ', 'isCorrect': true},
    ],
  },
  // {
  //   'id': 'q3',
  //   'lessonId': 'l1',
  //   'questionText': 'أي كوكب يُعرف بالكوكب الأحمر؟',
  //   'questionType': 'multipleChoice',
  //   'orderIndex': 3,
  //   'answers': [
  //     {'id': 'a7', 'questionId': 'q3', 'answerText': 'الأرض', 'isCorrect': false},
  //     {'id': 'a8', 'questionId': 'q3', 'answerText': 'المريخ', 'isCorrect': true},
  //     {'id': 'a9', 'questionId': 'q3', 'answerText': 'المشتري', 'isCorrect': false},
  //     {'id': 'a10', 'questionId': 'q3', 'answerText': 'زحل', 'isCorrect': false},
  //   ],
  // },
  // {
  //   'id': 'q4',
  //   'lessonId': 'l1',
  //   'questionText': 'من هو مخترع المصباح الكهربائي؟',
  //   'questionType': 'multipleChoice',
  //   'orderIndex': 4,
  //   'answers': [
  //     {'id': 'a11', 'questionId': 'q4', 'answerText': 'ألكسندر غراهام بيل', 'isCorrect': false},
  //     {'id': 'a12', 'questionId': 'q4', 'answerText': 'توماس إديسون', 'isCorrect': true},
  //     {'id': 'a13', 'questionId': 'q4', 'answerText': 'ألبرت أينشتاين', 'isCorrect': false},
  //     {'id': 'a14', 'questionId': 'q4', 'answerText': 'نيكولا تسلا', 'isCorrect': false},
  //   ],
  // },
  // {
  //   'id': 'q5',
  //   'lessonId': 'l1',
  //   'questionText': 'اللغة العربية تُكتب من اليسار إلى اليمين.',
  //   'questionType': 'trueFalse',
  //   'orderIndex': 5,
  //   'answers': [
  //     {'id': 'a15', 'questionId': 'q5', 'answerText': 'صحيح', 'isCorrect': false},
  //     {'id': 'a16', 'questionId': 'q5', 'answerText': 'خطأ', 'isCorrect': true},
  //   ],
  // },
  // {
  //   'id': 'q6',
  //   'lessonId': 'l1',
  //   'questionText': 'كم عدد قارات العالم؟',
  //   'questionType': 'multipleChoice',
  //   'orderIndex': 6,
  //   'answers': [
  //     {'id': 'a17', 'questionId': 'q6', 'answerText': '5', 'isCorrect': false},
  //     {'id': 'a18', 'questionId': 'q6', 'answerText': '6', 'isCorrect': false},
  //     {'id': 'a19', 'questionId': 'q6', 'answerText': '7', 'isCorrect': true},
  //     {'id': 'a20', 'questionId': 'q6', 'answerText': '8', 'isCorrect': false},
  //   ],
  // },
  // {
  //   'id': 'q7',
  //   'lessonId': 'l1',
  //   'questionText': 'أي من التالي ليس من لغات البرمجة؟',
  //   'questionType': 'multipleChoice',
  //   'orderIndex': 7,
  //   'answers': [
  //     {'id': 'a21', 'questionId': 'q7', 'answerText': 'بايثون', 'isCorrect': false},
  //     {'id': 'a22', 'questionId': 'q7', 'answerText': 'جافا', 'isCorrect': false},
  //     {'id': 'a23', 'questionId': 'q7', 'answerText': 'HTML', 'isCorrect': true},
  //     {'id': 'a24', 'questionId': 'q7', 'answerText': 'كوتلن', 'isCorrect': false},
  //   ],
  // },
  // {
  //   'id': 'q8',
  //   'lessonId': 'l1',
  //   'questionText': 'ماذا ينتج عن جمع 5 + 7؟',
  //   'questionType': 'multipleChoice',
  //   'orderIndex': 8,
  //   'answers': [
  //     {'id': 'a25', 'questionId': 'q8', 'answerText': '11', 'isCorrect': false},
  //     {'id': 'a26', 'questionId': 'q8', 'answerText': '12', 'isCorrect': true},
  //     {'id': 'a27', 'questionId': 'q8', 'answerText': '13', 'isCorrect': false},
  //     {'id': 'a28', 'questionId': 'q8', 'answerText': '14', 'isCorrect': false},
  //   ],
  // },
  // {
  //   'id': 'q9',
  //   'lessonId': 'l1',
  //   'questionText': 'الإنترنت أسرع من البريد التقليدي.',
  //   'questionType': 'trueFalse',
  //   'orderIndex': 9,
  //   'answers': [
  //     {'id': 'a29', 'questionId': 'q9', 'answerText': 'صحيح', 'isCorrect': true},
  //     {'id': 'a30', 'questionId': 'q9', 'answerText': 'خطأ', 'isCorrect': false},
  //   ],
  // },
  // {
  //   'id': 'q10',
  //   'lessonId': 'l1',
  //   'questionText': 'ما هو أكبر محيط في العالم؟',
  //   'questionType': 'multipleChoice',
  //   'orderIndex': 10,
  //   'answers': [
  //     {'id': 'a31', 'questionId': 'q10', 'answerText': 'المحيط الأطلسي', 'isCorrect': false},
  //     {'id': 'a32', 'questionId': 'q10', 'answerText': 'المحيط الهندي', 'isCorrect': false},
  //     {'id': 'a33', 'questionId': 'q10', 'answerText': 'المحيط الهادئ', 'isCorrect': true},
  //     {'id': 'a34', 'questionId': 'q10', 'answerText': 'المحيط المتجمد الشمالي', 'isCorrect': false},
  //   ],
  // },
],

    };

    return (mockData['questions'] as List)
        .map((q) => QuizQuestionModel.fromJson(q))
        .toList();
  }
}
