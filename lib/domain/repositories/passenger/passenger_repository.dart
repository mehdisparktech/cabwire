import 'package:fpdart/fpdart.dart';

abstract class PassengerRepository {
  /// Create a new passenger
  ///
  /// Returns a [Future] with [Either] containing a [String] error or [void] on success
  Future<Either<String, void>> createPassenger({
    required String name,
    required String role,
    required String email,
    required String password,
  });
}
