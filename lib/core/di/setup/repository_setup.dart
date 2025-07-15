import 'package:cabwire/data/repositories/chat_message_repository_impl.dart';
import 'package:cabwire/data/repositories/driver/driver_auth_repository_impl.dart';
import 'package:cabwire/data/repositories/notifications_repository_impl.dart';
import 'package:cabwire/data/repositories/passenger/passenger_auth_repository_impl.dart';
import 'package:cabwire/data/repositories/passenger/reset_password_repository_impl.dart';
import 'package:cabwire/data/repositories/review_repository_impl.dart';
import 'package:cabwire/data/repositories/terms_and_conditions_repository_impl.dart';
import 'package:cabwire/domain/repositories/chat_message_repository.dart';
import 'package:cabwire/domain/repositories/notifications_repository.dart';
import 'package:cabwire/domain/repositories/passenger/passenger_auth_repository.dart';
import 'package:cabwire/domain/repositories/passenger/reset_password_repository.dart';
import 'package:cabwire/domain/repositories/review_repository.dart';
import 'package:cabwire/domain/repositories/terms_and_conditions_repository.dart';
import 'package:get_it/get_it.dart';
import 'package:cabwire/core/di/service_locator.dart';
import 'package:cabwire/core/di/setup/setup_module.dart';
import 'package:cabwire/data/repositories/driver/device_info_repository_impl.dart';
import 'package:cabwire/data/repositories/driver/driver_profile_repository_impl.dart';
import 'package:cabwire/data/repositories/driver/driver_repository_impl.dart';
import 'package:cabwire/data/repositories/user_data_repository_impl.dart';
import 'package:cabwire/data/repositories/passenger/passenger_repository_impl.dart';
import 'package:cabwire/data/repositories/ride_repository_impl.dart';
import 'package:cabwire/data/repositories/verify_email_repository_impl.dart';
import 'package:cabwire/domain/repositories/driver/device_info_repository.dart';
import 'package:cabwire/domain/repositories/driver/driver_profile_repository.dart';
import 'package:cabwire/domain/repositories/driver/driver_repository.dart';
import 'package:cabwire/domain/repositories/user_data_repository.dart';
import 'package:cabwire/domain/repositories/driver/driver_auth_repository.dart';
import 'package:cabwire/data/repositories/location_repository_impl.dart';
import 'package:cabwire/domain/repositories/location_repository.dart';
import 'package:cabwire/domain/repositories/passenger/passenger_repository.dart';
import 'package:cabwire/domain/repositories/ride_repository.dart';
import 'package:cabwire/domain/repositories/verify_email_repository.dart';
import 'package:cabwire/data/repositories/passenger/passenger_service_repository_impl.dart';
import 'package:cabwire/domain/repositories/passenger/passenger_service_repository.dart';
import 'package:cabwire/data/repositories/passenger/passenger_category_repository_impl.dart';
import 'package:cabwire/domain/repositories/passenger/passenger_category_repository.dart';
import 'package:cabwire/domain/repositories/driver/driver_earnings_repository.dart';
import 'package:cabwire/data/repositories/driver/driver_earnings_repository_impl.dart';
import 'package:cabwire/data/repositories/send_message_repository_impl.dart';
import 'package:cabwire/domain/repositories/send_message_repository.dart';

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
        () => DriverAuthRepositoryImpl(locate()),
      )
      ..registerLazySingleton<PassengerAuthRepository>(
        () => PassengerAuthRepositoryImpl(locate()),
      )
      ..registerLazySingleton<LocationRepository>(
        () => LocationRepositoryImpl(locate(), locate(), locate()),
      )
      ..registerLazySingleton<DriverRepository>(
        () => DriverRepositoryImpl(locate()),
      )
      ..registerLazySingleton<DriverProfileRepository>(
        () => DriverProfileRepositoryImpl(locate()),
      )
      ..registerLazySingleton<VerifyEmailRepository>(
        () => VerifyEmailRepositoryImpl(locate()),
      )
      ..registerLazySingleton<PassengerServiceRepository>(
        () => PassengerServiceRepositoryImpl(locate()),
      )
      ..registerLazySingleton<PassengerCategoryRepository>(
        () => PassengerCategoryRepositoryImpl(locate()),
      )
      ..registerLazySingleton<PassengerRepository>(
        () => PassengerRepositoryImpl(locate(), locate()),
      )
      ..registerLazySingleton<RideRepository>(
        () => RideRepositoryImpl(locate()),
      )
      ..registerLazySingleton<NotificationsRepository>(
        () => NotificationsRepositoryImpl(locate()),
      )
      ..registerLazySingleton<DriverEarningsRepository>(
        () => DriverEarningsRepositoryImpl(locate()),
      )
      ..registerLazySingleton<ResetPasswordRepository>(
        () => ResetPasswordRepositoryImpl(locate(), locate()),
      )
      ..registerLazySingleton<ChatMessageRepository>(
        () => ChatMessageRepositoryImpl(locate()),
      )
      ..registerLazySingleton<SendMessageRepository>(
        () => SendMessageRepositoryImpl(locate()),
      )
      ..registerLazySingleton<TermsAndConditionsRepository>(
        () => TermsAndConditionsRepositoryImpl(locate()),
      )
      ..registerLazySingleton<ReviewRepository>(
        () => ReviewRepositoryImpl(locate()),
      );
  }
}
