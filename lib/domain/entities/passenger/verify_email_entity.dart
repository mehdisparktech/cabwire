import 'package:cabwire/core/base/base_entity.dart';

class VerifyEmailEntity extends BaseEntity {
  final bool success;
  final String message;

  const VerifyEmailEntity({required this.success, required this.message});

  @override
  List<Object?> get props => [success, message];
}
