import 'package:cabwire/core/base/base_entity.dart';

/// Location information for a driver
class DriverLocationEntity extends BaseEntity {
  final double? lat;
  final double? lng;
  final String? address;

  const DriverLocationEntity({this.lat, this.lng, this.address});

  @override
  List<Object?> get props => [lat, lng, address];

  DriverLocationEntity copyWith({double? lat, double? lng, String? address}) {
    return DriverLocationEntity(
      lat: lat ?? this.lat,
      lng: lng ?? this.lng,
      address: address ?? this.address,
    );
  }
}

/// Driver's license information
class DriverLicenseEntity extends BaseEntity {
  final int? licenseNumber;
  final DateTime? licenseExpiryDate;
  final String? uploadDriversLicense;

  const DriverLicenseEntity({
    this.licenseNumber,
    this.licenseExpiryDate,
    this.uploadDriversLicense,
  });

  @override
  List<Object?> get props => [
    licenseNumber,
    licenseExpiryDate,
    uploadDriversLicense,
  ];

  DriverLicenseEntity copyWith({
    int? licenseNumber,
    DateTime? licenseExpiryDate,
    String? uploadDriversLicense,
  }) {
    return DriverLicenseEntity(
      licenseNumber: licenseNumber ?? this.licenseNumber,
      licenseExpiryDate: licenseExpiryDate ?? this.licenseExpiryDate,
      uploadDriversLicense: uploadDriversLicense ?? this.uploadDriversLicense,
    );
  }
}

/// Driver's vehicle information
class DriverVehicleEntity extends BaseEntity {
  final String? vehiclesMake;
  final String? vehiclesModel;
  final DateTime? vehiclesYear;
  final int? vehiclesRegistrationNumber;
  final int? vehiclesInsuranceNumber;
  final int? vehiclesPicture;
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

  @override
  List<Object?> get props => [
    vehiclesMake,
    vehiclesModel,
    vehiclesYear,
    vehiclesRegistrationNumber,
    vehiclesInsuranceNumber,
    vehiclesPicture,
    vehiclesCategory,
  ];

  DriverVehicleEntity copyWith({
    String? vehiclesMake,
    String? vehiclesModel,
    DateTime? vehiclesYear,
    int? vehiclesRegistrationNumber,
    int? vehiclesInsuranceNumber,
    int? vehiclesPicture,
    int? vehiclesCategory,
  }) {
    return DriverVehicleEntity(
      vehiclesMake: vehiclesMake ?? this.vehiclesMake,
      vehiclesModel: vehiclesModel ?? this.vehiclesModel,
      vehiclesYear: vehiclesYear ?? this.vehiclesYear,
      vehiclesRegistrationNumber:
          vehiclesRegistrationNumber ?? this.vehiclesRegistrationNumber,
      vehiclesInsuranceNumber:
          vehiclesInsuranceNumber ?? this.vehiclesInsuranceNumber,
      vehiclesPicture: vehiclesPicture ?? this.vehiclesPicture,
      vehiclesCategory: vehiclesCategory ?? this.vehiclesCategory,
    );
  }
}

/// Main driver entity class
class DriverEntity extends BaseEntity {
  final String? id;
  final String? name;
  final String? role;
  final String? contact;
  final String? email;
  final String? password;
  final DriverLocationEntity? location;
  final String? image;
  final String? status;
  final bool? verified;
  final String? gender;
  final DateTime? dateOfBirth;
  final DriverLicenseEntity? driverLicense;
  final DriverVehicleEntity? driverVehicles;

  const DriverEntity({
    this.id,
    this.name,
    this.role,
    this.contact,
    this.email,
    this.password,
    this.location,
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
    id,
    name,
    role,
    contact,
    email,
    password,
    location,
    image,
    status,
    verified,
    gender,
    dateOfBirth,
    driverLicense,
    driverVehicles,
  ];

  DriverEntity copyWith({
    String? id,
    String? name,
    String? role,
    String? contact,
    String? email,
    String? password,
    DriverLocationEntity? location,
    String? image,
    String? status,
    bool? verified,
    String? gender,
    DateTime? dateOfBirth,
    DriverLicenseEntity? driverLicense,
    DriverVehicleEntity? driverVehicles,
  }) {
    return DriverEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      role: role ?? this.role,
      contact: contact ?? this.contact,
      email: email ?? this.email,
      password: password ?? this.password,
      location: location ?? this.location,
      image: image ?? this.image,
      status: status ?? this.status,
      verified: verified ?? this.verified,
      gender: gender ?? this.gender,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      driverLicense: driverLicense ?? this.driverLicense,
      driverVehicles: driverVehicles ?? this.driverVehicles,
    );
  }
}
