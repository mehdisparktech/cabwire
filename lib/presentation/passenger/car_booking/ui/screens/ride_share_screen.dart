import 'package:cabwire/core/di/service_locator.dart';
import 'package:cabwire/data/models/ride/ride_response_model.dart';
import 'package:cabwire/presentation/passenger/car_booking/presenter/ride_share_presenter.dart';
import 'package:cabwire/presentation/passenger/car_booking/ui/widgets/rideshare_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:get/get.dart';

class RideShareScreen extends StatelessWidget {
  final String rideId;
  final RideResponseModel rideResponse;
  final String chatId;
  final bool isRideProcessing;

  const RideShareScreen({
    super.key,
    required this.rideId,
    required this.rideResponse,
    required this.chatId,
    required this.isRideProcessing,
  });

  @override
  Widget build(BuildContext context) {
    final RideSharePresenter presenter = locate<RideSharePresenter>();
    // Always initialize the presenter with the current values
    presenter.init(
      rideId: rideResponse.data.userId,
      rideResponse: rideResponse,
      chatId: chatId,
      isRideProcessing: isRideProcessing,
    );

    return Scaffold(
      body: Stack(
        children: [_buildMap(presenter), _buildBottomSheet(presenter)],
      ),
    );
  }

  Widget _buildMap(RideSharePresenter presenter) {
    return Obx(() {
      final uiState = presenter.currentUiState;

      return GoogleMap(
        onMapCreated: presenter.onMapCreated,
        initialCameraPosition: CameraPosition(
          target: LatLng(23.8103, 90.4125),
          zoom: 14.0,
        ),
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
        zoomControlsEnabled: true,
        mapToolbarEnabled: false,
        scrollGesturesEnabled: true,
        zoomGesturesEnabled: true,
        tiltGesturesEnabled: true,
        rotateGesturesEnabled: true,
        markers: uiState.markers,
        polylines: {
          if (uiState.polylineCoordinates != null)
            Polyline(
              polylineId: const PolylineId('route'),
              points: uiState.polylineCoordinates!,
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

  Widget _buildBottomSheet(RideSharePresenter presenter) {
    return DraggableScrollableSheet(
      initialChildSize: 0.3, // Initially opens at 50% of screen height
      minChildSize: 0.3, // Minimum height when collapsed
      maxChildSize: 0.5, // Maximum height when expanded
      builder: (context, scrollController) {
        return SingleChildScrollView(
          controller: scrollController,
          child: RideshareBottomSheet(presenter: presenter, chatId: chatId),
        );
      },
    );
  }
}
