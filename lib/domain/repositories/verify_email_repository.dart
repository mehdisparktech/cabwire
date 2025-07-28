import 'package:cabwire/core/base/result.dart';
import 'package:cabwire/domain/entities/passenger/verify_email_entity.dart';

abstract class VerifyEmailRepository {
  Future<Result<VerifyEmailEntity>> verifyEmail(String email, int oneTimeCode);
}
