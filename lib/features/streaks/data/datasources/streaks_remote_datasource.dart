import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/error/exceptions.dart';
import '../models/user_streak_model.dart';

abstract class StreaksRemoteDataSource {
  Future<UserStreakModel> getUserStreak(String userId);
  Future<void> updateStreakOnLessonComplete(String userId);
}

class StreaksRemoteDataSourceImpl implements StreaksRemoteDataSource {
  final SupabaseClient supabaseClient;

  StreaksRemoteDataSourceImpl({required this.supabaseClient});

  @override
  Future<UserStreakModel> getUserStreak(String userId) async {
    try {
      final response = await supabaseClient
          .from('user_streaks')
          .select()
          .eq('user_id', userId)
          .maybeSingle();

      if (response == null) {
        // Create initial streak record if doesn't exist
        await supabaseClient.from('user_streaks').insert({
          'user_id': userId,
          'current_streak': 0,
          'longest_streak': 0,
          'last_completed_date': null,
        });

        return const UserStreakModel(
          userId: '',
          currentStreak: 0,
          longestStreak: 0,
          lastCompletedDate: null,
        );
      }

      return UserStreakModel.fromJson(response);
    } catch (e) {
      throw ServerException('Failed to fetch user streak: $e');
    }
  }

  @override
  Future<void> updateStreakOnLessonComplete(String userId) async {
    try {
      // Call the Supabase Edge Function or stored procedure that handles streak logic
      await supabaseClient.rpc('update_user_streak', params: {
        'p_user_id': userId,
      });
    } catch (e) {
      throw ServerException( 'Failed to update streak: $e');
    }
  }
}
