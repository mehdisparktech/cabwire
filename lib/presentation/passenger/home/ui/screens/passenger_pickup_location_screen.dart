import 'package:cabwire/core/config/app_assets.dart';
import 'package:cabwire/core/config/app_screen.dart';
import 'package:cabwire/core/utility/utility.dart';
import 'package:cabwire/presentation/common/components/action_button.dart';
import 'package:cabwire/presentation/common/components/common_image.dart';
import 'package:cabwire/presentation/passenger/home/ui/screens/passenger_search_destination_page.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class PassengerPickupLocationScreen extends StatelessWidget {
  const PassengerPickupLocationScreen({super.key});

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
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.px, vertical: 16.px),
      color: Colors.white,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFormField(
            decoration: InputDecoration(
              hintText: 'Block B, Banasree, Dhaka.',
              border: OutlineInputBorder(),
              prefixIcon: Padding(
                padding: EdgeInsets.all(10.px),
                child: CommonImage(
                  imageSrc: AppAssets.icLocation,
                  imageType: ImageType.svg,
                  imageColor: context.color.primaryButtonGradient,
                  width: 12.px,
                  height: 12.px,
                ),
              ),
            ),
          ),
          SizedBox(height: 16.px),
          ActionButton(
            isPrimary: true,
            text: 'Set Location',
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => SearchDestinationScreen(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
