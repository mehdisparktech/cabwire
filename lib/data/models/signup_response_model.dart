import 'package:cabwire/domain/entities/signup_response_entity.dart';

class SignupResponseModel extends SignupResponseEntity {
  const SignupResponseModel({
    required super.success,
    required super.message,
    super.data,
  });

  factory SignupResponseModel.fromJson(Map<String, dynamic> json) {
    return SignupResponseModel(
      success: json['success'],
      message: json['message'],
      data: UserDataModel.fromJson(json['data']),
    );
  }
}

class UserDataModel extends UserDataEntity {
  const UserDataModel({
    super.name,
    super.role,
    super.email,
    super.password,
    super.image,
    super.status,
    super.verified,
    super.isOnline,
    super.isDeleted,
    super.id,
    super.createdAt,
    super.updatedAt,
    super.geoLocation,
  });

  factory UserDataModel.fromJson(Map<String, dynamic> json) {
    return UserDataModel(
      name: json['name'] ?? '',
      role: json['role'] ?? '',
      email: json['email'] ?? '',
      password: json['password'] ?? '',
      image: json['image'] ?? '',
      status: json['status'] ?? '',
      verified: json['verified'] ?? false,
      isOnline: json['isOnline'] ?? false,
      isDeleted: json['isDeleted'] ?? false,
      id: json['_id'] ?? '',
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
      geoLocation:
          json['geoLocation'] != null
              ? GeoLocationModel.fromJson(json['geoLocation'])
              : null,
    );
  }
}

class GeoLocationModel extends GeoLocationEntity {
  const GeoLocationModel({super.type, super.coordinates});

  factory GeoLocationModel.fromJson(Map<String, dynamic> json) {
    return GeoLocationModel(
      type: json['type'] ?? '',
      coordinates:
          (json['coordinates'] as List?)
              ?.map((e) => (e as num).toDouble())
              .toList() ??
          [],
    );
  }
}
