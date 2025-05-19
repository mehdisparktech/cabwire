import 'package:cabwire/core/config/app_assets.dart';
import 'package:cabwire/core/static/ui_const.dart';
import 'package:cabwire/data/driver/models/ride_data_model.dart';
import 'package:cabwire/presentation/common/components/custom_app_bar.dart';
import 'package:cabwire/presentation/common/components/custom_text.dart';
import 'package:cabwire/presentation/driver/create_post/ui/ride_start_page.dart';
import 'package:cabwire/presentation/driver/home/widgets/ride_action_button.dart';
import 'package:cabwire/presentation/driver/profile/widgets/common_image.dart';
import 'package:cabwire/presentation/driver/ride_history/widgets/driver_profile_widget.dart';
import 'package:cabwire/presentation/driver/ride_history/widgets/route_information_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CreatePostDetailsScreen extends StatelessWidget {
  final bool isCreatePost;

  const CreatePostDetailsScreen({super.key, this.isCreatePost = false});

  // Extract static data to avoid recreation on every build
  static const RideData _rideData = RideData(
    driverName: 'Santiago Dslab',
    vehicleNumber: 'DHK METRO HA 64-8549',
    vehicleModel: 'Volvo XC90',
    pickupLocation: 'Block B, Banasree, Dhaka.',
    dropoffLocation: 'Green Road, Dhanmondi, Dhaka.',
    dropoffLocation2: 'Green Road, Dhanmondi, Dhaka.',
    totalAmount: '\$100',
  );

  // Constants for better maintainability
  static const double _sectionSpacing = 24.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Ride Overview',
        showBackButton: true,
        elevation: 0,
      ),
      body: Container(
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade200),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade200,
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDriverSection(),
            const SizedBox(height: _sectionSpacing),
            _buildVehicleSection(),
            const SizedBox(height: _sectionSpacing),
            _buildTripSection(),
            const SizedBox(height: _sectionSpacing),
            _buildSeatBookingSection(context),
            const SizedBox(height: _sectionSpacing),
            _buildBottomSheet(),
            const SizedBox(height: _sectionSpacing),
          ],
        ),
      ),
    );
  }

  // Extracted widgets for better organization and reusability
  Widget _buildDriverSection() {
    return DriverProfileWidget(
      name: _rideData.driverName,
      textStyle: const TextStyle(
        fontSize: 16,
        color: Colors.black,
        fontWeight: FontWeight.w400,
      ),
    );
  }

  Widget _buildVehicleSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _rideData.vehicleNumber,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                _rideData.vehicleModel,
                style: const TextStyle(fontSize: 14, color: Colors.black87),
              ),
            ],
          ),
        ),
        const CommonImage(
          imageSrc: AppAssets.icCarImage,
          imageType: ImageType.png,
          height: 40,
          width: 100,
        ),
      ],
    );
  }

  Widget _buildTripSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'My Trip',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        RouteInformationWidget(
          pickupLocation: _rideData.pickupLocation,
          dropoffLocation: _rideData.dropoffLocation,
          dropoffLocation2: _rideData.dropoffLocation2,
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
            CustomText(
              'View details',
              color: Colors.black,
              fontWeight: FontWeight.w500,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildBottomSheet() {
    return RideActionButton(
      isPrimary: true,
      text: 'Start Ride',
      onPressed: () => Get.to(() => const RideStartPage()),
    );
  }
}
