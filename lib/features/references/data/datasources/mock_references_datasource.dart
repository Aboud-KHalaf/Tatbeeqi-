import 'package:tatbeeqi/features/references/data/models/reference_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tatbeeqi/core/error/exceptions.dart';

abstract class ReferencesRemoteDataSource {
  Future<List<ReferenceModel>> fetchReferencesByCourseId(int courseId);
}

class ReferencesRemoteDataSourceImpl implements ReferencesRemoteDataSource {
  final SupabaseClient supabaseClient;

  ReferencesRemoteDataSourceImpl({required this.supabaseClient});

  @override
  Future<List<ReferenceModel>> fetchReferencesByCourseId(int courseId) async {
    try {
      final response = await supabaseClient
          .from('course_references')
          .select()
          .eq('course_id', courseId)
          .order('created_at', ascending: false);

      return (response as List)
          .map((e) => ReferenceModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw ServerException('Error fetching course references: $e');
    }
  }
}
