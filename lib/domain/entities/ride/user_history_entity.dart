import 'package:cabwire/core/base/base_entity.dart';

class UserHistoryEntity extends BaseEntity {
  final String id;
  final String name;
  final String role;
  final String email;
  final String image;
  final String status;
  final bool verified;
  final bool isOnline;
  final String? contact;
  final Map<String, dynamic>? driverVehicles;

  const UserHistoryEntity({
    required this.id,
    required this.name,
    required this.role,
    required this.email,
    required this.image,
    required this.status,
    required this.verified,
    required this.isOnline,
    this.contact,
    this.driverVehicles,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    role,
    email,
    image,
    status,
    verified,
    isOnline,
    contact,
    driverVehicles,
  ];
}
