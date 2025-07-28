import 'package:cabwire/core/base/result.dart';
import 'package:cabwire/core/config/api/api_end_point.dart';
import 'package:cabwire/data/models/verify_email_response_model.dart';
import 'package:cabwire/data/services/api/api_service_impl.dart';
import 'package:fpdart/fpdart.dart';

abstract class VerifyEmailRemoteDataSource {
  Future<Result<VerifyEmailResponseModel>> verifyEmail(
    String email,
    int oneTimeCode,
  );
}

class VerifyEmailRemoteDataSourceImpl implements VerifyEmailRemoteDataSource {
  final apiService = ApiServiceImpl.instance;

  @override
  Future<Result<VerifyEmailResponseModel>> verifyEmail(
    String email,
    int oneTimeCode,
  ) async {
    try {
      final result = await apiService.post(
        ApiEndPoint.verifyEmail,
        body: {'email': email, 'oneTimeCode': oneTimeCode},
      );

      return result.fold(
        (l) => left(l.message),
        (r) => right(VerifyEmailResponseModel.fromJson(r.data)),
      );
    } catch (e) {
      return left(e.toString());
    }
  }
}
