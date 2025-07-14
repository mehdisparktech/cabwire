import 'package:cabwire/core/base/result.dart';

abstract class ReviewRepository {
  /// Submit a review for a service
  ///
  /// Takes serviceType, serviceId, comment and rating
  /// Returns a [Result<String>] indicating success or failure
  Future<Result<String>> submitReview(
    String serviceType,
    String serviceId,
    String comment,
    int rating,
  );
}
