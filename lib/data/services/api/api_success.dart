// lib/services/api/api_success.dart

class ApiSuccess<T> {
  final int statusCode;
  final String? message;
  final T data;
  final Map<String, dynamic>? meta;
  final Map<String, dynamic>? pagination;

  const ApiSuccess({
    required this.statusCode,
    required this.data,
    this.message,
    this.meta,
    this.pagination,
  });

  factory ApiSuccess.fromResponse(
    int statusCode,
    T data, {
    String? message,
    Map<String, dynamic>? rawData,
  }) {
    return ApiSuccess(
      statusCode: statusCode,
      data: data,
      message: message ?? rawData?['message']?.toString(),
      meta: rawData?['meta'] as Map<String, dynamic>?,
      pagination: rawData?['pagination'] as Map<String, dynamic>?,
    );
  }

  // Helper method to check if response is successful
  bool get isSuccess => statusCode >= 200 && statusCode < 300;

  // Helper method to get success message
  String get successMessage => message ?? 'Operation completed successfully';

  @override
  String toString() {
    return 'ApiSuccess(statusCode: $statusCode, message: $message, dataType: ${T.toString()})';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ApiSuccess<T> &&
        other.statusCode == statusCode &&
        other.message == message &&
        other.data == data;
  }

  @override
  int get hashCode {
    return statusCode.hashCode ^ message.hashCode ^ data.hashCode;
  }
}
