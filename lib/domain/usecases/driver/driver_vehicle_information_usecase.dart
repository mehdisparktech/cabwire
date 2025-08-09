import 'package:cabwire/core/base/base_use_case.dart';
import 'package:cabwire/core/base/result.dart';
import 'package:cabwire/domain/repositories/driver/driver_auth_repository.dart';

class DriverVehicleInformationUsecase extends BaseUseCase<String> {
  final DriverAuthRepository repository;

  DriverVehicleInformationUsecase(super.errorMessageHandler, this.repository);

  Future<Result<String>> execute({
    required String vehiclesMake,
    required String vehiclesModel,
    required String vehiclesYear,
    required String vehiclesRegistrationNumber,
    required String vehiclesInsuranceNumber,
    required String vehiclesCategory,
    required String email,
    String? vehicleFrontImage,
    String? vehicleBackImage,
  }) async {
    return repository.submitDriverVehicleInformation(
      vehiclesMake: vehiclesMake,
      vehiclesModel: vehiclesModel,
      vehiclesYear: vehiclesYear,
      vehiclesRegistrationNumber: vehiclesRegistrationNumber,
      vehiclesInsuranceNumber: vehiclesInsuranceNumber,
      vehiclesCategory: vehiclesCategory,
      vehicleFrontImage: vehicleFrontImage,
      vehicleBackImage: vehicleBackImage,
      email: email,
    );
  }
}
