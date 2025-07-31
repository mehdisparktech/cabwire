import 'package:cabwire/core/base/base_use_case.dart';
import 'package:cabwire/core/base/result.dart';
import 'package:cabwire/core/utility/log/app_log.dart';
import 'package:cabwire/domain/repositories/driver/driver_auth_repository.dart';

class DriverConfirmInformationUsecase extends BaseUseCase<String> {
  final DriverAuthRepository repository;

  DriverConfirmInformationUsecase(super.errorMessageHandler, this.repository);

  Future<Result<String>> execute({
    required String name,
    required String contact,
    required String gender,
    required String dateOfBirth,
    required String email,
    String? profileImage,
  }) async {
    appLog("usecase ==========>$email");
    return repository.confirmDriverInformation(
      name: name,
      contact: contact,
      gender: gender,
      dateOfBirth: dateOfBirth,
      profileImage: profileImage,
      email: email,
    );
  }
}
