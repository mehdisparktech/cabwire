import 'package:cabwire/core/base/result.dart';

abstract class TermsAndConditionsRepository {
  Future<Result<String>> getTermsAndConditions({required String forType});
  Future<Result<String>> getPrivacyPolicy({required String forType});
}
