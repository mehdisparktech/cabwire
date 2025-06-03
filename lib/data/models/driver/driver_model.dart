import 'package:cabwire/domain/entities/driver/driver_entity.dart';

class DriverModel extends DriverEntity {
  const DriverModel({
    super.name,
    super.email,
    super.password,
    super.role,
    super.image,
    super.status,
    super.verified,
    super.contact,
    super.gender,
    super.dateOfBirth,
    super.location,
    super.driverLicense,
    super.driverVehicles,
  });

  factory DriverModel.fromJson(Map<String, dynamic> json) {
    return DriverModel(
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      password: json['password'] ?? '',
      role: json['role'] ?? '',
      image: json['image'] ?? '',
      status: json['status'] ?? '',
      verified: json['verified'] ?? false,
      contact: json['contact'] ?? '',
      gender: json['gender'] ?? '',
      dateOfBirth: json['dateOfBirth'] ?? '',
      location:
          json['location'] != null
              ? DriverLocation(
                lat: (json['location']['lat'] as num?)?.toDouble() ?? 0.0,
                lng: (json['location']['lng'] as num?)?.toDouble() ?? 0.0,
                address: json['location']['address'] ?? '',
              )
              : null,
      driverLicense:
          json['driverLicense'] != null
              ? DriverLicense(
                licenseNumber: json['driverLicense']['licenseNumber'] ?? '',
                licenseExpiryDate:
                    json['driverLicense']['licenseExpiryDate'] ?? '',
                uploadDriversLicense:
                    json['driverLicense']['uploadDriversLicense'] ?? '',
              )
              : null,
      driverVehicles:
          json['driverVehicles'] != null
              ? DriverVehicle(
                vehiclesMake: json['driverVehicles']['vehiclesMake'] ?? '',
                vehiclesModel: json['driverVehicles']['vehiclesModel'] ?? '',
                vehiclesYear: json['driverVehicles']['vehiclesYear'] ?? '',
                vehiclesRegistrationNumber:
                    json['driverVehicles']['vehiclesRegistrationNumber'] ?? '',
                vehiclesInsuranceNumber:
                    json['driverVehicles']['vehiclesInsuranceNumber'] ?? '',
                vehiclesPicture:
                    json['driverVehicles']['vehiclesPicture'] ?? '',
                vehiclesCategory:
                    json['driverVehicles']['vehiclesCategory'] ?? '',
              )
              : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name ?? '',
      'email': email ?? '',
      'password': password ?? '',
      'role': role ?? '',
      'image': image ?? '',
      'status': status ?? '',
      'verified': verified ?? false,
      'contact': contact ?? '',
      'gender': gender ?? '',
      'dateOfBirth': dateOfBirth ?? '',
      'location':
          location != null
              ? {
                'lat': location?.lat ?? 0,
                'lng': location?.lng ?? 0,
                'address': location?.address ?? '',
              }
              : null,
      'driverLicense':
          driverLicense != null
              ? {
                'licenseNumber': driverLicense!.licenseNumber ?? '',
                'licenseExpiryDate': driverLicense!.licenseExpiryDate ?? '',
                'uploadDriversLicense':
                    driverLicense!.uploadDriversLicense ?? '',
              }
              : null,
      'driverVehicles':
          driverVehicles != null
              ? {
                'vehiclesMake': driverVehicles!.vehiclesMake ?? '',
                'vehiclesModel': driverVehicles!.vehiclesModel ?? '',
                'vehiclesYear': driverVehicles!.vehiclesYear ?? '',
                'vehiclesRegistrationNumber':
                    driverVehicles!.vehiclesRegistrationNumber ?? '',
                'vehiclesInsuranceNumber':
                    driverVehicles!.vehiclesInsuranceNumber ?? '',
                'vehiclesPicture': driverVehicles!.vehiclesPicture ?? '',
                'vehiclesCategory': driverVehicles!.vehiclesCategory ?? '',
              }
              : null,
    };
  }
}
