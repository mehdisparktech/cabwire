import 'package:cabwire/data/models/driver/driver_profile_model.dart';
import 'package:cabwire/domain/entities/driver/driver_entity.dart' as driver;
import 'package:cabwire/domain/entities/driver/driver_profile_entity.dart';
import 'package:cabwire/data/models/driver/driver_model.dart';

/// Extension methods for DriverModel to convert to/from DriverEntity
extension DriverModelMapper on DriverModel {
  /// Convert model to entity
  driver.DriverEntity toEntity() {
    return driver.DriverEntity(
      id: id,
      name: name,
      role: role,
      contact: contact,
      email: email,
      password: password,
      location:
          location != null
              ? driver.DriverLocationEntity(
                lat: location?.lat,
                lng: location?.lng,
                address: location?.address,
              )
              : null,
      image: image,
      status: status,
      verified: verified,
      gender: gender,
      dateOfBirth: dateOfBirth,
      driverLicense:
          driverLicense != null
              ? driver.DriverLicenseEntity(
                licenseNumber: driverLicense?.licenseNumber,
                licenseExpiryDate: driverLicense?.licenseExpiryDate,
                uploadDriversLicense: driverLicense?.uploadDriversLicense,
              )
              : null,
      driverVehicles:
          driverVehicles != null
              ? driver.DriverVehicleEntity(
                vehiclesMake: driverVehicles?.vehiclesMake,
                vehiclesModel: driverVehicles?.vehiclesModel,
                vehiclesYear: driverVehicles?.vehiclesYear,
                vehiclesRegistrationNumber:
                    driverVehicles?.vehiclesRegistrationNumber,
                vehiclesInsuranceNumber:
                    driverVehicles?.vehiclesInsuranceNumber,
                vehiclesPicture: driverVehicles?.vehiclesPicture,
                vehiclesCategory: driverVehicles?.vehiclesCategory,
              )
              : null,
    );
  }
}

/// Extension methods for DriverEntity to convert to DriverModel
extension DriverEntityMapper on driver.DriverEntity {
  /// Convert entity to model
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
      location:
          location != null
              ? LocationModel(
                lat: location?.lat ?? 0,
                lng: location?.lng ?? 0,
                address: location?.address ?? '',
              )
              : null,
      driverLicense:
          driverLicense != null
              ? DriverLicenseModel(
                licenseNumber: driverLicense?.licenseNumber ?? 0,
                licenseExpiryDate:
                    driverLicense?.licenseExpiryDate ?? DateTime.now(),
                uploadDriversLicense: driverLicense?.uploadDriversLicense ?? '',
              )
              : null,
      driverVehicles:
          driverVehicles != null
              ? DriverVehicleModel(
                vehiclesMake: driverVehicles?.vehiclesMake ?? '',
                vehiclesModel: driverVehicles?.vehiclesModel ?? '',
                vehiclesYear: driverVehicles?.vehiclesYear ?? DateTime.now(),
                vehiclesRegistrationNumber:
                    driverVehicles?.vehiclesRegistrationNumber ?? 0,
                vehiclesInsuranceNumber:
                    driverVehicles?.vehiclesInsuranceNumber ?? 0,
                vehiclesPicture: driverVehicles?.vehiclesPicture ?? 0,
                vehiclesCategory: driverVehicles?.vehiclesCategory ?? 0,
              )
              : null,
    );
  }
}

/// Extension methods for DriverProfileModel to convert to DriverProfileEntity
extension DriverProfileModelMapper on DriverProfileModel {
  /// Convert model to entity
  DriverProfileEntity toEntity() {
    // This is already an entity due to inheritance, but we're providing this
    // method for consistency with other mappers
    return this;
  }
}

/// Extension methods for DriverProfileEntity to convert to DriverProfileModel
extension DriverProfileEntityMapper on DriverProfileEntity {
  /// Convert entity to model
  DriverProfileModel toModel() {
    return DriverProfileModel(
      name: name,
      contact: contact,
      isOnline: isOnline,
      geoLocation: geoLocation,
      image: image,
      status: status,
      verified: verified,
      gender: gender,
      dateOfBirth: dateOfBirth,
      driverLicense: driverLicense,
      driverVehicles: driverVehicles,
    );
  }
}
