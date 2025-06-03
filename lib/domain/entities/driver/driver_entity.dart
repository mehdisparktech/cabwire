import 'package:cabwire/core/base/base_entity.dart';

class DriverEntity extends BaseEntity {
  final String? name;
  final String? email;
  final String? password;
  final String? contact;
  final String? gender;
  final String? dateOfBirth;
  final String? role;
  final String? image;
  final String? status;
  final bool? verified;
  final DriverLocation? location;
  final DriverLicense? driverLicense;
  final DriverVehicle? driverVehicles;

  const DriverEntity({
    this.name,
    this.email,
    this.password,
    this.role,
    this.image,
    this.status,
    this.verified,
    this.contact,
    this.gender,
    this.dateOfBirth,
    this.location,
    this.driverLicense,
    this.driverVehicles,
  });

  @override
  List<Object?> get props => [
    name,
    email,
    password,
    contact,
    gender,
    dateOfBirth,
    role,
    image,
    status,
    verified,
    location,
    driverLicense,
    driverVehicles,
  ];

  DriverEntity copyWith({
    String? name,
    String? email,
    String? password,
    String? contact,
    String? gender,
    String? dateOfBirth,
    String? role,
    String? image,
    String? status,
    bool? verified,
    DriverLocation? location,
    DriverLicense? driverLicense,
    DriverVehicle? driverVehicles,
  }) {
    return DriverEntity(
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
      contact: contact ?? this.contact,
      gender: gender ?? this.gender,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      role: role ?? this.role,
      image: image ?? this.image,
      status: status ?? this.status,
      verified: verified ?? this.verified,
      location: location ?? this.location,
      driverLicense: driverLicense ?? this.driverLicense,
      driverVehicles: driverVehicles ?? this.driverVehicles,
    );
  }
}

class DriverLocation extends BaseEntity {
  final double? lat;
  final double? lng;
  final String? address;

  const DriverLocation({this.lat, this.lng, this.address});

  @override
  List<Object?> get props => [lat, lng, address];
}

class DriverLicense extends BaseEntity {
  final int? licenseNumber;
  final String? licenseExpiryDate;
  final String? uploadDriversLicense;

  const DriverLicense({
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
}

class DriverVehicle extends BaseEntity {
  final String? vehiclesMake;
  final String? vehiclesModel;
  final String? vehiclesYear;
  final int? vehiclesRegistrationNumber;
  final int? vehiclesInsuranceNumber;
  final String? vehiclesPicture;
  final int? vehiclesCategory;

  const DriverVehicle({
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
}
