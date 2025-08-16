import 'package:equatable/equatable.dart';

class AiResponse extends Equatable {
  final String response;
  final DateTime timestamp;
  final String? error;

  const AiResponse({
    required this.response,
    required this.timestamp,
    this.error,
  });

  bool get hasError => error != null;

  @override
  List<Object?> get props => [response, timestamp, error];

  @override
  String toString() => 'AiResponse(response: $response, timestamp: $timestamp, error: $error)';
}
