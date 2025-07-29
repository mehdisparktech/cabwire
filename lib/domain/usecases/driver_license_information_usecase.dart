import 'package:cabwire/core/base/base_use_case.dart';
import 'package:cabwire/core/base/result.dart';
import 'package:cabwire/domain/repositories/driver/driver_auth_repository.dart';

class DriverLicenseInformationUsecase extends BaseUseCase<String> {
  final DriverAuthRepository repository;

  DriverLicenseInformationUsecase(super.errorMessageHandler, this.repository);

  Future<Result<String>> execute({
    required String licenseNumber,
    required String licenseExpiryDate,
    required String email,
    String? vehicleImage,
    String? licenseImage,
  }) async {
    return repository.submitDriverLicenseInformation(
      licenseNumber: licenseNumber,
      licenseExpiryDate: licenseExpiryDate,
      licenseImage: licenseImage,
      email: email,
    );
  }
}
