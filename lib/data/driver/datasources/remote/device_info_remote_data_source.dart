import 'package:cabwire/data/driver/services/backend_as_a_service.dart';
import 'package:cabwire/domain/user/entities/device_info_entity.dart';

abstract class DeviceInfoRemoteDataSource {
  Future<void> registerDevice();
  Stream<List<DeviceInfoEntity>> getAllRegisteredDevices();
}

/// Device Info Remote Data Source

class DeviceInfoRemoteDataSourceImpl extends DeviceInfoRemoteDataSource {
  DeviceInfoRemoteDataSourceImpl(this._backendAsAService);
  final BackendAsAService _backendAsAService;

  @override
  Future<void> registerDevice() async {
    return _backendAsAService.registerDevice();
  }

  @override
  Stream<List<DeviceInfoEntity>> getAllRegisteredDevices() {
    return _backendAsAService.getAllRegisteredDevices();
  }
}
