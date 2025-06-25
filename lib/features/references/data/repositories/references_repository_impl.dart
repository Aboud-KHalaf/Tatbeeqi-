import 'package:tatbeeqi/features/courses_content/data/datasources/mock_references_datasource.dart';
import 'package:tatbeeqi/features/references/domain/entities/reference.dart';
import 'package:tatbeeqi/features/references/domain/repositories/references_repository.dart';

class ReferencesRepositoryImpl implements ReferencesRepository {
  final MockReferencesDataSource dataSource;

  ReferencesRepositoryImpl(this.dataSource);

  @override
  Future<List<Reference>> fetchReferences(String courseId) async {
    return dataSource.references
        .where((reference) => reference.courseId == courseId)
        .toList();
  }
}
