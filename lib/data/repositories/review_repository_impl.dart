import 'package:cabwire/core/base/result.dart';
import 'package:cabwire/data/datasources/remote/passenger/review_remote_data_source.dart';
import 'package:cabwire/domain/repositories/review_repository.dart';
import 'package:fpdart/fpdart.dart' show left;

class ReviewRepositoryImpl implements ReviewRepository {
  final ReviewRemoteDataSource _remoteDataSource;

  ReviewRepositoryImpl(this._remoteDataSource);

  @override
  Future<Result<String>> submitReview(
    String serviceType,
    String serviceId,
    String comment,
    int rating,
  ) async {
    try {
      // Call the remote data source
      final result = await _remoteDataSource.getReviews(
        serviceType,
        serviceId,
        comment,
        rating,
      );

      // Return the result
      return result;
    } catch (e) {
      return left(e.toString());
    }
  }
}
