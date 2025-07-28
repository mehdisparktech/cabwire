import 'package:cabwire/core/base/result.dart';
import 'package:cabwire/core/config/api/api_end_point.dart';
import 'package:cabwire/data/models/reset_password_model.dart';
import 'package:cabwire/data/services/storage/storage_services.dart';
import 'package:cabwire/domain/services/api_service.dart';
import 'package:cabwire/core/utility/log/app_log.dart';
import 'package:fpdart/fpdart.dart';

abstract class ResetPasswordRemoteDataSource {
  Future<Result<String>> resetPassword({
    required ResetPasswordModel resetPasswordModel,
  });
}

class ResetPasswordRemoteDataSourceImpl
    implements ResetPasswordRemoteDataSource {
  final ApiService _apiService;

  ResetPasswordRemoteDataSourceImpl(this._apiService);

  @override
  Future<Result<String>> resetPassword({
    required ResetPasswordModel resetPasswordModel,
  }) async {
    final result = await _apiService.post(
      ApiEndPoint.changePassword,
      header: {'Authorization': 'Bearer ${LocalStorage.token}'},
      body: resetPasswordModel.toJson(),
    );
    appLog(
      "ResetPasswordRemoteDataSourceImpl ${result.fold((l) => l, (r) => r)}",
    );
    return result.fold(
      (l) => left(l.message.toString()),
      (r) => right(r.data['message'] as String),
    );
  }
}
