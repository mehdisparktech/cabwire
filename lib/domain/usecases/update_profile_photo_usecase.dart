import 'package:cabwire/core/base/base_use_case.dart';
import 'package:cabwire/domain/repositories/driver/driver_repository.dart';
import 'package:cabwire/domain/services/error_message_handler.dart';
import 'package:fpdart/fpdart.dart';

class UpdateProfilePhotoUsecase extends BaseUseCase<void> {
  final DriverRepository driverRepository;

  UpdateProfilePhotoUsecase(
    this.driverRepository,
    ErrorMessageHandler errorMessageHandler,
  ) : super(errorMessageHandler);

  Future<Either<String, void>> execute(String email, String photo) async {
    return mapResultToEither(() async {
      await driverRepository.updateProfilePhoto(email, photo);
      return;
    });
  }
}
