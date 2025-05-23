import 'package:fpdart/fpdart.dart';
import 'package:cabwire/core/base/base_use_case.dart';
import 'package:cabwire/domain/user/entities/device_info_entity.dart';
import 'package:cabwire/domain/user/repositories/device_info_repository.dart';
import 'package:cabwire/domain/user/service/error_message_handler.dart';

class GetDeviceInfoUsecase extends BaseUseCase<List<DeviceInfoEntity>> {
  final DeviceInfoRepository _deviceInfoRepository;

  GetDeviceInfoUsecase(
    this._deviceInfoRepository,
    ErrorMessageHandler errorMessageHandler,
  ) : super(errorMessageHandler);

  Stream<Either<String, List<DeviceInfoEntity>>> execute() {
    return _deviceInfoRepository.getAllRegisteredDevices();
  }
}
