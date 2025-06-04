class LocationModel {
  final double lat;
  final double lng;
  final String address;

  LocationModel({required this.lat, required this.lng, required this.address});

  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(
      lat: json['lat'],
      lng: json['lng'],
      address: json['address'],
    );
  }

  Map<String, dynamic> toJson() => {'lat': lat, 'lng': lng, 'address': address};
}

class DriverLicenseModel {
  final int licenseNumber;
  final DateTime licenseExpiryDate;
  final String uploadDriversLicense;

  DriverLicenseModel({
    required this.licenseNumber,
    required this.licenseExpiryDate,
    required this.uploadDriversLicense,
  });

  factory DriverLicenseModel.fromJson(Map<String, dynamic> json) {
    return DriverLicenseModel(
      licenseNumber: json['licenseNumber'],
      licenseExpiryDate: DateTime.parse(json['licenseExpiryDate']),
      uploadDriversLicense: json['uploadDriversLicense'],
    );
  }

  Map<String, dynamic> toJson() => {
    'licenseNumber': licenseNumber,
    'licenseExpiryDate': licenseExpiryDate.toIso8601String(),
    'uploadDriversLicense': uploadDriversLicense,
  };
}

class DriverVehicleModel {
  final String vehiclesMake;
  final String vehiclesModel;
  final DateTime vehiclesYear;
  final int vehiclesRegistrationNumber;
  final int vehiclesInsuranceNumber;
  final int vehiclesPicture;
  final int vehiclesCategory;

  DriverVehicleModel({
    required this.vehiclesMake,
    required this.vehiclesModel,
    required this.vehiclesYear,
    required this.vehiclesRegistrationNumber,
    required this.vehiclesInsuranceNumber,
    required this.vehiclesPicture,
    required this.vehiclesCategory,
  });

  factory DriverVehicleModel.fromJson(Map<String, dynamic> json) {
    return DriverVehicleModel(
      vehiclesMake: json['vehiclesMake'],
      vehiclesModel: json['vehiclesModel'],
      vehiclesYear: DateTime.parse(json['vehiclesYear']),
      vehiclesRegistrationNumber: json['vehiclesRegistrationNumber'],
      vehiclesInsuranceNumber: json['vehiclesInsuranceNumber'],
      vehiclesPicture: json['vehiclesPicture'],
      vehiclesCategory: json['vehiclesCategory'],
    );
  }

  Map<String, dynamic> toJson() => {
    'vehiclesMake': vehiclesMake,
    'vehiclesModel': vehiclesModel,
    'vehiclesYear': vehiclesYear.toIso8601String(),
    'vehiclesRegistrationNumber': vehiclesRegistrationNumber,
    'vehiclesInsuranceNumber': vehiclesInsuranceNumber,
    'vehiclesPicture': vehiclesPicture,
    'vehiclesCategory': vehiclesCategory,
  };
}

class DriverModel {
  final String? id;
  final String? name;
  final String? role;
  final String? contact;
  final String? email;
  final String? password;
  final LocationModel? location;
  final String? image;
  final String? status;
  final bool? verified;
  final String? gender;
  final DateTime? dateOfBirth;
  final DriverLicenseModel? driverLicense;
  final DriverVehicleModel? driverVehicles;

  DriverModel({
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

  factory DriverModel.fromJson(Map<String, dynamic> json) {
    return DriverModel(
      id: json['_id'] ?? '',
      name: json['name'],
      role: json['role'],
      contact: json['contact'] ?? '',
      email: json['email'],
      password: json['password'],
      location: LocationModel.fromJson(json['location']),
      image: json['image'],
      status: json['status'],
      verified: json['verified'],
      gender: json['gender'],
      dateOfBirth: DateTime.parse(json['dateOfBirth']),
      driverLicense: DriverLicenseModel.fromJson(json['driverLicense']),
      driverVehicles: DriverVehicleModel.fromJson(json['driverVehicles']),
    );
  }

  Map<String, dynamic> toJson() => {
    'name': name,
    'role': role,
    'contact': contact,
    'email': email,
    'password': password,
    'location': location?.toJson(),
    'image': image,
    'status': status,
    'verified': verified,
    'gender': gender,
    'dateOfBirth': dateOfBirth?.toIso8601String(),
    'driverLicense': driverLicense?.toJson(),
    'driverVehicles': driverVehicles?.toJson(),
  };
}
