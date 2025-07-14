import 'package:cabwire/core/base/result.dart';
import 'package:cabwire/domain/entities/contact_us_entity.dart';
import 'package:cabwire/domain/repositories/driver/driver_profile_repository.dart';
import 'package:equatable/equatable.dart';

class DriverContactParams extends Equatable {
  final String fullName;
  final String email;
  final String? phone;
  final String subject;
  final String description;
  final bool status;

  const DriverContactParams({
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

class DriverContactUseCase {
  final DriverProfileRepository repository;

  DriverContactUseCase(this.repository);

  Future<Result<void>> call(DriverContactParams params) {
    final contactEntity = ContactUsEntity(
      fullName: params.fullName,
      email: params.email,
      phone: params.phone,
      subject: params.subject,
      description: params.description,
      status: params.status,
    );

    return repository.submitContactForm(contactEntity);
  }
}
