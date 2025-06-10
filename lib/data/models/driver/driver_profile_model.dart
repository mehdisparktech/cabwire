import 'package:cabwire/domain/entities/driver/driver_profile_entity.dart';

class DriverProfileModel extends DriverProfileEntity {
  const DriverProfileModel({
    super.name,
    super.contact,
    super.isOnline,
    super.geoLocation,
    super.image,
    super.status,
    super.verified,
    super.gender,
    super.dateOfBirth,
    super.driverLicense,
    super.driverVehicles,
  });

  factory DriverProfileModel.fromJson(Map<String, dynamic> json) {
    return DriverProfileModel(
      name: json['name'],
      contact: json['contact'],
      isOnline: json['isOnline'],
      geoLocation:
          json['geoLocation'] != null
              ? GeoLocationEntity(
                type: json['geoLocation']['type'],
                coordinates:
                    (json['geoLocation']['coordinates'] as List<dynamic>?)
                        ?.map((e) => (e as num).toDouble())
                        .toList(),
              )
              : null,
      image: json['image'],
      status: json['status'],
      verified: json['verified'],
      gender: json['gender'],
      dateOfBirth: json['dateOfBirth'],
      driverLicense:
          json['driverLicense'] != null
              ? DriverLicenseEntity(
                licenseNumber: json['driverLicense']['licenseNumber'],
                licenseExpiryDate: json['driverLicense']['licenseExpiryDate'],
                uploadDriversLicense:
                    json['driverLicense']['uploadDriversLicense'],
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
                vehiclesPicture: json['driverVehicles']['vehiclesPicture'],
                vehiclesCategory: json['driverVehicles']['vehiclesCategory'],
              )
              : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "contact": contact,
      "isOnline": isOnline,
      "geoLocation":
          geoLocation != null
              ? {
                "type": geoLocation!.type,
                "coordinates": geoLocation!.coordinates,
              }
              : null,
      "image": image,
      "status": status,
      "verified": verified,
      "gender": gender,
      "dateOfBirth": dateOfBirth,
      "driverLicense":
          driverLicense != null
              ? {
                "licenseNumber": driverLicense!.licenseNumber,
                "licenseExpiryDate": driverLicense!.licenseExpiryDate,
                "uploadDriversLicense": driverLicense!.uploadDriversLicense,
              }
              : null,
      "driverVehicles":
          driverVehicles != null
              ? {
                "vehiclesMake": driverVehicles!.vehiclesMake,
                "vehiclesModel": driverVehicles!.vehiclesModel,
                "vehiclesYear": driverVehicles!.vehiclesYear,
                "vehiclesRegistrationNumber":
                    driverVehicles!.vehiclesRegistrationNumber,
                "vehiclesInsuranceNumber":
                    driverVehicles!.vehiclesInsuranceNumber,
                "vehiclesPicture": driverVehicles!.vehiclesPicture,
                "vehiclesCategory": driverVehicles!.vehiclesCategory,
              }
              : null,
    };
  }
}
