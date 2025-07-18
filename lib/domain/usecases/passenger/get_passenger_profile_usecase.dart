import 'package:cabwire/data/models/profile_model.dart';
import 'package:cabwire/domain/repositories/passenger/passenger_auth_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:cabwire/data/services/storage/storage_services.dart';

class GetPassengerProfileUsecase {
  final PassengerAuthRepository _passengerAuthRepository;

  GetPassengerProfileUsecase(this._passengerAuthRepository);

  Future<Either<String, ProfileResponseModel>> execute() async {
    return _passengerAuthRepository.getPassengerProfile(
      'Bearer ${LocalStorage.token}',
    );
  }
}
