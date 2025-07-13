import 'package:cabwire/domain/entities/driver/driver_profile_entity.dart';

class DriverProfileModel extends DriverProfileEntity {
  const DriverProfileModel({
    super.id,
    super.name,
    super.role,
    super.email,
    super.image,
    super.status,
    super.verified,
    super.isOnline,
    super.isDeleted,
    super.geoLocation,
    super.stripeAccountId,
    super.createdAt,
    super.updatedAt,
    super.contact,
    super.gender,
    super.dateOfBirth,
    super.driverLicense,
    super.driverVehicles,
    super.driverTotalEarn,
    super.totalTrip,
    super.action,
    super.adminRevenue,
    super.totalAmountSpend,
  });

  factory DriverProfileModel.fromJson(Map<String, dynamic> json) {
    return DriverProfileModel(
      id: json['_id'],
      name: json['name'],
      role: json['role'],
      email: json['email'],
      image: json['image'],
      status: json['status'],
      verified: json['verified'],
      isOnline: json['isOnline'],
      isDeleted: json['isDeleted'],
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
      stripeAccountId: json['stripeAccountId'],
      createdAt:
          json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt:
          json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
      contact: json['contact'],
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
      driverTotalEarn:
          json['driverTotalEarn'] != null
              ? (json['driverTotalEarn'] as num).toDouble()
              : null,
      totalTrip: json['totalTrip'],
      action: json['action'],
      adminRevenue:
          json['adminRevenue'] != null
              ? (json['adminRevenue'] as num).toDouble()
              : null,
      totalAmountSpend:
          json['totalAmountSpend'] != null
              ? (json['totalAmountSpend'] as num).toDouble()
              : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "_id": id,
      "name": name,
      "role": role,
      "email": email,
      "image": image,
      "status": status,
      "verified": verified,
      "isOnline": isOnline,
      "isDeleted": isDeleted,
      "geoLocation":
          geoLocation != null
              ? {
                "type": geoLocation!.type,
                "coordinates": geoLocation!.coordinates,
              }
              : null,
      "stripeAccountId": stripeAccountId,
      "createdAt": createdAt?.toIso8601String(),
      "updatedAt": updatedAt?.toIso8601String(),
      "contact": contact,
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
      "driverTotalEarn": driverTotalEarn,
      "totalTrip": totalTrip,
      "action": action,
      "adminRevenue": adminRevenue,
      "totalAmountSpend": totalAmountSpend,
    };
  }
}
