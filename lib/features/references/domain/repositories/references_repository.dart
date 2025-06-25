import 'package:tatbeeqi/features/references/domain/entities/reference.dart';

abstract class ReferencesRepository {
  Future<List<Reference>> fetchReferences(String courseId);
}
