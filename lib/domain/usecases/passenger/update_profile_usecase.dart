import 'package:cabwire/core/base/result.dart';
import 'package:cabwire/domain/repositories/passenger/passenger_auth_repository.dart';

class UpdateProfileUsecase {
  final PassengerAuthRepository _passengerAuthRepository;

  UpdateProfileUsecase(this._passengerAuthRepository);

  Future<Result<String>> execute(
    String? name,
    String? contact,
    String? profileImage,
  ) async {
    return _passengerAuthRepository.updatePassengerProfile(
      name,
      contact,
      profileImage,
    );
  }
}
