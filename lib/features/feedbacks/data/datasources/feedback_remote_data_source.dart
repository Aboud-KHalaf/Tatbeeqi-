import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tatbeeqi/features/feedbacks/data/models/feedback_model.dart';

abstract class FeedbackRemoteDataSource {
  Future<void> submitFeedback(FeedbackModel feedback);
  Future<List<FeedbackModel>> getUserFeedbacks();
}

class FeedbackRemoteDataSourceImpl implements FeedbackRemoteDataSource {
  final SupabaseClient supabaseClient;

  FeedbackRemoteDataSourceImpl({required this.supabaseClient});

  @override
  Future<void> submitFeedback(FeedbackModel feedback) async {
    try {
      await supabaseClient.from('feedbacks').insert(feedback.toJson());
    } catch (e) {
      throw Exception('Failed to submit feedback: $e');
    }
  }

  @override
  Future<List<FeedbackModel>> getUserFeedbacks() async {
    try {
      final response = await supabaseClient
          .from('feedbacks')
          .select()
          .eq('user_id', supabaseClient.auth.currentUser!.id)
          .order('created_at', ascending: false);

      return (response as List)
          .map((json) => FeedbackModel.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to get user feedbacks: $e');
    }
  }
}
