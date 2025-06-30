/// Location model for driver's location
class LocationModel {
  final double lat;
  final double lng;
  final String address;

  const LocationModel({
    required this.lat,
    required this.lng,
    required this.address,
  });

  /// Create from JSON data
  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(
      lat: (json['lat'] ?? 0.0) as double,
      lng: (json['lng'] ?? 0.0) as double,
      address: (json['address'] ?? '') as String,
    );
  }

  /// Convert to JSON data
  Map<String, dynamic> toJson() => {'lat': lat, 'lng': lng, 'address': address};

  /// Create a copy with updated values
  LocationModel copyWith({double? lat, double? lng, String? address}) {
    return LocationModel(
      lat: lat ?? this.lat,
      lng: lng ?? this.lng,
      address: address ?? this.address,
    );
  }
}

/// Model for driver's license information
class DriverLicenseModel {
  final int licenseNumber;
  final DateTime licenseExpiryDate;
  final String uploadDriversLicense;

  const DriverLicenseModel({
    required this.licenseNumber,
    required this.licenseExpiryDate,
    required this.uploadDriversLicense,
  });

  /// Create from JSON data
  factory DriverLicenseModel.fromJson(Map<String, dynamic> json) {
    return DriverLicenseModel(
      licenseNumber: (json['licenseNumber'] ?? 0) as int,
      licenseExpiryDate:
          json['licenseExpiryDate'] != null
              ? DateTime.parse(json['licenseExpiryDate'])
              : DateTime.now(),
      uploadDriversLicense: (json['uploadDriversLicense'] ?? '') as String,
    );
  }

  /// Convert to JSON data
  Map<String, dynamic> toJson() => {
    'licenseNumber': licenseNumber,
    'licenseExpiryDate': licenseExpiryDate.toIso8601String(),
    'uploadDriversLicense': uploadDriversLicense,
  };

  /// Create a copy with updated values
  DriverLicenseModel copyWith({
    int? licenseNumber,
    DateTime? licenseExpiryDate,
    String? uploadDriversLicense,
  }) {
    return DriverLicenseModel(
      licenseNumber: licenseNumber ?? this.licenseNumber,
      licenseExpiryDate: licenseExpiryDate ?? this.licenseExpiryDate,
      uploadDriversLicense: uploadDriversLicense ?? this.uploadDriversLicense,
    );
  }
}

/// Model for driver's vehicle information
class DriverVehicleModel {
  final String vehiclesMake;
  final String vehiclesModel;
  final DateTime vehiclesYear;
  final int vehiclesRegistrationNumber;
  final int vehiclesInsuranceNumber;
  final int vehiclesPicture;
  final int vehiclesCategory;

  const DriverVehicleModel({
    required this.vehiclesMake,
    required this.vehiclesModel,
    required this.vehiclesYear,
    required this.vehiclesRegistrationNumber,
    required this.vehiclesInsuranceNumber,
    required this.vehiclesPicture,
    required this.vehiclesCategory,
  });

  /// Create from JSON data
  factory DriverVehicleModel.fromJson(Map<String, dynamic> json) {
    return DriverVehicleModel(
      vehiclesMake: (json['vehiclesMake'] ?? '') as String,
      vehiclesModel: (json['vehiclesModel'] ?? '') as String,
      vehiclesYear:
          json['vehiclesYear'] != null
              ? DateTime.parse(json['vehiclesYear'])
              : DateTime.now(),
      vehiclesRegistrationNumber:
          (json['vehiclesRegistrationNumber'] ?? 0) as int,
      vehiclesInsuranceNumber: (json['vehiclesInsuranceNumber'] ?? 0) as int,
      vehiclesPicture: (json['vehiclesPicture'] ?? 0) as int,
      vehiclesCategory: (json['vehiclesCategory'] ?? 0) as int,
    );
  }

  /// Convert to JSON data
  Map<String, dynamic> toJson() => {
    'vehiclesMake': vehiclesMake,
    'vehiclesModel': vehiclesModel,
    'vehiclesYear': vehiclesYear.toIso8601String(),
    'vehiclesRegistrationNumber': vehiclesRegistrationNumber,
    'vehiclesInsuranceNumber': vehiclesInsuranceNumber,
    'vehiclesPicture': vehiclesPicture,
    'vehiclesCategory': vehiclesCategory,
  };

  /// Create a copy with updated values
  DriverVehicleModel copyWith({
    String? vehiclesMake,
    String? vehiclesModel,
    DateTime? vehiclesYear,
    int? vehiclesRegistrationNumber,
    int? vehiclesInsuranceNumber,
    int? vehiclesPicture,
    int? vehiclesCategory,
  }) {
    return DriverVehicleModel(
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

/// Main model class for driver information
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

  const DriverModel({
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

  /// Create from JSON data
  factory DriverModel.fromJson(Map<String, dynamic> json) {
    return DriverModel(
      id: json['_id'] as String?,
      name: json['name'] as String?,
      role: json['role'] as String?,
      contact: json['contact'] as String?,
      email: json['email'] as String?,
      password: json['password'] as String?,
      location:
          json['location'] != null
              ? LocationModel.fromJson(json['location'])
              : null,
      image: json['image'] as String?,
      status: json['status'] as String?,
      verified: json['verified'] as bool?,
      gender: json['gender'] as String?,
      dateOfBirth:
          json['dateOfBirth'] != null
              ? DateTime.parse(json['dateOfBirth'])
              : null,
      driverLicense:
          json['driverLicense'] != null
              ? DriverLicenseModel.fromJson(json['driverLicense'])
              : null,
      driverVehicles:
          json['driverVehicles'] != null
              ? DriverVehicleModel.fromJson(json['driverVehicles'])
              : null,
    );
  }

  /// Convert to JSON data
  Map<String, dynamic> toJson() => {
    if (name != null) 'name': name,
    if (role != null) 'role': role,
    if (contact != null) 'contact': contact,
    if (email != null) 'email': email,
    if (password != null) 'password': password,
    if (location != null) 'location': location!.toJson(),
    if (image != null) 'image': image,
    if (status != null) 'status': status,
    if (verified != null) 'verified': verified,
    if (gender != null) 'gender': gender,
    if (dateOfBirth != null) 'dateOfBirth': dateOfBirth!.toIso8601String(),
    if (driverLicense != null) 'driverLicense': driverLicense!.toJson(),
    if (driverVehicles != null) 'driverVehicles': driverVehicles!.toJson(),
  };

  /// Create a copy with updated values
  DriverModel copyWith({
    String? id,
    String? name,
    String? role,
    String? contact,
    String? email,
    String? password,
    LocationModel? location,
    String? image,
    String? status,
    bool? verified,
    String? gender,
    DateTime? dateOfBirth,
    DriverLicenseModel? driverLicense,
    DriverVehicleModel? driverVehicles,
  }) {
    return DriverModel(
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
