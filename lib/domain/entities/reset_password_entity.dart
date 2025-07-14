import 'package:cabwire/core/base/base_entity.dart';

class ResetPasswordEntity extends BaseEntity {
  final String currentPassword;
  final String newPassword;
  final String confirmPassword;

  const ResetPasswordEntity({
    required this.currentPassword,
    required this.newPassword,
    required this.confirmPassword,
  });

  @override
  List<Object?> get props => [currentPassword, newPassword, confirmPassword];
}
