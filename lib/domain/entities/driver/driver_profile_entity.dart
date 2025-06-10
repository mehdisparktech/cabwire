import 'package:cabwire/core/base/base_entity.dart';

class DriverProfileEntity extends BaseEntity {
  final String? name;
  final String? contact;
  final bool? isOnline;
  final GeoLocationEntity? geoLocation;
  final String? image;
  final String? status;
  final bool? verified;
  final String? gender;
  final String? dateOfBirth;
  final DriverLicenseEntity? driverLicense;
  final DriverVehicleEntity? driverVehicles;

  const DriverProfileEntity({
    this.name,
    this.contact,
    this.isOnline,
    this.geoLocation,
    this.image,
    this.status,
    this.verified,
    this.gender,
    this.dateOfBirth,
    this.driverLicense,
    this.driverVehicles,
  });

  @override
  List<Object?> get props => [
    name,
    contact,
    isOnline,
    geoLocation,
    image,
    status,
    verified,
    gender,
    dateOfBirth,
    driverLicense,
    driverVehicles,
  ];
}

class GeoLocationEntity {
  final String? type;
  final List<double>? coordinates;

  const GeoLocationEntity({this.type, this.coordinates});
}

class DriverLicenseEntity {
  final int? licenseNumber;
  final String? licenseExpiryDate;
  final String? uploadDriversLicense;

  const DriverLicenseEntity({
    this.licenseNumber,
    this.licenseExpiryDate,
    this.uploadDriversLicense,
  });
}

class DriverVehicleEntity {
  final String? vehiclesMake;
  final String? vehiclesModel;
  final String? vehiclesYear;
  final int? vehiclesRegistrationNumber;
  final int? vehiclesInsuranceNumber;
  final String? vehiclesPicture;
  final int? vehiclesCategory;

  const DriverVehicleEntity({
    this.vehiclesMake,
    this.vehiclesModel,
    this.vehiclesYear,
    this.vehiclesRegistrationNumber,
    this.vehiclesInsuranceNumber,
    this.vehiclesPicture,
    this.vehiclesCategory,
  });
}
