import 'package:cabwire/core/di/service_locator.dart';
import 'package:cabwire/core/external_libs/presentable_widget_builder.dart';
import 'package:cabwire/data/models/ride/ride_request_model.dart';
import 'package:cabwire/presentation/driver/home/presenter/rideshare_presenter.dart';
import 'package:cabwire/presentation/driver/home/ui/widgets/rideshare_bottom_sheet.dart';
import 'package:cabwire/presentation/driver/home/ui/widgets/top_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:get/get.dart';

class RidesharePage extends StatelessWidget {
  final RideRequestModel rideRequest;

  const RidesharePage({super.key, required this.rideRequest});

  @override
  Widget build(BuildContext context) {
    final presenter = locate<RidesharePresenter>();
    return Scaffold(
      body: SafeArea(
        child: PresentableWidgetBuilder(
          presenter: presenter,
          builder: () {
            presenter.setRideRequest(rideRequest);
            final uiState = presenter.currentUiState;
            return Stack(
              children: [
                // Map with enhanced features
                _buildMap(presenter, uiState),

                // Top navigation bar
                TopNavigationBar(
                  title: 'Rideshare',
                  subtitle: 'Rideshare',
                  distance:
                      '${uiState.rideRequest!.distance.toStringAsFixed(1)} km',
                  address:
                      uiState.isRideStart
                          ? uiState.rideRequest!.dropoffAddress
                          : uiState.rideRequest!.pickupAddress,
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
          },
        ),
      ),
    );
  }

  Widget _buildMap(RidesharePresenter presenter, uiState) {
    return Obx(() {
      final currentUiState = presenter.currentUiState;

      return GoogleMap(
        onMapCreated: presenter.onMapCreated,
        initialCameraPosition: CameraPosition(
          target: uiState.mapCenter ?? const LatLng(23.8103, 90.4125),
          zoom: 14.0,
        ),
        myLocationEnabled: true,
        myLocationButtonEnabled: false,
        zoomControlsEnabled: false,
        mapToolbarEnabled: false,
        scrollGesturesEnabled: true,
        zoomGesturesEnabled: true,
        tiltGesturesEnabled: true,
        rotateGesturesEnabled: true,
        markers: currentUiState.markers,
        polylines: {
          if (currentUiState.polylineCoordinates != null)
            Polyline(
              polylineId: const PolylineId('route'),
              points: currentUiState.polylineCoordinates!,
              color: Colors.blue,
              width: 5,
              patterns: [PatternItem.dash(20), PatternItem.gap(5)],
              endCap: Cap.roundCap,
              startCap: Cap.roundCap,
            ),
        },
      );
    });
  }
}
