import 'package:cabwire/core/config/api/api_end_point.dart';
import 'package:cabwire/data/models/reset_password_model.dart';
import 'package:cabwire/data/services/api/api_failure.dart';
import 'package:cabwire/data/services/api/api_success.dart';
import 'package:cabwire/data/services/storage/storage_services.dart';
import 'package:cabwire/domain/services/api_service.dart';
import 'package:dartz/dartz.dart';

abstract class ResetPasswordRemoteDataSource {
  Future<Either<ApiFailure, ApiSuccess<Map<String, dynamic>>>> resetPassword({
    required ResetPasswordModel resetPasswordModel,
  });
}

class ResetPasswordRemoteDataSourceImpl
    implements ResetPasswordRemoteDataSource {
  final ApiService _apiService;

  ResetPasswordRemoteDataSourceImpl(this._apiService);

  @override
  Future<Either<ApiFailure, ApiSuccess<Map<String, dynamic>>>> resetPassword({
    required ResetPasswordModel resetPasswordModel,
  }) async {
    return await _apiService.post(
      ApiEndPoint.changePassword,
      header: {'Authorization': 'Bearer ${LocalStorage.token}'},
      body: resetPasswordModel.toJson(),
    );
  }
}
