import 'package:cabwire/domain/entities/driver/driver_registration_entity.dart';

class DriverRegistrationModel extends DriverRegistrationEntity {
  const DriverRegistrationModel({
    required super.name,
    super.email,
    super.role,
    super.image,
    super.status,
    super.verified,
    super.password,
    super.location,
    super.driverLicense,
    super.driverVehicles,
  });

  factory DriverRegistrationModel.fromJson(Map<String, dynamic> json) {
    return DriverRegistrationModel(
      name: json['name'],
      email: json['email'],
      role: json['role'],
      image: json['image'],
      status: json['status'],
      verified: json['verified'],
      password: json['password'],
      location:
          json['location'] != null
              ? DriverLocationEntity(
                lat: (json['location']['lat'] as num?)?.toDouble(),
                lng: (json['location']['lng'] as num?)?.toDouble(),
                address: json['location']['address'],
              )
              : null,
      driverLicense:
          json['driverLicense'] != null
              ? DriverLicenseEntity(
                licenseNumber: json['driverLicense']['licenseNumber'],
                licenseExpiryDate: json['driverLicense']['licenseExpiryDate'],
                uploadDriversLicense:
                    (() {
                      final uploads =
                          json['driverLicense']['uploadDriversLicense'];
                      if (uploads is List) {
                        return uploads.map((e) => e.toString()).toList();
                      } else if (uploads is String) {
                        return <String>[uploads];
                      }
                      return null;
                    })(),
              )
              : null,
      driverVehicles:
          json['driverVehicles'] != null
              ? DriverVehicleEntity(
                vehiclesMake: json['driverVehicles']['vehiclesMake'],
                vehiclesModel: json['driverVehicles']['vehiclesModel'],
                vehiclesYear: json['driverVehicles']['vehiclesYear'],
                vehiclesRegistrationNumber:
                    json['driverVehicles']['vehiclesRegistrationNumber'],
                vehiclesInsuranceNumber:
                    json['driverVehicles']['vehiclesInsuranceNumber'],
                vehiclesPicture:
                    (() {
                      final pics = json['driverVehicles']['vehiclesPicture'];
                      if (pics is List) {
                        return pics.map((e) => e.toString()).toList();
                      } else if (pics is String) {
                        return <String>[pics];
                      }
                      return null;
                    })(),
                vehiclesCategory: json['driverVehicles']['vehiclesCategory'],
              )
              : null,
    );
  }
}
