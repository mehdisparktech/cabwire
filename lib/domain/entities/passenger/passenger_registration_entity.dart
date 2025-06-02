import 'package:cabwire/core/base/base_entity.dart';

class PassengerRegistrationEntity extends BaseEntity {
  final String id;
  final String email;
  final String name;
  final String? phone;
  final String? profileImage;
  final bool isVerified;

  const PassengerRegistrationEntity({
    required this.id,
    required this.email,
    required this.name,
    this.phone,
    this.profileImage,
    required this.isVerified,
  });

  @override
  List<Object?> get props => [id, email, name, phone, profileImage, isVerified];
}
