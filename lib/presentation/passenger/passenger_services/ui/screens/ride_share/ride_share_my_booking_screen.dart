import 'package:cabwire/core/config/app_assets.dart';
import 'package:cabwire/core/config/app_screen.dart';
import 'package:cabwire/core/static/ui_const.dart';
import 'package:cabwire/data/models/ride_data_model.dart';

import 'package:cabwire/presentation/common/components/circular_icon_button.dart';
import 'package:cabwire/presentation/common/components/custom_app_bar.dart';
import 'package:cabwire/presentation/common/components/custom_text.dart';
import 'package:cabwire/presentation/driver/chat/ui/screens/audio_call_page.dart';
import 'package:cabwire/presentation/common/components/common_image.dart';
import 'package:cabwire/presentation/passenger/passenger_history/ui/screens/passenger_details_page.dart';
import 'package:cabwire/presentation/driver/ride_history/ui/widgets/driver_profile_widget.dart';
import 'package:cabwire/presentation/driver/ride_history/ui/widgets/route_information_widget.dart';
import 'package:cabwire/presentation/passenger/car_booking/ui/screens/ride_share_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RideShareMyBookingScreen extends StatefulWidget {
  const RideShareMyBookingScreen({super.key});

  @override
  State<RideShareMyBookingScreen> createState() =>
      _RideShareMyBookingScreenState();
}

class _RideShareMyBookingScreenState extends State<RideShareMyBookingScreen> {
  // Extract static data to avoid recreation on every build
  static const RideData rideData = RideData(
    driverName: 'Santiago Dslab',
    vehicleNumber: 'DHK METRO HA 64-8549',
    vehicleModel: 'Volvo XC90',
    pickupLocation: 'Block B, Banasree, Dhaka.',
    dropoffLocation: 'Green Road, Dhanmondi, Dhaka.',
    dropoffLocation2: 'Green Road, Dhanmondi, Dhaka.',
    totalAmount: '\$100',
  );

  // Constants for better maintainability
  //static const double _sectionSpacing = 24.0;

  @override
  void initState() {
    super.initState();
    _forwardToRideStartPage();
  }

  Future<void> _forwardToRideStartPage() async {
    await Future.delayed(const Duration(seconds: 5));
    Get.to(() => const RideShareScreen());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'My Booking',
        showBackButton: true,
        elevation: 0,
      ),
      body: Container(
        padding: EdgeInsets.all(px16),
        margin: EdgeInsets.all(px16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(px16),
          border: Border.all(color: Colors.grey.shade200),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade200,
              blurRadius: 10,
              offset: Offset(0, px4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDriverSection(rideData),
            gapH10,
            _buildVehicleSection(rideData),
            gapH10,
            _buildTripSection(rideData),
            gapH10,
            _buildSeatBookingSection(context),
            gapH10,
          ],
        ),
      ),
    );
  }

  // Extracted widgets for better organization and reusability
  Widget _buildDriverSection(dynamic rideData) {
    return DriverProfileWidget(
      name: rideData?.driverName ?? '',
      textStyle: TextStyle(
        fontSize: px16,
        color: Colors.black,
        fontWeight: FontWeight.w400,
      ),
    );
  }

  Widget _buildVehicleSection(dynamic rideData) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                rideData?.vehicleNumber ?? '',
                style: TextStyle(
                  fontSize: px14,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
              gapH4,
              Text(
                rideData?.vehicleModel ?? '',
                style: TextStyle(fontSize: px14, color: Colors.black87),
              ),
            ],
          ),
        ),
        CommonImage(
          imageSrc: AppAssets.icCarImage,
          imageType: ImageType.png,
          height: px40,
          width: px100,
        ),
      ],
    );
  }

  Widget _buildTripSection(dynamic rideData) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'My Trip',
          style: TextStyle(fontSize: px16, fontWeight: FontWeight.bold),
        ),
        gapH10,
        RouteInformationWidget(
          pickupLocation: rideData?.pickupLocation ?? '',
          dropoffLocation: rideData?.dropoffLocation ?? '',
          dropoffLocation2: rideData?.dropoffLocation ?? '',
        ),
      ],
    );
  }

  Widget _buildSeatBookingSection(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText('Seat Booking'),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            CustomText('2/3'),
            gapH10,
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PassengerRideDetailsScreen(),
                  ),
                );
              },
              child: CustomText(
                'View details',
                color: Colors.black,
                fontWeight: FontWeight.w500,
              ),
            ),
            gapH10,
            CircularIconButton(
              icon: Icons.phone,
              onTap: () {
                Get.to(() => const AudioCallScreen());
              },
            ),
          ],
        ),
      ],
    );
  }
}
