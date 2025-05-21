import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cabwire/core/di/service_locator.dart';
import 'package:cabwire/domain/user/usecases/determine_first_run_use_case.dart';
import 'package:cabwire/domain/user/usecases/register_device_usecase.dart';
import 'package:cabwire/presentation/initial_app.dart';

Future<void> main() async {
  runZonedGuarded<Future<void>>(() async {
    WidgetsFlutterBinding.ensureInitialized();
    await _initializeApp();
    runApp(InitialApp(isFirstRun: await _checkFirstRun()));
    // _registerDevice();
  }, (error, stackTrace) => (error, stackTrace, fatal: true));
}

/// Initialize the app
Future<void> _initializeApp() async {
  //await loadEnv();
  await ServiceLocator.setUp();
}

/// Check if the app is first run
Future<bool> _checkFirstRun() {
  return locate<DetermineFirstRunUseCase>().execute();
}

/// Register the device
// ignore: unused_element
Future<void> _registerDevice() async {
  final registerDeviceUsecase = locate<RegisterDeviceUsecase>();

  final result = await registerDeviceUsecase.execute();

  result.fold(
    (error) => debugPrint('Failed to register device: $error'),
    (_) => debugPrint('Device registered successfully'),
  );
}
