import 'package:cabwire/core/base/base_entity.dart';

/// Model for driver registration data
class DriverRegistrationEntity extends BaseEntity {
  // Basic information
  final String name;
  final String email;
  final String password;
  final String? phone;
  final String? gender;
  final String? dateOfBirth;
  final String? profileImage;

  // License information
  final String? licenseNumber;
  final String? licenseExpiryDate;
  final String? licenseImage;

  // Vehicle information
  final String? vehicleMake;
  final String? vehicleModel;
  final String? vehicleYear;
  final String? vehicleRegistrationNumber;
  final String? vehicleInsuranceNumber;
  final String? vehicleCategory;
  final String? vehicleImage;

  const DriverRegistrationEntity({
    required this.name,
    required this.email,
    required this.password,
    this.phone,
    this.gender,
    this.dateOfBirth,
    this.profileImage,
    this.licenseNumber,
    this.licenseExpiryDate,
    this.licenseImage,
    this.vehicleMake,
    this.vehicleModel,
    this.vehicleYear,
    this.vehicleRegistrationNumber,
    this.vehicleInsuranceNumber,
    this.vehicleCategory,
    this.vehicleImage,
  });

  /// Creates a copy of this DriverRegistrationEntity with the given fields replaced with new values
  DriverRegistrationEntity copyWith({
    String? name,
    String? email,
    String? password,
    String? phone,
    String? gender,
    String? dateOfBirth,
    String? profileImage,
    String? licenseNumber,
    String? licenseExpiryDate,
    String? licenseImage,
    String? vehicleMake,
    String? vehicleModel,
    String? vehicleYear,
    String? vehicleRegistrationNumber,
    String? vehicleInsuranceNumber,
    String? vehicleCategory,
    String? vehicleImage,
  }) {
    return DriverRegistrationEntity(
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
      phone: phone ?? this.phone,
      gender: gender ?? this.gender,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      profileImage: profileImage ?? this.profileImage,
      licenseNumber: licenseNumber ?? this.licenseNumber,
      licenseExpiryDate: licenseExpiryDate ?? this.licenseExpiryDate,
      licenseImage: licenseImage ?? this.licenseImage,
      vehicleMake: vehicleMake ?? this.vehicleMake,
      vehicleModel: vehicleModel ?? this.vehicleModel,
      vehicleYear: vehicleYear ?? this.vehicleYear,
      vehicleRegistrationNumber:
          vehicleRegistrationNumber ?? this.vehicleRegistrationNumber,
      vehicleInsuranceNumber:
          vehicleInsuranceNumber ?? this.vehicleInsuranceNumber,
      vehicleCategory: vehicleCategory ?? this.vehicleCategory,
      vehicleImage: vehicleImage ?? this.vehicleImage,
    );
  }

  @override
  List<Object?> get props => [
    name,
    email,
    password,
    phone,
    gender,
    dateOfBirth,
    profileImage,
    licenseNumber,
    licenseExpiryDate,
    licenseImage,
    vehicleMake,
    vehicleModel,
    vehicleYear,
    vehicleRegistrationNumber,
    vehicleInsuranceNumber,
    vehicleCategory,
    vehicleImage,
  ];
}
