import 'package:cabwire/domain/entities/profile_entity.dart';

class ProfileResponseModel {
  final bool? success;
  final String? message;
  final ProfileModel? data;

  ProfileResponseModel({this.success, this.message, this.data});

  factory ProfileResponseModel.fromJson(Map<String, dynamic> json) {
    return ProfileResponseModel(
      success: json['success'],
      message: json['message'],
      data: json['data'] != null ? ProfileModel.fromJson(json['data']) : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'success': success,
    'message': message,
    'data': data?.toJson(),
  };
}

class ProfileModel extends ProfileEntity {
  const ProfileModel({
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
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
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
              ? GeoLocationModel.fromJson(json['geoLocation'])
              : null,
      stripeAccountId: json['stripeAccountId'],
      createdAt:
          json['createdAt'] != null
              ? DateTime.tryParse(json['createdAt'])
              : null,
      updatedAt:
          json['updatedAt'] != null
              ? DateTime.tryParse(json['updatedAt'])
              : null,
      contact: json['contact'],
    );
  }

  Map<String, dynamic> toJson() => {
    '_id': id,
    'name': name,
    'role': role,
    'email': email,
    'image': image,
    'status': status,
    'verified': verified,
    'isOnline': isOnline,
    'isDeleted': isDeleted,
    'geoLocation':
        geoLocation != null ? (geoLocation as GeoLocationModel).toJson() : null,
    'stripeAccountId': stripeAccountId,
    'createdAt': createdAt?.toIso8601String(),
    'updatedAt': updatedAt?.toIso8601String(),
    'contact': contact,
  };
}

class GeoLocationModel extends GeoLocationEntity {
  const GeoLocationModel({super.type, super.coordinates});

  factory GeoLocationModel.fromJson(Map<String, dynamic> json) {
    return GeoLocationModel(
      type: json['type'],
      coordinates:
          json['coordinates'] != null
              ? List<double>.from(json['coordinates'].map((x) => x.toDouble()))
              : null,
    );
  }

  Map<String, dynamic> toJson() => {'type': type, 'coordinates': coordinates};
}
