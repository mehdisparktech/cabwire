import 'package:fpdart/fpdart.dart';
import 'package:cabwire/domain/entities/device_info_entity.dart';

abstract class DeviceInfoRepository {
  /// Register a device
  Future<void> registerDevice();

  /// Get all registered devices
  Stream<Either<String, List<DeviceInfoEntity>>> getAllRegisteredDevices();
}
