import 'dart:async';
import 'package:cabwire/domain/services/notification_service.dart';
import 'package:cabwire/domain/services/socket_service.dart';
import 'package:flutter/material.dart';
import 'package:cabwire/core/di/service_locator.dart';
import 'package:cabwire/domain/usecases/determine_first_run_use_case.dart';
import 'package:cabwire/domain/usecases/register_device_usecase.dart';
import 'package:cabwire/domain/usecases/location/check_location_permission_usecase.dart';
import 'package:cabwire/domain/usecases/location/request_location_permission_usecase.dart';
import 'package:cabwire/presentation/initial_app.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  runZonedGuarded<Future<void>>(() async {
    WidgetsFlutterBinding.ensureInitialized();
    await _initializeApp();
    await _checkLocationPermission();
    runApp(InitialApp(isFirstRun: await _checkFirstRun()));
    // _registerDevice();
  }, (error, stackTrace) => (error, stackTrace, fatal: true));
}

/// Initialize the app
Future<void> _initializeApp() async {
  await loadEnv();
  await ServiceLocator.setUp();
  final socketService = locate<SocketService>();
  socketService.connectToSocket();
  final notificationService = locate<NotificationService>();
  await notificationService.initLocalNotification();
  // Deep link initialization moved to InitialApp onReady
}

Future<void> loadEnv() async {
  await dotenv.load(fileName: ".env");
}

/// Check if the app is first run
Future<bool> _checkFirstRun() {
  return locate<DetermineFirstRunUseCase>().execute();
}

/// Check location permission and request if not granted
Future<void> _checkLocationPermission() async {
  final checkLocationPermissionUsecase =
      locate<CheckLocationPermissionUsecase>();
  final requestLocationPermissionUsecase =
      locate<RequestLocationPermissionUsecase>();

  final hasPermission = await checkLocationPermissionUsecase.execute();
  if (!hasPermission) {
    await requestLocationPermissionUsecase.execute();
  }

  debugPrint(
    'Location permission status: ${hasPermission ? 'Granted' : 'Requested'}',
  );
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
