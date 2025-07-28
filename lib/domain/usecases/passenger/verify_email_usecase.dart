import 'package:cabwire/core/base/base_use_case.dart';
import 'package:cabwire/core/base/result.dart';
import 'package:cabwire/domain/entities/passenger/verify_email_entity.dart';
import 'package:cabwire/domain/repositories/verify_email_repository.dart';

class VerifyEmailParams {
  final String email;
  final int oneTimeCode;

  VerifyEmailParams({required this.email, required this.oneTimeCode});
}

class VerifyEmailUseCase extends BaseUseCase<VerifyEmailEntity> {
  final VerifyEmailRepository _verifyEmailRepository;

  VerifyEmailUseCase(super.errorMessageHandler, this._verifyEmailRepository);

  Future<Result<VerifyEmailEntity>> execute(VerifyEmailParams params) async {
    return _verifyEmailRepository.verifyEmail(params.email, params.oneTimeCode);
  }
}
