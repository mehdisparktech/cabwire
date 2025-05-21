import 'dart:async';
import 'package:cabwire/core/base/base_presenter.dart';
import 'package:cabwire/presentation/driver/home/presenter/driver_home_ui_state.dart';
import 'package:cabwire/presentation/driver/home/ui/rideshare_page.dart';
import 'package:cabwire/presentation/driver/notification/ui/notification_page.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class DriverHomePresenter extends BasePresenter<DriverHomeUiState> {
  final Obs<DriverHomeUiState> uiState = Obs<DriverHomeUiState>(
    DriverHomeUiState.initial(),
  );
  DriverHomeUiState get currentUiState => uiState.value;

  GoogleMapController? _mapController;

  DriverHomePresenter() {
    _initializeFromArguments();
  }

  void _initializeFromArguments() {
    dynamic arguments = Get.arguments;
    bool initialOnlineStatus = false;
    if (arguments is Map && arguments.containsKey('isOnline')) {
      initialOnlineStatus = arguments['isOnline'] as bool? ?? false;
    }
    uiState.value = currentUiState.copyWith(isOnline: initialOnlineStatus);
  }

  @override
  Future<void> addUserMessage(String message) async {
    uiState.value = currentUiState.copyWith(userMessage: message);
  }

  @override
  Future<void> toggleLoading({required bool loading}) async {
    uiState.value = currentUiState.copyWith(isLoading: loading);
  }

  void onMapCreated(GoogleMapController controller) {
    _mapController = controller;

    // _mapController?.animateCamera(...);
  }

  void toggleOnlineStatus(bool value) {
    uiState.value = currentUiState.copyWith(isOnline: value);
    if (value) {
      print("Driver is now Online (Presenter)");
    } else {
      print("Driver is now Offline (Presenter)");
    }
  }

  void goOnline() {
    uiState.value = currentUiState.copyWith(isOnline: true);
    print("Driver manually set to Online (Presenter)");
  }

  void goToNotifications() {
    Get.to(() => NotificationScreen());
  }

  void acceptRide(String rideId) {
    print("Ride accepted: $rideId (Presenter)");
    Get.to(() => RidesharePage());
  }

  void declineRide(String rideId) {
    print("Ride declined: $rideId (Presenter)");
  }

  void handleNotNow() {
    print("Not Now pressed while offline (Presenter)");
  }

  @override
  void dispose() {
    super.dispose();
    _mapController?.dispose();
  }
}
