import 'package:cabwire/data/datasources/remote/passenger/reset_password_remote_data_source.dart';
import 'package:cabwire/data/models/reset_password_model.dart';
import 'package:cabwire/domain/repositories/passenger/reset_password_repository.dart';
import 'package:cabwire/domain/services/error_message_handler.dart';
import 'package:cabwire/core/base/result.dart';
import 'package:fpdart/fpdart.dart';

class ResetPasswordRepositoryImpl implements ResetPasswordRepository {
  final ResetPasswordRemoteDataSource _resetPasswordRemoteDataSource;
  final ErrorMessageHandler _errorMessageHandler;

  ResetPasswordRepositoryImpl(
    this._resetPasswordRemoteDataSource,
    this._errorMessageHandler,
  );

  @override
  Future<Result<String>> resetPassword({
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    try {
      final resetPasswordModel = ResetPasswordModel(
        currentPassword: currentPassword,
        newPassword: newPassword,
        confirmPassword: confirmPassword,
      );

      final result = await _resetPasswordRemoteDataSource.resetPassword(
        resetPasswordModel: resetPasswordModel,
      );

      return result.fold(
        (failure) => left(_errorMessageHandler.generateErrorMessage(failure)),
        (success) => right(success),
      );
    } catch (e) {
      return left(e.toString());
    }
  }
}
