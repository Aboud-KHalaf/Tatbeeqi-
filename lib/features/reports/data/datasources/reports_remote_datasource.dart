import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tatbeeqi/core/error/exceptions.dart';
import 'package:tatbeeqi/features/reports/data/models/report_model.dart';
import 'package:tatbeeqi/features/reports/domain/entities/report.dart';

abstract class ReportsRemoteDataSource {
  Future<ReportModel> addReport({
    required ReportType reportType,
    String? postId,
    int? lessonId,
    required String reason,
  });

  Future<List<ReportModel>> getMyReports();
  Future<List<ReportModel>> getAllReports();
  Future<ReportModel> updateReportStatus({
    required String reportId,
    required ReportStatus status,
  });
}

class ReportsRemoteDataSourceImpl implements ReportsRemoteDataSource {
  final SupabaseClient supabaseClient;

  ReportsRemoteDataSourceImpl({required this.supabaseClient});

  @override
  Future<ReportModel> addReport({
    required ReportType reportType,
    String? postId,
    int? lessonId,
    required String reason,
  }) async {
    try {
      final userId = supabaseClient.auth.currentUser?.id;
      if (userId == null) {
        throw const AuthException('User not authenticated');
      }

      final data = {
        'reporter_id': userId,
        'report_type': _reportTypeToString(reportType),
        'reason': reason,
        'status': 'pending',
      };

      // Add postId or lessonId based on report type
      if (reportType == ReportType.post && postId != null) {
        data['post_id'] = postId;
      } else if (reportType == ReportType.lesson && lessonId != null) {
        data['lesson_id'] = lessonId.toString();
      }

      final response =
          await supabaseClient.from('reports').insert(data).select().single();

      return ReportModel.fromJson(response);
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    } on AuthException catch (e) {
      throw AuthException(e.message);
    } catch (e) {
      throw ServerException('Failed to add report: ${e.toString()}');
    }
  }

  @override
  Future<List<ReportModel>> getMyReports() async {
    try {
      final userId = supabaseClient.auth.currentUser?.id;
      if (userId == null) {
        throw const AuthException('User not authenticated');
      }

      final response = await supabaseClient
          .from('reports')
          .select()
          .eq('reporter_id', userId)
          .order('created_at', ascending: false);

      return response
          .map<ReportModel>((json) => ReportModel.fromJson(json))
          .toList();
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    } on AuthException catch (e) {
      throw AuthException(e.message);
    } catch (e) {
      throw ServerException('Failed to fetch reports: ${e.toString()}');
    }
  }

  @override
  Future<List<ReportModel>> getAllReports() async {
    try {
      final response = await supabaseClient
          .from('reports')
          .select()
          .order('created_at', ascending: false);

      return response
          .map<ReportModel>((json) => ReportModel.fromJson(json))
          .toList();
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException('Failed to fetch all reports: ${e.toString()}');
    }
  }

  @override
  Future<ReportModel> updateReportStatus({
    required String reportId,
    required ReportStatus status,
  }) async {
    try {
      final response = await supabaseClient
          .from('reports')
          .update({'status': _reportStatusToString(status)})
          .eq('id', reportId)
          .select()
          .single();

      return ReportModel.fromJson(response);
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException('Failed to update report status: ${e.toString()}');
    }
  }

  String _reportTypeToString(ReportType type) {
    switch (type) {
      case ReportType.post:
        return 'post';
      case ReportType.lesson:
        return 'lesson';
    }
  }

  String _reportStatusToString(ReportStatus status) {
    switch (status) {
      case ReportStatus.pending:
        return 'pending';
      case ReportStatus.reviewed:
        return 'reviewed';
      case ReportStatus.dismissed:
        return 'dismissed';
    }
  }
}
