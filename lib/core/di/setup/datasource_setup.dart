import 'package:get_it/get_it.dart';
import 'package:cabwire/core/di/service_locator.dart';
import 'package:cabwire/core/di/setup/setup_module.dart';
import 'package:cabwire/data/driver/datasources/local/user_data_local_data_source.dart';
import 'package:cabwire/data/driver/datasources/remote/device_info_remote_data_source.dart';
import 'package:cabwire/data/driver/datasources/remote/info_remote_data_source.dart';
import 'package:cabwire/data/driver/datasources/remote/payment_remote_data_source.dart';

class DatasourceSetup implements SetupModule {
  final GetIt _serviceLocator;
  DatasourceSetup(this._serviceLocator);

  @override
  Future<void> setup() async {
    _serviceLocator
      ..registerLazySingleton(() => UserDataLocalDataSource(locate()))
      ..registerLazySingleton<DeviceInfoRemoteDataSource>(
        () => DeviceInfoRemoteDataSourceImpl(locate()),
      )
      ..registerLazySingleton<InfoRemoteDataSource>(
        () => InfoRemoteDataSourceImpl(locate()),
      )
      ..registerLazySingleton<PaymentRemoteDataSource>(
        () => PaymentRemoteDataSourceImpl(locate()),
      );
  }
}
