import 'package:cabwire/core/base/base_use_case.dart';
import 'package:cabwire/domain/repositories/passenger/passenger_repository.dart';
import 'package:cabwire/domain/services/error_message_handler.dart';
import 'package:fpdart/fpdart.dart';

class PassengerProfilePhotoUsecase extends BaseUseCase<void> {
  final PassengerRepository passengerRepository;

  PassengerProfilePhotoUsecase(
    this.passengerRepository,
    ErrorMessageHandler errorMessageHandler,
  ) : super(errorMessageHandler);

  Future<Either<String, void>> execute(String email, String photo) async {
    return mapResultToEither(() async {
      await passengerRepository.updateProfilePhoto(email, photo);
      return;
    });
  }
}
