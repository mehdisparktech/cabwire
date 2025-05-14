import 'package:get_it/get_it.dart';
import 'package:cabwire/core/di/service_locator.dart';
import 'package:cabwire/core/di/setup/setup_module.dart';
import 'package:cabwire/data/driver/repositories/device_info_repository_impl.dart';
import 'package:cabwire/data/driver/repositories/payment_repository_impl.dart';
import 'package:cabwire/data/driver/repositories/user_data_repository_impl.dart';
import 'package:cabwire/domain/user/repositories/device_info_repository.dart';
import 'package:cabwire/domain/user/repositories/payment_repository.dart';
import 'package:cabwire/domain/user/repositories/user_data_repository.dart';

class RepositorySetup implements SetupModule {
  final GetIt _serviceLocator;
  RepositorySetup(this._serviceLocator);

  @override
  Future<void> setup() async {
    _serviceLocator
      ..registerLazySingleton<UserDataRepository>(
        () => UserDataRepositoryImpl(locate(), locate()),
      )
      ..registerLazySingleton<PaymentRepository>(
        () => PaymentRepositoryImpl(locate(), locate()),
      )
      ..registerLazySingleton<DeviceInfoRepository>(
        () => DeviceInfoRepositoryImpl(locate(), locate(), locate()),
      );
  }
}
