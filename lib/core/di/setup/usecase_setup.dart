import 'dart:developer';

import 'package:cabwire/domain/usecases/complete_ride_usecase.dart';
import 'package:cabwire/domain/usecases/create_ride_request_usecase.dart';
import 'package:cabwire/domain/usecases/driver/driver_contact_usecase.dart';
import 'package:cabwire/domain/usecases/driver/driver_profile_update_usecase.dart';
import 'package:cabwire/domain/usecases/driver/driver_reset_password_usecase.dart';
import 'package:cabwire/domain/usecases/driver/forget_password_usecase.dart';
import 'package:cabwire/domain/usecases/driver/get_driver_earnings_usecase.dart';
import 'package:cabwire/domain/usecases/driver/resent_code_usecase.dart';
import 'package:cabwire/domain/usecases/driver/sign_in_usecase.dart';
import 'package:cabwire/domain/usecases/driver/driver_sign_up_usecase.dart';
import 'package:cabwire/domain/usecases/driver/verify_email_usecase.dart';
import 'package:cabwire/domain/usecases/notifications_usecase.dart';
import 'package:cabwire/domain/usecases/passenger/cencel_ride_usecase.dart';
import 'package:cabwire/domain/usecases/passenger/reset_password_usecase.dart';
import 'package:cabwire/domain/usecases/passenger/verify_email_usecase.dart';
import 'package:cabwire/domain/usecases/passenger_sign_in_usecase.dart';
import 'package:cabwire/domain/usecases/terms_and_conditions_usecase.dart';
import 'package:cabwire/domain/usecases/update_online_status_usecase.dart';
import 'package:get_it/get_it.dart';
import 'package:cabwire/core/di/service_locator.dart';
import 'package:cabwire/core/di/setup/setup_module.dart';
import 'package:cabwire/domain/usecases/determine_first_run_use_case.dart';
import 'package:cabwire/domain/usecases/get_device_info_usecase.dart';
import 'package:cabwire/domain/usecases/register_device_usecase.dart';
import 'package:cabwire/domain/usecases/save_first_time_use_case.dart';
import 'package:cabwire/domain/usecases/location/check_location_permission_usecase.dart';
import 'package:cabwire/domain/usecases/location/get_current_location_usecase.dart';
import 'package:cabwire/domain/usecases/location/get_location_updates_usecase.dart';
import 'package:cabwire/domain/usecases/location/request_location_permission_usecase.dart';
import 'package:cabwire/domain/usecases/passenger/create_passenger_usecase.dart';
import 'package:cabwire/domain/usecases/passenger/get_passenger_services_usecase.dart';
import 'package:cabwire/domain/usecases/passenger/get_passenger_categories_usecase.dart';

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
      )
      ..registerLazySingleton(() => SignInUsecase(locate()))
      ..registerLazySingleton(() => DriverSignUpUseCase(locate()))
      ..registerLazySingleton(() => VerifyEmailUsecase(locate(), locate()))
      ..registerLazySingleton(() => ResentCodeUsecase(locate(), locate()))
      ..registerLazySingleton(() => ForgetPasswordUsecase(locate(), locate()))
      ..registerLazySingleton(
        () => DriverProfileUpdateUsecase(locate(), locate()),
      )
      ..registerLazySingleton(
        () => DriverResetPasswordUsecase(locate(), locate()),
      )
      ..registerLazySingleton(() => UpdateOnlineStatusUseCase(locate()))
      ..registerLazySingleton(() => DriverContactUseCase(locate()))
      ..registerLazySingleton(() => GetPassengerServicesUseCase(locate()))
      ..registerLazySingleton(() => GetPassengerCategoriesUseCase(locate()))
      ..registerLazySingleton(() => CreatePassengerUseCase(locate()))
      ..registerLazySingleton(() => VerifyEmailUseCase(locate(), locate()))
      ..registerLazySingleton(
        () => CreateRideRequestUseCase(locate(), locate()),
      )
      ..registerLazySingleton(() => CompleteRideUseCase(locate()))
      ..registerLazySingleton(() => CancelRideUseCase(locate(), locate()))
      ..registerLazySingleton(() => NotificationsUseCase(locate(), locate()))
      ..registerLazySingleton(() => GetDriverEarningsUseCase(locate()))
      ..registerLazySingleton(() => PassengerSignInUsecase(locate()))
      ..registerLazySingleton(() => ResetPasswordUseCase(locate()))
      ..registerLazySingleton(() => TermsAndConditionsUsecase(locate()));
  }
}
