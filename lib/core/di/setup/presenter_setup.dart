import 'package:cabwire/presentation/common/screens/splash/presenter/welcome_presenter.dart';
import 'package:cabwire/presentation/driver/auth/presenter/driver_login_presenter.dart';
import 'package:cabwire/presentation/driver/auth/presenter/driver_sign_up_presenter.dart';
import 'package:cabwire/presentation/driver/auth/presenter/driver_forgot_password_presenter.dart';
import 'package:cabwire/presentation/driver/chat/presenter/chat_presenter.dart';
import 'package:cabwire/presentation/driver/create_post/presenter/create_post_presenter.dart';
import 'package:cabwire/presentation/driver/earnings/presenter/earning_presenter.dart';
import 'package:cabwire/presentation/driver/home/presenter/driver_home_presenter.dart';
import 'package:cabwire/presentation/driver/notification/presenter/notification_presenter.dart';
import 'package:cabwire/presentation/driver/profile/presenter/driver_profile_presenter.dart';
import 'package:cabwire/presentation/driver/ride_history/presenter/ride_history_presenter.dart';
import 'package:cabwire/presentation/passenger/auth/presenter/passenger_login_presenter.dart';
import 'package:cabwire/presentation/passenger/passenger_history/presenter/passenger_history_presenter.dart';
import 'package:cabwire/presentation/passenger/passenger_notification/presenter/passenger_notification_presenter.dart';
import 'package:cabwire/presentation/passenger/passenger_profile/presenter/passenger_profile_presenter.dart';
import 'package:cabwire/presentation/passenger/passenger_services/presenter/passenger_services_presenter.dart';
import 'package:get_it/get_it.dart';
import 'package:cabwire/core/base/base_presenter.dart';
import 'package:cabwire/core/di/service_locator.dart';
import 'package:cabwire/core/di/setup/setup_module.dart';
import 'package:cabwire/presentation/passenger/home/presenter/presenter_home_presenter.dart';
import 'package:cabwire/presentation/passenger/main/presenter/passenger_main_presenter.dart';
import 'package:cabwire/presentation/driver/main/presenter/driver_main_presenter.dart';
import 'package:cabwire/presentation/passenger/onboarding/presenter/passenger_onboarding_presenter.dart';
import 'package:cabwire/presentation/driver/onboarding/presenter/driver_onboarding_presenter.dart';
import 'package:cabwire/presentation/passenger/auth/presenter/passenger_signup_presenter.dart';

class PresenterSetup implements SetupModule {
  final GetIt _serviceLocator;
  PresenterSetup(this._serviceLocator);

  void _setupPassengerPresenters() {
    _serviceLocator.registerFactory(
      () => PassengerSignupPresenter(_serviceLocator()),
    );
  }

  @override
  Future<void> setup() async {
    _serviceLocator
      //>>>>>>>>>>>>>>>>>>>>>>>>>> Driver Presenters  <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
      ..registerFactory(() => loadPresenter(DriverMainPresenter(locate())))
      ..registerLazySingleton(
        () => loadPresenter(DriverHomePresenter(locate(), locate())),
      )
      ..registerLazySingleton(() => loadPresenter(DriverOnboardingPresenter()))
      ..registerLazySingleton(() => loadPresenter(WelcomePresenter(locate())))
      ..registerLazySingleton(
        () => loadPresenter(DriverProfilePresenter(locate())),
      )
      ..registerLazySingleton(
        () => loadPresenter(
          DriverSignUpPresenter(locate(), locate(), locate(), locate()),
        ),
      )
      ..registerLazySingleton(
        () => loadPresenter(DriverLoginPresenter(locate())),
      )
      ..registerLazySingleton(
        () => loadPresenter(
          DriverForgotPasswordPresenter(locate(), locate(), locate(), locate()),
        ),
      )
      ..registerLazySingleton(() => loadPresenter(NotificationPresenter()))
      ..registerLazySingleton(() => loadPresenter(CreatePostPresenter()))
      ..registerLazySingleton(() => loadPresenter(EarningsPresenter()))
      ..registerLazySingleton(() => loadPresenter(ChatPresenter()))
      ..registerLazySingleton(() => loadPresenter(RideHistoryPresenter()))
      //>>>>>>>>>>>>>>>>>>>>>>>>>> Passenger Presenters  <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
      ..registerLazySingleton(() => loadPresenter(PassengerHistoryPresenter()))
      ..registerLazySingleton(() => loadPresenter(PassengerServicesPresenter()))
      ..registerLazySingleton(() => loadPresenter(PassengerProfilePresenter()))
      ..registerLazySingleton(
        () => loadPresenter(PassengerOnboardingPresenter()),
      )
      ..registerLazySingleton(
        () => loadPresenter(PassengerMainPresenter(locate())),
      )
      ..registerLazySingleton(() => loadPresenter(PassengerHomePresenter()))
      ..registerLazySingleton(
        () => loadPresenter(PassengerNotificationPresenter()),
      )
      ..registerLazySingleton(
        () => loadPresenter(PassengerLoginPresenter(locate())),
      );
    _setupPassengerPresenters();
  }
}
