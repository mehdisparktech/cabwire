import 'package:cabwire/core/di/service_locator.dart';
import 'package:cabwire/data/models/ride/ride_response_model.dart';
import 'package:cabwire/presentation/passenger/car_booking/presenter/ride_share_presenter.dart';
import 'package:cabwire/presentation/passenger/car_booking/ui/widgets/rideshare_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class RideShareScreen extends StatelessWidget {
  final String rideId;
  final RideResponseModel rideResponse;

  const RideShareScreen({
    super.key,
    required this.rideId,
    required this.rideResponse,
  });

  @override
  Widget build(BuildContext context) {
    final presenter = locate<RideSharePresenter>();
    if (presenter.currentUiState.rideId.isEmpty) {
      presenter.init(
        rideId: rideResponse.data.userId,
        rideResponse: rideResponse,
      );
    }

    return Scaffold(
      body: _buildMap(presenter),
      bottomSheet: _buildBottomSheet(presenter),
    );
  }

  Widget _buildMap(RideSharePresenter presenter) {
    return GoogleMap(
      onMapCreated: presenter.onMapCreated,
      initialCameraPosition: CameraPosition(
        target: LatLng(23.8103, 90.4125),
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
    );
  }

  Widget _buildBottomSheet(RideSharePresenter presenter) {
    return RideshareBottomSheet(presenter: presenter);
  }
}
