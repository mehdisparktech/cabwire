import 'package:cabwire/core/base/base_entity.dart';

class ContactUsEntity extends BaseEntity {
  final String fullName;
  final String email;
  final String? phone;
  final String subject;
  final String description;
  final bool status;

  const ContactUsEntity({
    required this.fullName,
    required this.email,
    this.phone,
    required this.subject,
    required this.description,
    required this.status,
  });

  @override
  List<Object?> get props => [
    fullName,
    email,
    phone,
    subject,
    description,
    status,
  ];
}
