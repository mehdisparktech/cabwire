import 'package:cabwire/presentation/driver/home/ui/widgets/rideshare_bottom_sheet.dart';
import 'package:cabwire/presentation/driver/home/ui/widgets/top_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class RidesharePage extends StatefulWidget {
  const RidesharePage({super.key});

  @override
  State<RidesharePage> createState() => _RidesharePageState();
}

class _RidesharePageState extends State<RidesharePage> {
  static const LatLng _center = LatLng(23.8103, 90.4125);
  late GoogleMapController mapController;
  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            // Map
            GoogleMap(
              onMapCreated: _onMapCreated,
              initialCameraPosition: const CameraPosition(
                target: _center,
                zoom: 14.0,
              ),
              myLocationEnabled: true,
              myLocationButtonEnabled: false,
              zoomControlsEnabled: false,
              mapToolbarEnabled: false,
            ),

            // Top navigation bar (using the imported widget)
            const TopNavigationBar(
              title: 'Rideshare',
              subtitle: 'Rideshare',
              distance: '200 m',
              address: 'Turn right at block b, road no 18',
            ),

            // Bottom sheet (using the imported widget)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: RideshareBottomSheet(),
            ),
          ],
        ),
      ),
    );
  }
}
