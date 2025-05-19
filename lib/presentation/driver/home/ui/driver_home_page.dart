import 'package:cabwire/core/config/app_assets.dart';
import 'package:cabwire/core/static/ui_const.dart';
import 'package:cabwire/core/utility/utility.dart';
import 'package:cabwire/presentation/driver/home/ui/rideshare_page.dart';
import 'package:cabwire/presentation/driver/home/widgets/ride_action_button.dart';
import 'package:cabwire/presentation/driver/notification/ui/notification_page.dart';
import 'package:cabwire/presentation/driver/profile/widgets/common_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class DriverHomePage extends StatefulWidget {
  final bool? isOnline;
  const DriverHomePage({super.key, this.isOnline});

  @override
  State<DriverHomePage> createState() => _DriverHomePageState();
}

class _DriverHomePageState extends State<DriverHomePage> {
  late GoogleMapController mapController;

  final LatLng _center = const LatLng(23.8103, 90.4125);
  bool isSwitched = true;
  late bool isRiderOnline;

  @override
  void initState() {
    super.initState();
    isRiderOnline = widget.isOnline ?? false;
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  void _goOnline() {
    setState(() {
      isRiderOnline = true;
    });
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
      toolbarHeight: 80,
      leading: Padding(
        padding: const EdgeInsets.all(4.0),
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
              Icon(Icons.circle, size: 10, color: Colors.green),
            ],
          ),
          Text('You\'re Now Online', style: TextStyle(fontSize: 12)),
        ],
      ),
      actions: [
        Transform.scale(
          scale: 0.75, // adjust between 0.5 - 1.0 for desired size
          child: Switch(
            padding: EdgeInsets.zero,
            value: isSwitched,
            onChanged: (value) {
              setState(() {
                isSwitched = value;
                isRiderOnline = value;
              });
            },
          ),
        ),

        SizedBox(width: 10),

        GestureDetector(
          onTap: () => Get.to(() => NotificationScreen()),
          child: Padding(
            padding: const EdgeInsets.only(right: 20),
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacityInt(0.2),
                    spreadRadius: 2,
                    blurRadius: 5,
                  ),
                ],
              ),
              child: Center(
                child: CommonImage(
                  imageType: ImageType.svg,
                  imageSrc: AppAssets.icNotifcationActive,
                ),
              ),
            ),
          ),
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
              if (isRiderOnline) ...[
                Positioned(
                  bottom: 40,
                  child: _rideCard(color: Colors.white, name: 'Passenger 1'),
                ),
                Positioned(
                  bottom: 20,
                  child: _rideCard(color: Colors.white, name: 'Passenger 2'),
                ),
                Positioned(
                  bottom: 0,
                  child: _rideCard(color: Colors.white, name: 'Passenger 3'),
                ),
              ],
              if (!isRiderOnline) ...[_rideOfflineCard()],
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
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black26, blurRadius: 6, offset: Offset(0, 4)),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          gapH10,
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
              Expanded(
                child: RideActionButton(
                  text: 'Decline',
                  onPressed: () {
                    // decline action
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: RideActionButton(
                  text: 'Accept',
                  isPrimary: true,
                  onPressed: () {
                    // accept action
                    Get.to(() => RidesharePage());
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _rideOfflineCard() {
    return Container(
      width: 400,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: context.theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black26, blurRadius: 6, offset: Offset(0, 4)),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Ready to drive?',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
          ),
          Text(
            'Your status is offline. Please go online to get your next ride.',
            style: TextStyle(fontWeight: FontWeight.w500),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 12),
          RideActionButton(
            text: 'Go Online',
            isPrimary: true,
            onPressed: () {
              _goOnline();
            },
          ),
          SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: RideActionButton(
              text: 'Not Now',
              onPressed: () {
                // accept action
              },
            ),
          ),
        ],
      ),
    );
  }
}
