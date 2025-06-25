import 'package:tatbeeqi/features/references/data/models/reference_model.dart';

class MockReferencesDataSource {
  final List<ReferenceModel> references = [
    ReferenceModel(
      id: '1',
      courseId: '1',
      title: 'Official Flutter Documentation',
      url: 'https://flutter.dev/docs',
      type: 'documentation',
    ),
    ReferenceModel(
      id: '2',
      courseId: '1',
      title: 'Dart Language Tour',
      url: 'https://dart.dev/guides/language/language-tour',
      type: 'documentation',
    ),
    ReferenceModel(
      id: '3',
      courseId: '1',
      title: 'Flutter Crash Course for Beginners',
      url: 'https://www.youtube.com/watch?v=x0uinJqfVic',
      type: 'video',
    ),
  ];
}
