import 'package:cabwire/presentation/common/screens/splash/presenter/welcome_presenter.dart';
import 'package:get_it/get_it.dart';
import 'package:cabwire/core/base/base_presenter.dart';
import 'package:cabwire/core/di/service_locator.dart';
import 'package:cabwire/core/di/setup/setup_module.dart';
import 'package:cabwire/presentation/passenger/home/presenter/presenter_home_presenter.dart';
import 'package:cabwire/presentation/passenger/main/presenter/main_presenter.dart';
import 'package:cabwire/presentation/passenger/onboarding/presenter/passenger_onboarding_presenter.dart';
import 'package:cabwire/presentation/driver/onboarding/presenter/driver_onboarding_presenter.dart';

class PresenterSetup implements SetupModule {
  final GetIt _serviceLocator;
  PresenterSetup(this._serviceLocator);

  @override
  Future<void> setup() async {
    _serviceLocator
      ..registerFactory(() => loadPresenter(MainPresenter(locate())))
      ..registerLazySingleton(() => loadPresenter(HomePresenter()))
      ..registerLazySingleton(
        () => loadPresenter(PassengerOnboardingPresenter()),
      )
      ..registerLazySingleton(() => loadPresenter(DriverOnboardingPresenter()))
      ..registerLazySingleton(() => loadPresenter(WelcomePresenter()));
  }
}
