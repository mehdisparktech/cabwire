import 'package:cabwire/presentation/passenger/car_booking/ui/widgets/finding_rideshare_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class FindingRidesScreen extends StatelessWidget {
  const FindingRidesScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildMap(context),
      bottomSheet: _buildBottomSheet(context),
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

  Widget _buildBottomSheet(BuildContext context) {
    return const FindingRideshareBottomSheet();
  }
}
