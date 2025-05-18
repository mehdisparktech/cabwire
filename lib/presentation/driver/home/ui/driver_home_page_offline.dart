import 'package:cabwire/core/utility/navigation_utility.dart';
import 'package:cabwire/presentation/driver/home/widgets/ride_action_button.dart';
import 'package:cabwire/presentation/driver/main/ui/driver_main_page.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class DriverHomePageOffline extends StatefulWidget {
  const DriverHomePageOffline({super.key});

  @override
  State<DriverHomePageOffline> createState() => _DriverHomePageOfflineState();
}

class _DriverHomePageOfflineState extends State<DriverHomePageOffline> {
  late GoogleMapController mapController;

  final LatLng _center = const LatLng(23.8103, 90.4125);
  bool isSwitched = false;

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Stack(children: [_buildMap(), _buildOfflineCard()]));
  }

  Widget _buildMap() {
    return GoogleMap(
      onMapCreated: _onMapCreated,
      initialCameraPosition: CameraPosition(target: _center, zoom: 14.0),
      myLocationEnabled: true,
      myLocationButtonEnabled: false,
      zoomControlsEnabled: false,
      mapToolbarEnabled: false,
    );
  }

  Widget _buildOfflineCard() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: SizedBox(
        width: double.infinity,
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Ready to drive?',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Switch to online mode to receive your first ride.',
                    style: TextStyle(fontSize: 14),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: RideActionButton(
                      text: 'Go Online',
                      isPrimary: true,
                      onPressed: () {
                        NavigationUtility.fadeReplacement(
                          context,
                          DriverMainPage(),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: RideActionButton(
                      text: 'Not Now',
                      onPressed: () {
                        NavigationUtility.fadeReplacement(
                          context,
                          DriverMainPage(),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
