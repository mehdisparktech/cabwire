import 'package:cabwire/data/models/verify_email_response_model.dart';
import 'package:cabwire/domain/entities/passenger/verify_email_entity.dart';

class VerifyEmailMapper {
  static VerifyEmailEntity toEntity(VerifyEmailResponseModel model) {
    return VerifyEmailEntity(success: model.success, message: model.message);
  }

  static VerifyEmailResponseModel fromEntity(VerifyEmailEntity entity) {
    return VerifyEmailResponseModel(
      success: entity.success,
      message: entity.message,
      data: {},
    );
  }
}
