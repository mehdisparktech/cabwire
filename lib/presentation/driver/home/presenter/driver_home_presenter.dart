import 'dart:async';
import 'package:cabwire/core/base/base_presenter.dart';
import 'package:cabwire/core/utility/navigation_utility.dart';
import 'package:cabwire/presentation/driver/home/presenter/driver_home_ui_state.dart';
import 'package:cabwire/presentation/driver/home/ui/screens/rideshare_page.dart';
import 'package:cabwire/presentation/driver/main/ui/screens/driver_main_page.dart';
import 'package:cabwire/presentation/driver/notification/ui/screens/notification_page.dart';
import 'package:flutter/material.dart';
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
    final dynamic arguments = Get.arguments;
    final bool initialOnlineStatus =
        arguments is Map && arguments.containsKey('isOnline')
            ? arguments['isOnline'] as bool? ?? false
            : false;

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
  }

  void toggleOnlineStatus(bool value) {
    uiState.value = currentUiState.copyWith(isOnline: value);
  }

  void goOnline() {
    uiState.value = currentUiState.copyWith(isOnline: true);
  }

  void goToNotifications() {
    Get.to(() => NotificationScreen());
  }

  void acceptRide(String rideId) {
    Get.to(() => RidesharePage());
  }

  void declineRide(String rideId) {
    // Implementation for declining ride
  }

  void handleNotNowPassenger(BuildContext context) {
    NavigationUtility.fadeReplacement(context, DriverMainPage());
  }

  void handleNotNow(BuildContext context) {
    uiState.value = currentUiState.copyWith(isOnline: false);
    NavigationUtility.fadeReplacement(context, DriverMainPage());
  }

  void setOnlineAndNavigate(BuildContext context) {
    uiState.value = currentUiState.copyWith(isOnline: true);
    NavigationUtility.fadeReplacement(context, DriverMainPage());
  }

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }
}
