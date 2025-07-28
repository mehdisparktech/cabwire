import 'package:cabwire/core/base/base_entity.dart';

class SignupResponseEntity extends BaseEntity {
  final bool success;
  final String message;
  final UserDataEntity? data;

  const SignupResponseEntity({
    required this.success,
    required this.message,
    this.data,
  });

  @override
  List<Object?> get props => [success, message, data];
}

class UserDataEntity extends BaseEntity {
  final String? name;
  final String? role;
  final String? email;
  final String? password;
  final String? image;
  final String? status;
  final bool? verified;
  final bool? isOnline;
  final bool? isDeleted;
  final String? id;
  final String? createdAt;
  final String? updatedAt;
  final GeoLocationEntity? geoLocation;

  const UserDataEntity({
    this.name,
    this.role,
    this.email,
    this.password,
    this.image,
    this.status,
    this.verified,
    this.isOnline,
    this.isDeleted,
    this.id,
    this.createdAt,
    this.updatedAt,
    this.geoLocation,
  });

  @override
  List<Object?> get props => [
    name,
    role,
    email,
    password,
    image,
    status,
    verified,
    isOnline,
    isDeleted,
    id,
    createdAt,
    updatedAt,
    geoLocation,
  ];
}

class GeoLocationEntity extends BaseEntity {
  final String? type;
  final List<double>? coordinates;

  const GeoLocationEntity({this.type, this.coordinates});

  @override
  List<Object?> get props => [type, coordinates ?? []];
}
