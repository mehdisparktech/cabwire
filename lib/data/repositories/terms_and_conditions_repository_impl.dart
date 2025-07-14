import 'package:cabwire/core/base/result.dart';
import 'package:cabwire/core/utility/log/app_log.dart';
import 'package:cabwire/data/datasources/remote/terms_and_conditions_data_source.dart';
import 'package:cabwire/domain/repositories/terms_and_conditions_repository.dart';

class TermsAndConditionsRepositoryImpl extends TermsAndConditionsRepository {
  final TermsAndConditionsRemoteDataSource _remoteDataSource;

  TermsAndConditionsRepositoryImpl(this._remoteDataSource);

  @override
  Future<Result<String>> getTermsAndConditions({
    required String forType,
  }) async {
    final result = await _remoteDataSource.getTermsAndConditions(
      forType: forType,
    );
    appLog(
      "TermsAndConditionsRepositoryImpl ${result.fold((l) => l, (r) => r)}",
    );
    return result;
  }
}
