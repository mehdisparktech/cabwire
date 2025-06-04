import '../../domain/entities/driver/driver_entity.dart';
import '../models/driver/driver_model.dart';

extension DriverModelMapper on DriverModel {
  DriverEntity toEntity() {
    return DriverEntity(
      id: id,
      name: name,
      role: role,
      contact: contact,
      email: email,
      password: password,
      location: DriverLocation(
        lat: location?.lat,
        lng: location?.lng,
        address: location?.address,
      ),
      image: image,
      status: status,
      verified: verified,
      gender: gender,
      dateOfBirth: dateOfBirth,
      driverLicense: DriverLicense(
        licenseNumber: driverLicense?.licenseNumber,
        licenseExpiryDate: driverLicense?.licenseExpiryDate,
        uploadDriversLicense: driverLicense?.uploadDriversLicense,
      ),
      driverVehicles: DriverVehicle(
        vehiclesMake: driverVehicles?.vehiclesMake,
        vehiclesModel: driverVehicles?.vehiclesModel,
        vehiclesYear: driverVehicles?.vehiclesYear,
        vehiclesRegistrationNumber: driverVehicles?.vehiclesRegistrationNumber,
        vehiclesInsuranceNumber: driverVehicles?.vehiclesInsuranceNumber,
        vehiclesPicture: driverVehicles?.vehiclesPicture,
        vehiclesCategory: driverVehicles?.vehiclesCategory,
      ),
    );
  }
}

extension DriverEntityMapper on DriverEntity {
  DriverModel toModel() {
    return DriverModel(
      id: id,
      name: name,
      role: role,
      contact: contact,
      email: email,
      password: password,
      image: image,
      status: status,
      verified: verified,
      gender: gender,
      dateOfBirth: dateOfBirth,
      location: LocationModel(
        lat: location?.lat ?? 0,
        lng: location?.lng ?? 0,
        address: location?.address ?? '',
      ),
      driverLicense: DriverLicenseModel(
        licenseNumber: driverLicense?.licenseNumber ?? 0,
        licenseExpiryDate: driverLicense?.licenseExpiryDate ?? DateTime.now(),
        uploadDriversLicense: driverLicense?.uploadDriversLicense ?? '',
      ),
      driverVehicles: DriverVehicleModel(
        vehiclesMake: driverVehicles?.vehiclesMake ?? '',
        vehiclesModel: driverVehicles?.vehiclesModel ?? '',
        vehiclesYear: driverVehicles?.vehiclesYear ?? DateTime.now(),
        vehiclesRegistrationNumber:
            driverVehicles?.vehiclesRegistrationNumber ?? 0,
        vehiclesInsuranceNumber: driverVehicles?.vehiclesInsuranceNumber ?? 0,
        vehiclesPicture: driverVehicles?.vehiclesPicture ?? 0,
        vehiclesCategory: driverVehicles?.vehiclesCategory ?? 0,
      ),
    );
  }
}
