import 'package:cabwire/core/base/base_use_case.dart';
import 'package:cabwire/core/base/result.dart';
import 'package:cabwire/domain/repositories/driver/driver_auth_repository.dart';

class DriverResetPasswordUsecase extends BaseUseCase<String> {
  final DriverAuthRepository _driverAuthRepository;

  DriverResetPasswordUsecase(
    super.errorMessageHandler,
    this._driverAuthRepository,
  );

  Future<Result<String>> execute(
    String token,
    String newpassword,
    String confirmPassword,
  ) async {
    return _driverAuthRepository.resetPasswordWithToken(
      token,
      newpassword,
      confirmPassword,
    );
  }
}
