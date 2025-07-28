import 'package:cabwire/core/base/result.dart';
import 'package:cabwire/data/services/storage/storage_services.dart';
import 'package:cabwire/domain/repositories/passenger/passenger_auth_repository.dart';

class PassengerDeleteProfileUsecase {
  final PassengerAuthRepository _passengerAuthRepository;

  PassengerDeleteProfileUsecase(this._passengerAuthRepository);

  Future<Result<String>> execute(String password) async {
    final token = LocalStorage.token;
    return await _passengerAuthRepository.deleteMyAccount(token, password);
  }
}
