import 'package:cabwire/core/config/app_assets.dart';
import 'package:cabwire/core/config/app_screen.dart';
import 'package:cabwire/core/di/service_locator.dart';
import 'package:cabwire/presentation/common/components/circular_icon_button.dart';
import 'package:cabwire/presentation/common/components/custom_services_card.dart';
import 'package:cabwire/presentation/passenger/home/presenter/presenter_home_presenter.dart';
import 'package:cabwire/presentation/passenger/home/ui/screens/passenger_search_destination_page.dart';
import 'package:cabwire/presentation/passenger/home/ui/widgets/ride_booking_widget.dart';
import 'package:cabwire/presentation/passenger/passenger_notification/ui/screens/passenger_notification_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class PassengerHomeScreen extends StatelessWidget {
  PassengerHomeScreen({super.key});
  final PassengerHomePresenter presenter = locate<PassengerHomePresenter>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.px, vertical: 16.px),
            child: RideBookingWidget(),
          ),
          Expanded(
            child: Stack(
              children: [
                Positioned(
                  top: 200.px, // Adjust based on services widget height
                  bottom: 0.px, // 10px from bottom for overlap effect
                  left: 0.px,
                  right: 0.px,
                  child: _buildMap(context),
                ),
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: _buildServicesWidget(context),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      toolbarHeight: 80,
      leading: Padding(
        padding: EdgeInsets.all(4.px),
        child: CircleAvatar(
          backgroundImage: AssetImage(AppAssets.icProfileImage),
        ),
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Hello Sabbir,',
            style: TextStyle(fontSize: 16.px, fontWeight: FontWeight.bold),
          ),
          Text(
            '36 East 8th Street, New York, NY 10003, United States.',
            style: TextStyle(fontSize: 12.px),
            maxLines: 2,
          ),
        ],
      ),
      actions: [
        CircularIconButton(
          hMargin: 20.px,
          imageSrc: AppAssets.icNotifcationActive,
          onTap: () => Get.to(() => PassengerNotificationScreen()),
        ),
      ],
    );
  }

  Widget _buildServicesWidget(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.px),
      child: CustomServicesCard(
        showSeeAllButton: true,
        services: [
          Service(
            title: 'Car',
            imageUrl: AppAssets.icServiceCar,
            fontWeight: FontWeight.w600,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (context) => const PassengerSearchDestinationScreen(),
                ),
              );
            },
          ),
          Service(
            title: 'Emergency Car',
            imageUrl: AppAssets.icServiceCar,
            fontWeight: FontWeight.w400,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (context) => const PassengerSearchDestinationScreen(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMap(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24.px),
          topRight: Radius.circular(24.px),
        ),
        color: Colors.grey.shade200,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24.px),
          topRight: Radius.circular(24.px),
        ),
        child: GoogleMap(
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
        ),
      ),
    );
  }
}
