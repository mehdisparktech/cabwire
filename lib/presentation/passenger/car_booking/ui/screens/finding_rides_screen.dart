import 'package:cabwire/core/di/service_locator.dart';
import 'package:cabwire/data/models/ride/ride_response_model.dart';
import 'package:cabwire/presentation/passenger/car_booking/presenter/finding_rides_presenter.dart';
import 'package:cabwire/presentation/passenger/car_booking/ui/widgets/finding_rideshare_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class FindingRidesScreen extends StatelessWidget {
  final RideResponseModel rideResponse;
  const FindingRidesScreen({super.key, required this.rideResponse});
  @override
  Widget build(BuildContext context) {
    final FindingRidesPresenter presenter = locate<FindingRidesPresenter>();
    presenter.initialize(rideResponse.data.id);
    return Scaffold(
      body: Stack(
        children: [
          _buildMap(context),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: _buildBottomSheet(context, presenter),
          ),
        ],
      ),
    );
  }

  Widget _buildMap(BuildContext context) {
    return GoogleMap(
      onMapCreated: (controller) {}, // Use presenter's method
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

  Widget _buildBottomSheet(
    BuildContext context,
    FindingRidesPresenter presenter,
  ) {
    return FindingRideshareBottomSheet(
      rideId: rideResponse.data.id,
      rideResponse: rideResponse,
      presenter: presenter,
    );
  }
}
