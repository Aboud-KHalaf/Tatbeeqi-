part of 'send_notification_bloc.dart';

abstract class SendNotificationEvent extends Equatable {
  const SendNotificationEvent();

  @override
  List<Object> get props => [];
}

class SendNotificationToUsers extends SendNotificationEvent {
  final List<String> userIds;
  final String title;
  final String body;

  const SendNotificationToUsers({
    required this.userIds,
    required this.title,
    required this.body,
  });

  @override
  List<Object> get props => [userIds, title, body];
}

class SendNotificationToTopics extends SendNotificationEvent {
  final List<String> topics;
  final String title;
  final String body;

  const SendNotificationToTopics({
    required this.topics,
    required this.title,
    required this.body,
  });

  @override
  List<Object> get props => [topics, title, body];
}
