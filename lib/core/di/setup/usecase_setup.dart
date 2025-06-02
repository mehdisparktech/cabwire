import 'dart:developer';

import 'package:get_it/get_it.dart';
import 'package:cabwire/core/di/service_locator.dart';
import 'package:cabwire/core/di/setup/setup_module.dart';
import 'package:cabwire/domain/usecases/determine_first_run_use_case.dart';
import 'package:cabwire/domain/usecases/get_bank_payments_usecase.dart';
import 'package:cabwire/domain/usecases/get_device_info_usecase.dart';
import 'package:cabwire/domain/usecases/get_mobile_payments_usecase.dart';
import 'package:cabwire/domain/usecases/register_device_usecase.dart';
import 'package:cabwire/domain/usecases/save_first_time_use_case.dart';
import 'package:cabwire/domain/auth/usecases/login_usecase.dart';
import 'package:cabwire/domain/auth/usecases/register_usecase.dart';
import 'package:cabwire/domain/usecases/location/check_location_permission_usecase.dart';
import 'package:cabwire/domain/usecases/location/get_current_location_usecase.dart';
import 'package:cabwire/domain/usecases/location/get_location_updates_usecase.dart';
import 'package:cabwire/domain/usecases/location/request_location_permission_usecase.dart';

class UsecaseSetup implements SetupModule {
  final GetIt _serviceLocator;
  UsecaseSetup(this._serviceLocator);

  @override
  Future<void> setup() async {
    log('init usecase setup');
    _serviceLocator
      ..registerLazySingleton(
        () => DetermineFirstRunUseCase(locate(), locate()),
      )
      ..registerLazySingleton(() => SaveFirstTimeUseCase(locate(), locate()))
      ..registerLazySingleton(() => GetDeviceInfoUsecase(locate(), locate()))
      ..registerLazySingleton(() => RegisterDeviceUsecase(locate(), locate()))
      ..registerLazySingleton(() => GetBankPaymentsUseCase(locate(), locate()))
      ..registerLazySingleton(
        () => GetMobilePaymentsUseCase(locate(), locate()),
      )
      ..registerFactory(() => LoginUseCase(locate()))
      ..registerFactory(() => RegisterUseCase(locate()))
      ..registerLazySingleton(
        () => CheckLocationPermissionUsecase(locate(), locate()),
      )
      ..registerLazySingleton(
        () => RequestLocationPermissionUsecase(locate(), locate()),
      )
      ..registerLazySingleton(
        () => GetCurrentLocationUsecase(locate(), locate()),
      )
      ..registerLazySingleton(
        () => GetLocationUpdatesUsecase(locate(), locate()),
      );
  }
}
