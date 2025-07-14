import 'package:cabwire/core/base/base_use_case.dart';
import 'package:cabwire/core/base/result.dart';
import 'package:cabwire/data/models/driver/driver_profile_model.dart';
import 'package:cabwire/domain/repositories/driver/driver_auth_repository.dart';

class DriverProfileUpdateUsecase extends BaseUseCase<String> {
  final DriverAuthRepository repository;

  DriverProfileUpdateUsecase(super.errorMessageHandler, this.repository);

  Future<Result<String>> execute(
    DriverProfileModel profile,
    String email,
  ) async {
    return repository.updateDriverProfile(profile, email);
  }
}
