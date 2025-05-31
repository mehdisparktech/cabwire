import 'package:cabwire/core/config/app_screen.dart';
import 'package:cabwire/core/static/ui_const.dart';
import 'package:cabwire/core/utility/utility.dart';
import 'package:cabwire/presentation/common/components/custom_text.dart';
import 'package:cabwire/presentation/driver/create_post/ui/screens/ride_overview_page.dart';
import 'package:cabwire/presentation/common/components/action_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class SetRideInformationScreen extends StatefulWidget {
  const SetRideInformationScreen({super.key});

  @override
  State<SetRideInformationScreen> createState() =>
      _SetRideInformationScreenState();
}

class _SetRideInformationScreenState extends State<SetRideInformationScreen> {
  final TextEditingController _destinationController = TextEditingController();
  final TextEditingController _seatController = TextEditingController();
  final TextEditingController _lastBookingTimeController =
      TextEditingController();
  late GoogleMapController mapController;

  final LatLng _center = const LatLng(23.8103, 90.4125);

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  void initState() {
    super.initState();
    _destinationController.text = '\$1';
    _seatController.text = '2';
    _lastBookingTimeController.text = '10:00 AM';
  }

  @override
  void dispose() {
    _destinationController.dispose();
    _seatController.dispose();
    _lastBookingTimeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.colorScheme.surface,
      body: Stack(children: [_buildMap(), _buildDestinationContainer()]),
      bottomSheet: Padding(
        padding: const EdgeInsets.only(bottom: 16.0),
        child: ActionButton(
          borderRadius: 0,
          isPrimary: true,
          text: 'Continue',
          onPressed: () {
            Get.to(() => RideOverviewScreen(isCreatePost: true));
          },
        ),
      ),
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
      // Map interaction disable করা হয়েছে
      scrollGesturesEnabled: false,
      zoomGesturesEnabled: false,
      tiltGesturesEnabled: false,
      rotateGesturesEnabled: false,
    );
  }

  Widget _buildDestinationContainer() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: SizedBox(
        height: context.height * 0.6,
        child: Stack(
          children: [
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(16.px),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(px32),
                  topRight: Radius.circular(px32),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),

                  _buildSearchField(
                    controller: _destinationController,
                    hintText: '\$1',
                    title: 'Per Km',
                  ),
                  gapH20,
                  _buildSearchField(
                    controller: _seatController,
                    hintText: '2',
                    title: 'Seat Available',
                  ),
                  gapH20,
                  _buildSearchField(
                    controller: _lastBookingTimeController,
                    hintText: '10:00 AM',
                    title: 'Last Booking Time',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.all(16.px),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              padding: EdgeInsets.all(8.px),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8.px),
              ),
              child: Icon(
                Icons.arrow_back_ios,
                size: 20.px,
                color: context.color.blackColor950,
              ),
            ),
          ),
          gapW30,
          Text(
            'Set Ride Information',
            style: TextStyle(
              fontSize: 20.px,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchField({
    required TextEditingController controller,
    required String hintText,
    required String title,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(title, style: context.textTheme.titleMedium),
        gapH10,
        TextField(
          controller: controller,
          style: TextStyle(fontSize: 16.px, color: Colors.black87),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(color: Colors.grey[600], fontSize: 16.px),

            contentPadding: EdgeInsets.symmetric(
              horizontal: 16.px,
              vertical: 16.px,
            ),
          ),
        ),
      ],
    );
  }
}

// Data model for search history items
class SearchHistoryItem {
  final String location;
  final String distance;

  SearchHistoryItem({required this.location, required this.distance});
}
