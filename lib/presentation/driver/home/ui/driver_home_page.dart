import 'package:cabwire/core/config/app_assets.dart';
import 'package:cabwire/presentation/driver/home/widgets/ride_action_button.dart';
import 'package:cabwire/presentation/driver/notification/ui/notification_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class DriverHomePage extends StatefulWidget {
  const DriverHomePage({super.key});

  @override
  State<DriverHomePage> createState() => _DriverHomePageState();
}

class _DriverHomePageState extends State<DriverHomePage> {
  late GoogleMapController mapController;

  final LatLng _center = const LatLng(23.8103, 90.4125);

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Stack(children: [_buildMap(), _buildStackedCards()]),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      leading: Padding(
        padding: const EdgeInsets.all(8.0),
        child: CircleAvatar(
          backgroundImage: AssetImage(AppAssets.icProfileImage),
        ),
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Hello Sabbir',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(width: 5),
              Icon(Icons.circle, size: 8, color: Colors.green),
            ],
          ),
          Text('You\'re Now Online', style: TextStyle(fontSize: 12)),
        ],
      ),
      actions: [
        Switch(value: true, onChanged: (value) {}),
        IconButton(
          icon: Icon(Icons.notifications_active),
          onPressed: () => Get.to(() => NotificationScreen()),
        ),
      ],
    );
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

  Widget _buildStackedCards() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: SizedBox(
          height: 250,
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Positioned(
                bottom: 40,
                child: _rideCard(
                  color: Colors.grey.shade100,
                  name: 'Passenger 1',
                ),
              ),
              Positioned(
                bottom: 20,
                child: _rideCard(
                  color: Colors.grey.shade100,
                  name: 'Passenger 2',
                ),
              ),
              _rideCard(color: Colors.white, name: 'Passenger 3'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _rideCard({required Color color, required String name}) {
    return Container(
      width: 320,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black26, blurRadius: 6, offset: Offset(0, 4)),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundImage: AssetImage(AppAssets.icProfileImage),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          name,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text('3.3 km'),
                      ],
                    ),
                    Row(
                      children: [
                        Row(
                          children: List.generate(
                            5,
                            (index) =>
                                Icon(Icons.star, size: 14, color: Colors.amber),
                          ),
                        ),
                        Text(' 5 (5)', style: TextStyle(fontSize: 12)),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Divider(color: Colors.grey.shade300),
          Text('PICK UP', style: TextStyle(fontSize: 12, color: Colors.grey)),
          Text(
            'Block B, Banasree, Dhaka.',
            style: TextStyle(fontWeight: FontWeight.w500),
          ),
          SizedBox(height: 8),
          Divider(color: Colors.grey.shade300),
          Row(
            children: [
              RideActionButton(
                text: 'Decline',
                onPressed: () {
                  // decline action
                },
              ),
              const SizedBox(width: 12),
              RideActionButton(
                text: 'Accept',
                isPrimary: true,
                onPressed: () {
                  // accept action
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
