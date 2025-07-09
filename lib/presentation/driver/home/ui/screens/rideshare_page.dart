import 'package:cabwire/core/base/base_presenter.dart';
import 'package:cabwire/data/models/ride/ride_request_model.dart';
import 'package:cabwire/presentation/driver/home/presenter/rideshare_presenter.dart';
import 'package:cabwire/presentation/driver/home/ui/widgets/rideshare_bottom_sheet.dart';
import 'package:cabwire/presentation/driver/home/ui/widgets/top_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class RidesharePage extends StatelessWidget {
  final RideRequestModel rideRequest;
  final RidesharePresenter presenter;

  RidesharePage({super.key, required this.rideRequest})
    : presenter = loadPresenter(RidesharePresenter(rideRequest));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Obx(() {
          final uiState = presenter.currentUiState;

          return Stack(
            children: [
              // Map
              GoogleMap(
                onMapCreated: presenter.onMapCreated,
                initialCameraPosition: CameraPosition(
                  target: uiState.mapCenter,
                  zoom: 14.0,
                ),
                myLocationEnabled: true,
                myLocationButtonEnabled: false,
                zoomControlsEnabled: false,
                mapToolbarEnabled: false,
              ),

              // Top navigation bar
              TopNavigationBar(
                title: 'Rideshare',
                subtitle: 'Rideshare',
                distance:
                    '${uiState.rideRequest.distance.toStringAsFixed(1)} km',
                address:
                    uiState.isRideStart
                        ? uiState.rideRequest.dropoffAddress
                        : uiState.rideRequest.pickupAddress,
                onBackPressed: () => Get.back(),
              ),

              // Bottom sheet
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: RideshareBottomSheet(presenter: presenter),
              ),
            ],
          );
        }),
      ),
    );
  }
}
