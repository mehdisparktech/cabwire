import 'package:get_it/get_it.dart';
import 'package:cabwire/core/di/service_locator.dart';
import 'package:cabwire/core/di/setup/setup_module.dart';
import 'package:cabwire/data/datasources/local/user_data_local_data_source.dart';
import 'package:cabwire/data/datasources/remote/device_info_remote_data_source.dart';
import 'package:cabwire/data/datasources/remote/driver_all_remote_data_source.dart';
import 'package:cabwire/data/datasources/remote/info_remote_data_source.dart';
import 'package:cabwire/data/datasources/local/location_local_data_source.dart';
import 'package:cabwire/data/datasources/remote/driver_auth_remote_data_source.dart';
import 'package:cabwire/data/datasources/remote/driver_profile_remote_data_source.dart';
import 'package:cabwire/data/datasources/remote/passenger_remote_data_source.dart';
import 'package:cabwire/data/datasources/remote/verify_email_remote_data_source.dart';
import 'package:cabwire/data/datasources/remote/passenger_service_remote_data_source.dart';
import 'package:cabwire/data/datasources/remote/passenger_category_remote_data_source.dart';

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
      ..registerLazySingleton<LocationLocalDataSource>(
        () => LocationLocalDataSourceImpl(locate()),
      )
      ..registerLazySingleton<DriverAuthRemoteDataSource>(
        () => DriverAuthRemoteDataSourceImpl(),
      )
      ..registerLazySingleton<DriverAllRemoteDataSource>(
        () => DriverAllRemoteDataSourceImpl(),
      )
      ..registerLazySingleton<DriverProfileRemoteDataSource>(
        () => DriverProfileRemoteDataSourceImpl(),
      )
      ..registerLazySingleton<VerifyEmailRemoteDataSource>(
        () => VerifyEmailRemoteDataSourceImpl(),
      )
      ..registerLazySingleton<PassengerServiceRemoteDataSource>(
        () => PassengerServiceRemoteDataSourceImpl(locate()),
      )
      ..registerLazySingleton<PassengerCategoryRemoteDataSource>(
        () => PassengerCategoryRemoteDataSourceImpl(locate()),
      )
      ..registerLazySingleton<PassengerRemoteDataSource>(
        () => PassengerRemoteDataSourceImpl(locate()),
      );
  }
}
