import 'package:cabwire/core/base/base_entity.dart';

class DriverLocation {
  final double? lat;
  final double? lng;
  final String? address;

  const DriverLocation({this.lat, this.lng, this.address});
}

class DriverLicense {
  final int? licenseNumber;
  final DateTime? licenseExpiryDate;
  final String? uploadDriversLicense;

  const DriverLicense({
    this.licenseNumber,
    this.licenseExpiryDate,
    this.uploadDriversLicense,
  });
}

class DriverVehicle {
  final String? vehiclesMake;
  final String? vehiclesModel;
  final DateTime? vehiclesYear;
  final int? vehiclesRegistrationNumber;
  final int? vehiclesInsuranceNumber;
  final int? vehiclesPicture;
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
}

class DriverEntity extends BaseEntity {
  final String? id;
  final String? name;
  final String? role;
  final String? contact;
  final String? email;
  final String? password;
  final DriverLocation? location;
  final String? image;
  final String? status;
  final bool? verified;
  final String? gender;
  final DateTime? dateOfBirth;
  final DriverLicense? driverLicense;
  final DriverVehicle? driverVehicles;

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
    DriverLocation? location,
    String? image,
    String? status,
    bool? verified,
    String? gender,
    DateTime? dateOfBirth,
    DriverLicense? driverLicense,
    DriverVehicle? driverVehicles,
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
