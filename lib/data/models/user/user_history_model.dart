import 'package:cabwire/domain/entities/user_entity.dart';

class UserHistoryModel extends UserEntity {
  final String? id;
  final String? image;
  final String? status;
  final bool? verified;
  final bool? isOnline;
  final String? contact;
  final Map<String, dynamic>? driverVehicles;

  const UserHistoryModel({
    super.name,
    super.email,
    super.role,
    super.password,
    this.id,
    this.image,
    this.status,
    this.verified,
    this.isOnline,
    this.contact,
    this.driverVehicles,
  });

  factory UserHistoryModel.fromJson(Map<String, dynamic> json) {
    return UserHistoryModel(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      role: json['role'] ?? '',
      password: json['password'],
      image: json['image'] ?? '',
      status: json['status'] ?? '',
      verified: json['verified'] ?? false,
      isOnline: json['isOnline'] ?? false,
      contact: json['contact'],
      driverVehicles:
          json['driverVehicles'] != null
              ? Map<String, dynamic>.from(json['driverVehicles'])
              : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'role': role,
      'email': email,
      'password': password,
      'image': image,
      'status': status,
      'verified': verified,
      'isOnline': isOnline,
      'contact': contact,
      'driverVehicles': driverVehicles,
    };
  }
}
