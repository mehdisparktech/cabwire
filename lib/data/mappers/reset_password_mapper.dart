import 'package:cabwire/data/models/reset_password_model.dart';
import 'package:cabwire/domain/entities/reset_password_entity.dart';

class ResetPasswordMapper {
  static ResetPasswordEntity toEntity(ResetPasswordModel model) {
    return ResetPasswordEntity(
      currentPassword: model.currentPassword,
      newPassword: model.newPassword,
      confirmPassword: model.confirmPassword,
    );
  }

  static ResetPasswordModel toModel(ResetPasswordEntity entity) {
    return ResetPasswordModel(
      currentPassword: entity.currentPassword,
      newPassword: entity.newPassword,
      confirmPassword: entity.confirmPassword,
    );
  }
}
