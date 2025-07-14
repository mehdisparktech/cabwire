import 'package:cabwire/core/base/result.dart';

abstract class TermsAndConditionsRepository {
  Future<Result<String>> getTermsAndConditions({required String forType});
}
