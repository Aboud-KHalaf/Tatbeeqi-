import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:uuid/uuid.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tatbeeqi/core/usecases/usecase.dart';
import 'package:tatbeeqi/features/feedbacks/domain/entities/feedback.dart';
import 'package:tatbeeqi/features/feedbacks/domain/usecases/submit_feedback_usecase.dart';
import 'package:tatbeeqi/features/feedbacks/domain/usecases/get_user_feedbacks_usecase.dart';

part 'feedback_state.dart';

class FeedbackCubit extends Cubit<FeedbackState> {
  final SubmitFeedbackUseCase submitFeedbackUseCase;
  final GetUserFeedbacksUseCase getUserFeedbacksUseCase;

  FeedbackCubit({
    required this.submitFeedbackUseCase,
    required this.getUserFeedbacksUseCase,
  }) : super(FeedbackInitial());

  Future<void> submitFeedback({
    required FeedbackType type,
    required String title,
    required String description,
    String? screenshotUrl,
    Map<String, dynamic>? deviceInfo,
    String? appVersion,
  }) async {
    emit(FeedbackLoading());

    final currentUser = Supabase.instance.client.auth.currentUser;
    if (currentUser == null) {
      emit(const FeedbackError('User not authenticated'));
      return;
    }

    final feedback = Feedback(
      id: const Uuid().v4(),
      userId: currentUser.id,
      type: type,
      title: title,
      description: description,
      screenshotUrl: screenshotUrl,
      deviceInfo: deviceInfo,
      appVersion: appVersion,
      createdAt: DateTime.now(),
      status: FeedbackStatus.pending,
    );

    final result = await submitFeedbackUseCase(feedback);
    result.fold(
      (failure) => emit(FeedbackError(failure.message)),
      (_) => emit(FeedbackSubmitted()),
    );
  }

  Future<void> getUserFeedbacks() async {
    emit(FeedbackLoading());

    final result = await getUserFeedbacksUseCase(NoParams());
    result.fold(
      (failure) => emit(FeedbackError(failure.message)),
      (feedbacks) => emit(FeedbacksLoaded(feedbacks)),
    );
  }
}
