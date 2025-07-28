import 'package:cabwire/data/datasources/remote/driver/create_cabwire_remote_data_source.dart';
import 'package:cabwire/data/datasources/remote/driver/driver_earnings_remote_data_source.dart';
import 'package:cabwire/data/datasources/remote/notification_remote_data_source.dart';
import 'package:cabwire/data/datasources/remote/passenger/passenger_auth_remote_data_source.dart';
import 'package:cabwire/data/datasources/remote/passenger/reset_password_remote_data_source.dart';
import 'package:cabwire/data/datasources/remote/passenger/review_remote_data_source.dart';
import 'package:cabwire/data/datasources/remote/terms_and_conditions_data_source.dart';
import 'package:cabwire/data/mappers/ride_history_mapper.dart';
import 'package:get_it/get_it.dart';
import 'package:cabwire/core/di/service_locator.dart';
import 'package:cabwire/core/di/setup/setup_module.dart';
import 'package:cabwire/data/datasources/local/user_data_local_data_source.dart';
import 'package:cabwire/data/datasources/remote/chat_message_remote_data_source.dart';
import 'package:cabwire/data/datasources/remote/driver/device_info_remote_data_source.dart';
import 'package:cabwire/data/datasources/remote/driver/driver_all_remote_data_source.dart';
import 'package:cabwire/data/datasources/remote/info_remote_data_source.dart';
import 'package:cabwire/data/datasources/local/location_local_data_source.dart';
import 'package:cabwire/data/datasources/remote/driver/driver_auth_remote_data_source.dart';
import 'package:cabwire/data/datasources/remote/driver/driver_profile_remote_data_source.dart';
import 'package:cabwire/data/datasources/remote/passenger/passenger_remote_data_source.dart';
import 'package:cabwire/data/datasources/remote/ride_remote_data_source.dart';
import 'package:cabwire/data/datasources/remote/verify_email_remote_data_source.dart';
import 'package:cabwire/data/datasources/remote/passenger/passenger_service_remote_data_source.dart';
import 'package:cabwire/data/datasources/remote/passenger/passenger_category_remote_data_source.dart';
import 'package:cabwire/data/datasources/remote/send_message_remote_data_source.dart';
import 'package:cabwire/data/datasources/remote/ride_history_remote_data_source.dart';

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
      ..registerLazySingleton<PassengerAuthRemoteDataSource>(
        () => PassengerAuthRemoteDataSourceImpl(),
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
      )
      ..registerLazySingleton<RideRemoteDataSource>(
        () => RideRemoteDataSourceImpl(locate()),
      )
      ..registerLazySingleton<NotificationRemoteDataSource>(
        () => NotificationRemoteDataSourceImpl(locate()),
      )
      ..registerLazySingleton<DriverEarningsRemoteDataSource>(
        () => DriverEarningsRemoteDataSourceImpl(),
      )
      ..registerLazySingleton<ResetPasswordRemoteDataSource>(
        () => ResetPasswordRemoteDataSourceImpl(locate()),
      )
      ..registerLazySingleton<TermsAndConditionsRemoteDataSource>(
        () => TermsAndConditionsRemoteDataSourceImpl(),
      )
      ..registerLazySingleton<ReviewRemoteDataSource>(
        () => ReviewRemoteDataSourceImpl(locate()),
      )
      ..registerLazySingleton<ChatMessageRemoteDataSource>(
        () => ChatMessageRemoteDataSourceImpl(locate()),
      )
      ..registerLazySingleton<SendMessageRemoteDataSource>(
        () => SendMessageRemoteDataSourceImpl(locate()),
      )
      ..registerLazySingleton<RideHistoryRemoteDataSource>(
        () => RideHistoryRemoteDataSourceImpl(locate()),
      )
      ..registerLazySingleton(() => RideHistoryMapper())
      ..registerLazySingleton<CreateCabwireRemoteDataSource>(
        () => CreateCabwireRemoteDataSourceImpl(),
      );
  }
}
