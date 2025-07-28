// lib/services/api/api_service.dart
import 'package:cabwire/data/services/api/api_failure.dart';
import 'package:cabwire/data/services/api/api_success.dart';
import 'package:dartz/dartz.dart';

abstract class ApiService {
  Future<Either<ApiFailure, ApiSuccess<Map<String, dynamic>>>> post(
    String url, {
    dynamic body,
    Map<String, String>? header,
  });

  Future<Either<ApiFailure, ApiSuccess<Map<String, dynamic>>>> get(
    String url, {
    Map<String, String>? header,
  });

  Future<Either<ApiFailure, ApiSuccess<Map<String, dynamic>>>> put(
    String url, {
    dynamic body,
    Map<String, String>? header,
  });

  Future<Either<ApiFailure, ApiSuccess<Map<String, dynamic>>>> patch(
    String url, {
    dynamic body,
    Map<String, String>? header,
  });

  Future<Either<ApiFailure, ApiSuccess<Map<String, dynamic>>>> delete(
    String url, {
    dynamic body,
    Map<String, String>? header,
  });

  Future<Either<ApiFailure, ApiSuccess<Map<String, dynamic>>>> multipart(
    String url, {
    Map<String, String> header,
    Map<String, String> body,
    String method,
    String imageName,
    String? imagePath,
  });

  Future<Either<ApiFailure, ApiSuccess<Map<String, dynamic>>>>
  multipartMultipleFiles(
    String url, {
    Map<String, String> header,
    Map<String, String> body,
    String method,
    Map<String, String>? filePaths,
  });
}
