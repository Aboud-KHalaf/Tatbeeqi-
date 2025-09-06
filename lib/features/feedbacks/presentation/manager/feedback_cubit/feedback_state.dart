part of 'feedback_cubit.dart';

abstract class FeedbackState extends Equatable {
  const FeedbackState();

  @override
  List<Object> get props => [];
}

class FeedbackInitial extends FeedbackState {}

class FeedbackLoading extends FeedbackState {}

class FeedbackSubmitted extends FeedbackState {}

class FeedbacksLoaded extends FeedbackState {
  final List<Feedback> feedbacks;

  const FeedbacksLoaded(this.feedbacks);

  @override
  List<Object> get props => [feedbacks];
}

class FeedbackError extends FeedbackState {
  final String message;

  const FeedbackError(this.message);

  @override
  List<Object> get props => [message];
}
