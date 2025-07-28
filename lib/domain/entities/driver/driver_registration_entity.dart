import 'package:cabwire/core/base/base_entity.dart';

class DriverRegistrationEntity extends BaseEntity {
  final String name;
  final String? email;
  final String? role;
  final String? image;
  final String? status;
  final bool? verified;
  final String? password;

  final DriverLocationEntity? location;
  final DriverLicenseEntity? driverLicense;
  final DriverVehicleEntity? driverVehicles;

  const DriverRegistrationEntity({
    required this.name,
    this.email,
    this.role,
    this.image,
    this.status,
    this.verified,
    this.password,
    this.location,
    this.driverLicense,
    this.driverVehicles,
  });

  @override
  List<Object?> get props => [
    name,
    email,
    role,
    image,
    status,
    verified,
    password,
    location,
    driverLicense,
    driverVehicles,
  ];

  DriverRegistrationEntity copyWith({
    String? name,
    String? email,
    String? role,
    String? image,
    String? status,
    bool? verified,
    String? password,
    DriverLocationEntity? location,
    DriverLicenseEntity? driverLicense,
    DriverVehicleEntity? driverVehicles,
  }) {
    return DriverRegistrationEntity(
      name: name ?? this.name,
      email: email ?? this.email,
      role: role ?? this.role,
      image: image ?? this.image,
      status: status ?? this.status,
      verified: verified ?? this.verified,
      password: password ?? this.password,
      location: location ?? this.location,
      driverLicense: driverLicense ?? this.driverLicense,
      driverVehicles: driverVehicles ?? this.driverVehicles,
    );
  }
}

class DriverLocationEntity {
  final double? lat;
  final double? lng;
  final String? address;

  const DriverLocationEntity({this.lat, this.lng, this.address});
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
  final dynamic vehiclesPicture;
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
