import '../../domain/entities/ai_response.dart';

class AiResponseModel extends AiResponse {
  const AiResponseModel({
    required super.response,
    required super.timestamp,
    super.error,
  });

  factory AiResponseModel.fromJson(Map<String, dynamic> json) {
    return AiResponseModel(
      response: json['response'] ?? '',
      timestamp: DateTime.parse(json['timestamp']),
      error: json['error'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'response': response,
      'timestamp': timestamp.toIso8601String(),
      'error': error,
    };
  }

  factory AiResponseModel.fromEntity(AiResponse entity) {
    return AiResponseModel(
      response: entity.response,
      timestamp: entity.timestamp,
      error: entity.error,
    );
  }

  factory AiResponseModel.success(String response) {
    return AiResponseModel(
      response: response,
      timestamp: DateTime.now(),
    );
  }

  factory AiResponseModel.failure(String error) {
    return AiResponseModel(
      response: '',
      timestamp: DateTime.now(),
      error: error,
    );
  }
}
