import 'package:tatbeeqi/features/forums/data/models/forum_discussion_model.dart';

class MockForumsDataSource {
  final List<ForumDiscussionModel> discussions = [
    ForumDiscussionModel(
      id: '1',
      courseId: '1',
      title: 'Having trouble with state management',
      author: 'John Doe',
      replies: 15,
      lastUpdate: DateTime.now().subtract(const Duration(days: 1)),
    ),
    ForumDiscussionModel(
      id: '2',
      courseId: '1',
      title: 'Question about the final project',
      author: 'Jane Smith',
      replies: 8,
      lastUpdate: DateTime.now().subtract(const Duration(hours: 5)),
    ),
    ForumDiscussionModel(
      id: '3',
      courseId: '1',
      title: 'Best resources for learning Dart?',
      author: 'Peter Jones',
      replies: 22,
      lastUpdate: DateTime.now().subtract(const Duration(days: 3)),
    ),
  ];
}
