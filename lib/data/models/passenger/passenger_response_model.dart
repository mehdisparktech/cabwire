class PassengerResponseModel {
  final bool success;
  final String message;
  final PassengerDataModel data;

  PassengerResponseModel({
    required this.success,
    required this.message,
    required this.data,
  });

  factory PassengerResponseModel.fromJson(Map<String, dynamic> json) {
    return PassengerResponseModel(
      success: json['success'] as bool,
      message: json['message'] as String,
      data: PassengerDataModel.fromJson(json['data'] as Map<String, dynamic>),
    );
  }
}

class PassengerDataModel {
  final String name;
  final LocationModel? location;
  final String role;
  final String email;
  final String password;
  final String? image;
  final String? status;
  final bool? verified;
  final String? id;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  PassengerDataModel({
    required this.name,
    this.location,
    required this.role,
    required this.email,
    required this.password,
    this.image,
    this.status,
    this.verified,
    this.id,
    this.createdAt,
    this.updatedAt,
  });

  factory PassengerDataModel.fromJson(Map<String, dynamic> json) {
    return PassengerDataModel(
      name: json['name'] as String,
      location:
          json['location'] != null
              ? LocationModel.fromJson(json['location'] as Map<String, dynamic>)
              : null,
      role: json['role'] as String,
      email: json['email'] as String,
      password: json['password'] as String,
      image: json['image'] as String?,
      status: json['status'] as String?,
      verified: json['verified'] as bool?,
      id: json['_id'] as String?,
      createdAt:
          json['createdAt'] != null
              ? DateTime.parse(json['createdAt'] as String)
              : null,
      updatedAt:
          json['updatedAt'] != null
              ? DateTime.parse(json['updatedAt'] as String)
              : null,
    );
  }
}

class LocationModel {
  final double lat;
  final double lng;
  final String address;

  LocationModel({required this.lat, required this.lng, required this.address});

  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(
      lat: (json['lat'] as num).toDouble(),
      lng: (json['lng'] as num).toDouble(),
      address: json['address'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {'lat': lat, 'lng': lng, 'address': address};
  }
}
