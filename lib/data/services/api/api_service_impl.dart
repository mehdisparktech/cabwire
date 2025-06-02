// lib/services/api/api_service_impl.dart
import 'dart:async';
import 'dart:io';
import 'package:cabwire/core/config/api/api_end_point.dart';
import 'package:cabwire/core/utility/log/api_log.dart';
import 'package:cabwire/domain/services/api_service.dart';
import 'package:dio/dio.dart';
import 'package:dartz/dartz.dart';
import 'package:mime/mime.dart';
import '../storage/storage_keys.dart';
import '../storage/storage_services.dart';
import 'api_failure.dart';
import 'api_success.dart';

class ApiServiceImpl implements ApiService {
  static ApiServiceImpl? _instance;
  late Dio _dio;

  // Singleton pattern
  static ApiServiceImpl get instance {
    _instance ??= ApiServiceImpl._();
    return _instance!;
  }

  ApiServiceImpl._() {
    _dio = _getMyDio();
  }

  /// ========== [ HTTP METHODS ] ========== ///
  @override
  Future<Either<ApiFailure, ApiSuccess<Map<String, dynamic>>>> post(
    String url, {
    dynamic body,
    Map<String, String>? header,
  }) => _request(url, "POST", body: body, header: header);

  @override
  Future<Either<ApiFailure, ApiSuccess<Map<String, dynamic>>>> get(
    String url, {
    Map<String, String>? header,
  }) => _request(url, "GET", header: header);

  @override
  Future<Either<ApiFailure, ApiSuccess<Map<String, dynamic>>>> put(
    String url, {
    dynamic body,
    Map<String, String>? header,
  }) => _request(url, "PUT", body: body, header: header);

  @override
  Future<Either<ApiFailure, ApiSuccess<Map<String, dynamic>>>> patch(
    String url, {
    dynamic body,
    Map<String, String>? header,
  }) => _request(url, "PATCH", body: body, header: header);

  @override
  Future<Either<ApiFailure, ApiSuccess<Map<String, dynamic>>>> delete(
    String url, {
    dynamic body,
    Map<String, String>? header,
  }) => _request(url, "DELETE", body: body, header: header);

  @override
  Future<Either<ApiFailure, ApiSuccess<Map<String, dynamic>>>> multipart(
    String url, {
    Map<String, String> header = const {},
    Map<String, String> body = const {},
    String method = "POST",
    String imageName = 'image',
    String? imagePath,
  }) async {
    try {
      FormData formData = FormData();

      if (imagePath != null && imagePath.isNotEmpty) {
        File file = File(imagePath);
        String extension = file.path.split('.').last.toLowerCase();
        String? mimeType = lookupMimeType(imagePath);

        formData.files.add(
          MapEntry(
            imageName,
            await MultipartFile.fromFile(
              imagePath,
              filename: "$imageName.$extension",
              contentType:
                  mimeType != null
                      ? DioMediaType.parse(mimeType)
                      : DioMediaType.parse("image/jpeg"),
            ),
          ),
        );
      }

      body.forEach((key, value) {
        formData.fields.add(MapEntry(key, value));
      });

      header['Content-Type'] = "multipart/form-data";

      return _request(url, method, body: formData, header: header);
    } catch (e) {
      return Left(
        ApiFailure.unknown('Multipart upload failed: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Either<ApiFailure, ApiSuccess<Map<String, dynamic>>>>
  multipartMultipleFiles(
    String url, {
    Map<String, String> header = const {},
    Map<String, String> body = const {},
    String method = "POST",
    Map<String, String>? filePaths,
  }) async {
    try {
      FormData formData = FormData();

      if (filePaths != null) {
        for (var entry in filePaths.entries) {
          String fieldName = entry.key;
          String filePath = entry.value;

          if (filePath.isNotEmpty) {
            File file = File(filePath);
            String extension = file.path.split('.').last.toLowerCase();
            String? mimeType = lookupMimeType(filePath);

            formData.files.add(
              MapEntry(
                fieldName,
                await MultipartFile.fromFile(
                  filePath,
                  filename: "$fieldName.$extension",
                  contentType:
                      mimeType != null
                          ? DioMediaType.parse(mimeType)
                          : DioMediaType.parse("application/octet-stream"),
                ),
              ),
            );
          }
        }
      }

      body.forEach((key, value) {
        formData.fields.add(MapEntry(key, value));
      });

      header['Content-Type'] = "multipart/form-data";

      return _request(url, method, body: formData, header: header);
    } catch (e) {
      return Left(
        ApiFailure.unknown('Multiple file upload failed: ${e.toString()}'),
      );
    }
  }

  /// ========== [ API REQUEST HANDLER ] ========== ///
  Future<Either<ApiFailure, ApiSuccess<Map<String, dynamic>>>> _request(
    String url,
    String method, {
    dynamic body,
    Map<String, String>? header,
  }) async {
    try {
      final response = await _dio.request(
        url,
        data: body,
        options: Options(method: method, headers: header),
      );
      return _handleResponse(response);
    } catch (e) {
      return _handleError(e);
    }
  }

  Either<ApiFailure, ApiSuccess<Map<String, dynamic>>> _handleResponse(
    Response response,
  ) {
    try {
      final statusCode = response.statusCode ?? 500;

      // Success response (200-299)
      if (statusCode >= 200 && statusCode < 300) {
        // Handle 201 as 200 for consistency
        final normalizedStatusCode = statusCode == 201 ? 200 : statusCode;

        final data =
            response.data is Map<String, dynamic>
                ? response.data as Map<String, dynamic>
                : <String, dynamic>{'data': response.data};

        return Right(
          ApiSuccess.fromResponse(normalizedStatusCode, data, rawData: data),
        );
      }

      // Error response
      final errorData =
          response.data is Map<String, dynamic>
              ? response.data as Map<String, dynamic>
              : <String, dynamic>{};

      return Left(ApiFailure.fromResponse(statusCode, errorData));
    } catch (e) {
      return Left(
        ApiFailure.unknown('Response parsing failed: ${e.toString()}'),
      );
    }
  }

  Either<ApiFailure, ApiSuccess<Map<String, dynamic>>> _handleError(
    dynamic error,
  ) {
    try {
      if (error is DioException) {
        return Left(_handleDioException(error));
      }

      // Handle response errors
      if (error.response != null) {
        final errorData =
            error.response.data is Map<String, dynamic>
                ? error.response.data as Map<String, dynamic>
                : <String, dynamic>{};
        return Left(
          ApiFailure.fromResponse(error.response.statusCode ?? 500, errorData),
        );
      }

      return Left(_handleOtherErrors(error));
    } catch (e) {
      return Left(ApiFailure.badRequest());
    }
  }

  ApiFailure _handleDioException(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.sendTimeout:
        return ApiFailure.connectionTimeout();
      case DioExceptionType.connectionError:
        return ApiFailure.noInternet();
      case DioExceptionType.badResponse:
        final errorData =
            error.response?.data is Map<String, dynamic>
                ? error.response!.data as Map<String, dynamic>
                : <String, dynamic>{};
        return ApiFailure.fromResponse(
          error.response?.statusCode ?? 400,
          errorData,
        );
      case DioExceptionType.cancel:
        return ApiFailure(
          statusCode: 499,
          message: 'Request was cancelled',
          errorCode: 'REQUEST_CANCELLED',
        );
      case DioExceptionType.badCertificate:
        return ApiFailure(
          statusCode: 495,
          message: 'SSL certificate error',
          errorCode: 'SSL_ERROR',
        );
      default:
        return ApiFailure.unknown(error.message);
    }
  }

  ApiFailure _handleOtherErrors(dynamic error) {
    if (error is SocketException) {
      return ApiFailure.noInternet();
    } else if (error is FormatException) {
      return ApiFailure.badRequest();
    } else if (error is TimeoutException) {
      return ApiFailure.connectionTimeout();
    } else {
      return ApiFailure.unknown(error.toString());
    }
  }

  /// ========== [ DIO INSTANCE WITH INTERCEPTORS ] ========== ///
  Dio _getMyDio() {
    Dio dio = Dio();

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          final stopwatch = Stopwatch()..start();
          options
            ..headers["Authorization"] ??= "Bearer ${LocalStorage.token}"
            ..headers["Content-Type"] ??= "application/json"
            ..sendTimeout = const Duration(seconds: 30)
            ..receiveTimeout = const Duration(seconds: 30)
            ..baseUrl =
                options.baseUrl.startsWith("http") ? "" : ApiEndPoint.baseUrl
            ..extra["stopwatch"] = stopwatch;

          String storedCookies = LocalStorage.cookie;
          if (storedCookies.isNotEmpty) {
            List<String> cookiesList = storedCookies.split('; ');
            options.headers['Cookie'] = cookiesList;
          }

          apiRequestLog(options);
          handler.next(options);
        },
        onResponse: (response, handler) {
          final stopwatch =
              response.requestOptions.extra["stopwatch"] as Stopwatch?;
          stopwatch?.stop();

          apiResponseLog(response, stopwatch ?? Stopwatch());
          List cookies = response.headers['set-cookie'] ?? [];

          if (cookies.isNotEmpty) {
            String cookieString = cookies.join('; ');
            LocalStorage.cookie = cookieString;
            LocalStorage.setString(LocalStorageKeys.cookie, cookieString);
          }
          handler.next(response);
        },
        onError: (error, handler) {
          final stopwatch =
              error.requestOptions.extra["stopwatch"] as Stopwatch?;
          stopwatch?.stop();
          apiErrorLog(error, stopwatch ?? Stopwatch());
          handler.next(error);
        },
      ),
    );

    return dio;
  }

  /// ========== [ UTILITY METHODS ] ========== ///
  void updateBaseUrl(String newBaseUrl) {
    _dio.options.baseUrl = newBaseUrl;
  }

  void updateTimeout({Duration? sendTimeout, Duration? receiveTimeout}) {
    if (sendTimeout != null) _dio.options.sendTimeout = sendTimeout;
    if (receiveTimeout != null) _dio.options.receiveTimeout = receiveTimeout;
  }

  void addInterceptor(Interceptor interceptor) {
    _dio.interceptors.add(interceptor);
  }

  void removeInterceptor(Interceptor interceptor) {
    _dio.interceptors.remove(interceptor);
  }

  void clearInterceptors() {
    _dio.interceptors.clear();
  }
}
