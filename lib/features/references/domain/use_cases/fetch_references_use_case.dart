import 'package:tatbeeqi/features/references/domain/entities/reference.dart';
import 'package:tatbeeqi/features/references/domain/repositories/references_repository.dart';

class FetchReferencesUseCase {
  final ReferencesRepository repository;

  FetchReferencesUseCase(this.repository);

  Future<List<Reference>> call(String courseId) {
    return repository.fetchReferences(courseId);
  }
}
