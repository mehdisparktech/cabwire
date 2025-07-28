import 'package:cabwire/core/base/result.dart';
import 'package:cabwire/domain/repositories/driver/driver_auth_repository.dart';

class DriverDeleteProfileUsecase {
  final DriverAuthRepository _driverAuthRepository;

  DriverDeleteProfileUsecase(this._driverAuthRepository);

  Future<Result<String>> execute(String password) async {
    return await _driverAuthRepository.deleteMyAccount(password);
  }
}
