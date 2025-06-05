import 'package:cabwire/domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({super.name, super.email, super.role, super.password});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      role: json['role'] ?? '',
      password: json['password'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'name': name, 'role': role, 'email': email, 'password': password};
  }
}
