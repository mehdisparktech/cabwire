import 'package:cabwire/core/base/result.dart';
import 'package:cabwire/core/config/api/api_end_point.dart';
import 'package:cabwire/core/utility/log/app_log.dart';
import 'package:cabwire/data/services/api/api_service_impl.dart';
import 'package:fpdart/fpdart.dart';

abstract class TermsAndConditionsRemoteDataSource {
  Future<Result<String>> getTermsAndConditions({required String forType});
  Future<Result<String>> getPrivacyPolicy({required String forType});
}

class TermsAndConditionsRemoteDataSourceImpl
    implements TermsAndConditionsRemoteDataSource {
  final apiService = ApiServiceImpl.instance;

  @override
  Future<Result<String>> getTermsAndConditions({
    required String forType,
  }) async {
    try {
      final result = await apiService.get(
        ApiEndPoint.termsOfServices,
        query: {'for': forType},
      );
      appLog(
        " TermsAndConditionsRemoteDataSourceImpl ${result.fold((l) => l, (r) => r)}",
      );
      return result.fold((l) => left(l.message), (r) {
        // Correctly access the nested data structure
        // The content is in r.data['data']['content']
        final contentData = r.data['data'] as Map<String, dynamic>?;
        final content =
            contentData?['content']?.toString() ??
            'Terms and conditions not available';
        return right(content);
      });
    } catch (e) {
      return left(e.toString());
    }
  }

  @override
  Future<Result<String>> getPrivacyPolicy({required String forType}) async {
    try {
      final result = await apiService.get(
        ApiEndPoint.privacyPolicy,
        query: {'for': forType},
      );
      appLog(
        " PrivacyPolicyRemoteDataSourceImpl ${result.fold((l) => l, (r) => r)}",
      );
      return result.fold((l) => left(l.message), (r) {
        final contentData = r.data['data'] as Map<String, dynamic>?;
        final content =
            contentData?['content']?.toString() ??
            'Privacy policy not available';
        return right(content);
      });
    } catch (e) {
      return left(e.toString());
    }
  }
}
