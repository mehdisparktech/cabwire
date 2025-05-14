import 'package:cabwire/core/base/base_use_case.dart';
import 'package:cabwire/domain/user/repositories/user_data_repository.dart';

class DetermineFirstRunUseCase extends BaseUseCase<bool> {
  DetermineFirstRunUseCase(this._userDataRepository, super.errorMessageHandler);

  final UserDataRepository _userDataRepository;

  Future<bool> execute() async {
    return getRight(() async => _userDataRepository.determineFirstRun());
  }
}
