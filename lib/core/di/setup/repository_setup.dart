import 'package:get_it/get_it.dart';
import 'package:cabwire/core/di/service_locator.dart';
import 'package:cabwire/core/di/setup/setup_module.dart';
import 'package:cabwire/data/repositories/device_info_repository_impl.dart';
import 'package:cabwire/data/repositories/user_data_repository_impl.dart';
import 'package:cabwire/domain/repositories/device_info_repository.dart';
import 'package:cabwire/domain/repositories/user_data_repository.dart';
import 'package:cabwire/domain/auth/repositories/driver_auth_repository.dart';
import 'package:cabwire/data/repositories/auth_repository_impl.dart';
import 'package:cabwire/data/repositories/location_repository_impl.dart';
import 'package:cabwire/domain/repositories/location_repository.dart';

class RepositorySetup implements SetupModule {
  final GetIt _serviceLocator;
  RepositorySetup(this._serviceLocator);

  @override
  Future<void> setup() async {
    _serviceLocator
      ..registerLazySingleton<UserDataRepository>(
        () => UserDataRepositoryImpl(locate(), locate()),
      )
      ..registerLazySingleton<DeviceInfoRepository>(
        () => DeviceInfoRepositoryImpl(locate(), locate(), locate()),
      )
      ..registerLazySingleton<DriverAuthRepository>(
        () => DriverAuthRepositoryImpl(),
      )
      ..registerLazySingleton<LocationRepository>(
        () => LocationRepositoryImpl(locate(), locate(), locate()),
      );
  }
}
