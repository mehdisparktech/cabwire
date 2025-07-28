import 'package:cabwire/core/base/result.dart';
import 'package:cabwire/domain/repositories/review_repository.dart';
import 'package:equatable/equatable.dart';

/// Parameters for the [SubmitReviewUseCase]
class SubmitReviewParams extends Equatable {
  final String serviceType;
  final String serviceId;
  final String comment;
  final int rating;

  const SubmitReviewParams({
    required this.serviceType,
    required this.serviceId,
    required this.comment,
    required this.rating,
  });

  @override
  List<Object?> get props => [serviceType, serviceId, comment, rating];
}

/// Use case for submitting a review
class SubmitReviewUseCase {
  final ReviewRepository _repository;

  SubmitReviewUseCase(this._repository);

  /// Executes the use case to submit a review
  ///
  /// Takes [SubmitReviewParams] containing the review details
  /// Returns a [Result<String>] indicating success or failure
  Future<Result<String>> execute(SubmitReviewParams params) async {
    return await _repository.submitReview(
      params.serviceType,
      params.serviceId,
      params.comment,
      params.rating,
    );
  }
}
