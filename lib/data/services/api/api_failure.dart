// lib/services/api/api_failure.dart

class ApiFailure {
  final int statusCode;
  final String message;
  final String? errorCode;
  final Map<String, dynamic>? details;

  const ApiFailure({
    required this.statusCode,
    required this.message,
    this.errorCode,
    this.details,
  });

  // Predefined failures
  factory ApiFailure.connectionTimeout() => const ApiFailure(
    statusCode: 408,
    message: 'Request Time Out',
    errorCode: 'CONNECTION_TIMEOUT',
  );

  factory ApiFailure.noInternet() => const ApiFailure(
    statusCode: 503,
    message: 'No internet connection',
    errorCode: 'NO_INTERNET',
  );

  factory ApiFailure.serverError() => const ApiFailure(
    statusCode: 502,
    message: 'Please, start the Server',
    errorCode: 'SERVER_ERROR',
  );

  factory ApiFailure.badRequest() => const ApiFailure(
    statusCode: 400,
    message: 'Bad Response Request',
    errorCode: 'BAD_REQUEST',
  );

  factory ApiFailure.unauthorized() => const ApiFailure(
    statusCode: 401,
    message: 'Unauthorized access',
    errorCode: 'UNAUTHORIZED',
  );

  factory ApiFailure.forbidden() => const ApiFailure(
    statusCode: 403,
    message: 'Access forbidden',
    errorCode: 'FORBIDDEN',
  );

  factory ApiFailure.notFound() => const ApiFailure(
    statusCode: 404,
    message: 'Resource not found',
    errorCode: 'NOT_FOUND',
  );

  factory ApiFailure.unknown([String? message]) => ApiFailure(
    statusCode: 500,
    message: message ?? 'Some Thing Wrong',
    errorCode: 'UNKNOWN_ERROR',
  );

  factory ApiFailure.fromResponse(int statusCode, Map<String, dynamic>? data) {
    return ApiFailure(
      statusCode: statusCode,
      message: data?['message']?.toString() ?? _getDefaultMessage(statusCode),
      errorCode:
          data?['error_code']?.toString() ?? _getDefaultErrorCode(statusCode),
      details: data,
    );
  }

  static String _getDefaultMessage(int statusCode) {
    switch (statusCode) {
      case 400:
        return 'Bad request';
      case 401:
        return 'Unauthorized';
      case 403:
        return 'Forbidden';
      case 404:
        return 'Not found';
      case 408:
        return 'Request Time Out';
      case 500:
        return 'Internal server error';
      case 502:
        return 'Please, start the Server';
      case 503:
        return 'No internet connection';
      default:
        return 'Some Thing Wrong';
    }
  }

  static String _getDefaultErrorCode(int statusCode) {
    switch (statusCode) {
      case 400:
        return 'BAD_REQUEST';
      case 401:
        return 'UNAUTHORIZED';
      case 403:
        return 'FORBIDDEN';
      case 404:
        return 'NOT_FOUND';
      case 408:
        return 'REQUEST_TIMEOUT';
      case 500:
        return 'INTERNAL_SERVER_ERROR';
      case 502:
        return 'BAD_GATEWAY';
      case 503:
        return 'SERVICE_UNAVAILABLE';
      default:
        return 'UNKNOWN_ERROR';
    }
  }

  @override
  String toString() {
    return 'ApiFailure(statusCode: $statusCode, message: $message, errorCode: $errorCode)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ApiFailure &&
        other.statusCode == statusCode &&
        other.message == message &&
        other.errorCode == errorCode;
  }

  @override
  int get hashCode {
    return statusCode.hashCode ^ message.hashCode ^ errorCode.hashCode;
  }
}
