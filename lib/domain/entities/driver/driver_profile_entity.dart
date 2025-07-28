import 'package:cabwire/core/base/base_entity.dart';
import 'package:equatable/equatable.dart';

class DriverProfileEntity extends BaseEntity {
  final String? id;
  final String? name;
  final String? role;
  final String? email;
  final String? image;
  final String? status;
  final bool? verified;
  final bool? isOnline;
  final bool? isDeleted;
  final GeoLocationEntity? geoLocation;
  final String? stripeAccountId;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? contact;
  final String? gender;
  final String? dateOfBirth;
  final DriverLicenseEntity? driverLicense;
  final DriverVehicleEntity? driverVehicles;
  final double? driverTotalEarn;
  final int? totalTrip;
  final String? action;
  final double? adminRevenue;
  final double? totalAmountSpend;

  const DriverProfileEntity({
    this.id,
    this.name,
    this.role,
    this.email,
    this.image,
    this.status,
    this.verified,
    this.isOnline,
    this.isDeleted,
    this.geoLocation,
    this.stripeAccountId,
    this.createdAt,
    this.updatedAt,
    this.contact,
    this.gender,
    this.dateOfBirth,
    this.driverLicense,
    this.driverVehicles,
    this.driverTotalEarn,
    this.totalTrip,
    this.action,
    this.adminRevenue,
    this.totalAmountSpend,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    role,
    email,
    image,
    status,
    verified,
    isOnline,
    isDeleted,
    geoLocation,
    stripeAccountId,
    createdAt,
    updatedAt,
    contact,
    gender,
    dateOfBirth,
    driverLicense,
    driverVehicles,
    driverTotalEarn,
    totalTrip,
    action,
    adminRevenue,
    totalAmountSpend,
  ];
}

class GeoLocationEntity extends Equatable {
  final String? type;
  final List<double>? coordinates;

  const GeoLocationEntity({this.type, this.coordinates});

  @override
  List<Object?> get props => [type, coordinates];
}

class DriverLicenseEntity extends Equatable {
  final int? licenseNumber;
  final String? licenseExpiryDate;
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
}

class DriverVehicleEntity extends Equatable {
  final String? vehiclesMake;
  final String? vehiclesModel;
  final String? vehiclesYear;
  final int? vehiclesRegistrationNumber;
  final int? vehiclesInsuranceNumber;
  final String? vehiclesPicture;
  final String? vehiclesCategory;

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
}
