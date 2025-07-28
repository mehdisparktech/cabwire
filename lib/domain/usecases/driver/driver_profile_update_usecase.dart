import 'package:cabwire/core/base/base_use_case.dart';
import 'package:cabwire/core/base/result.dart';
import 'package:cabwire/domain/repositories/driver/driver_auth_repository.dart';

class DriverProfileUpdateUsecase extends BaseUseCase<String> {
  final DriverAuthRepository repository;

  DriverProfileUpdateUsecase(super.errorMessageHandler, this.repository);

  Future<Result<String>> execute(
    String? name,
    String? contact,
    String? profileImage,
  ) async {
    return repository.updateDriverProfile(name, contact, profileImage);
  }
}
