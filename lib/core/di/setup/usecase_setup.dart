import 'dart:developer';

import 'package:get_it/get_it.dart';
import 'package:cabwire/core/di/service_locator.dart';
import 'package:cabwire/core/di/setup/setup_module.dart';
import 'package:cabwire/domain/user/usecases/check_notification_permission_usecase.dart';
import 'package:cabwire/domain/user/usecases/determine_first_run_use_case.dart';
import 'package:cabwire/domain/user/usecases/get_bank_payments_usecase.dart';
import 'package:cabwire/domain/user/usecases/get_device_info_usecase.dart';
import 'package:cabwire/domain/user/usecases/get_mobile_payments_usecase.dart';
import 'package:cabwire/domain/user/usecases/register_device_usecase.dart';
import 'package:cabwire/domain/user/usecases/request_notification_permission_usecase.dart';
import 'package:cabwire/domain/user/usecases/save_first_time_use_case.dart';
import 'package:cabwire/domain/driver/auth/usecases/login_usecase.dart';
import 'package:cabwire/domain/driver/auth/usecases/register_usecase.dart';

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
      ..registerLazySingleton(
        () => CheckNotificationPermissionUsecase(locate(), locate()),
      )
      ..registerLazySingleton(
        () => RequestNotificationPermissionUsecase(locate(), locate()),
      )
      ..registerFactory(() => LoginUseCase(locate()))
      ..registerFactory(() => RegisterUseCase(locate()));
  }
}
