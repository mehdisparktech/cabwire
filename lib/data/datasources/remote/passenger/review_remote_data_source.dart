import 'package:cabwire/core/base/result.dart';
import 'package:cabwire/core/config/api/api_end_point.dart';
import 'package:cabwire/domain/services/api_service.dart';
import 'package:fpdart/fpdart.dart';

abstract class ReviewRemoteDataSource {
  Future<Result<String>> getReviews(
    String serviceType,
    String serviceId,
    String comment,
    int rating,
  );
}

class ReviewRemoteDataSourceImpl implements ReviewRemoteDataSource {
  final ApiService apiService;

  ReviewRemoteDataSourceImpl(this.apiService);

  @override
  Future<Result<String>> getReviews(
    String serviceType,
    String serviceId,
    String comment,
    int rating,
  ) async {
    final response = await apiService.post(
      ApiEndPoint.review,
      body: {
        "serviceType": serviceType,
        "serviceId": serviceId,
        "comment": comment,
        "rating": rating,
      },
    );
    return response.fold(
      (failure) => left(failure.message.toString()),
      (response) => right(response.message.toString()),
    );
  }
}
