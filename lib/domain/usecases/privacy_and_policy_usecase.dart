import 'package:cabwire/core/base/result.dart';
import 'package:cabwire/domain/repositories/terms_and_conditions_repository.dart';

class PrivacyAndPolicyUsecase {
  final TermsAndConditionsRepository _repository;

  PrivacyAndPolicyUsecase(this._repository);

  Future<Result<String>> execute({required String forType}) async {
    return _repository.getPrivacyPolicy(forType: forType);
  }
}
