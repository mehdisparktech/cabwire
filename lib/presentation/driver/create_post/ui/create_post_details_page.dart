import 'package:cabwire/core/config/app_assets.dart';
import 'package:cabwire/core/di/service_locator.dart';
import 'package:cabwire/core/external_libs/presentable_widget_builder.dart';
import 'package:cabwire/core/static/ui_const.dart';

import 'package:cabwire/presentation/common/components/action_button.dart';
import 'package:cabwire/presentation/common/components/circular_icon_button.dart';
import 'package:cabwire/presentation/common/components/custom_app_bar.dart';
import 'package:cabwire/presentation/common/components/custom_text.dart';
import 'package:cabwire/presentation/driver/chat/ui/audio_call_page.dart';
import 'package:cabwire/presentation/driver/create_post/presenter/create_post_presenter.dart';
import 'package:cabwire/presentation/driver/create_post/ui/ride_start_page.dart';
import 'package:cabwire/presentation/common/components/common_image.dart';
import 'package:cabwire/presentation/driver/ride_history/ui/ride_details_page.dart';
import 'package:cabwire/presentation/driver/ride_history/widgets/driver_profile_widget.dart';
import 'package:cabwire/presentation/driver/ride_history/widgets/route_information_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CreatePostDetailsScreen extends StatelessWidget {
  final bool isCreatePost;

  CreatePostDetailsScreen({super.key, this.isCreatePost = false});
  final CreatePostPresenter _presenter = locate<CreatePostPresenter>();

  // Extract static data to avoid recreation on every build
  // static const RideData _rideData = RideData(
  //   driverName: 'Santiago Dslab',
  //   vehicleNumber: 'DHK METRO HA 64-8549',
  //   vehicleModel: 'Volvo XC90',
  //   pickupLocation: 'Block B, Banasree, Dhaka.',
  //   dropoffLocation: 'Green Road, Dhanmondi, Dhaka.',
  //   dropoffLocation2: 'Green Road, Dhanmondi, Dhaka.',
  //   totalAmount: '\$100',
  // );

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
      body: PresentableWidgetBuilder<CreatePostPresenter>(
        presenter: _presenter,
        builder: () {
          final rideData = _presenter.currentUiState.rideData;
          return Container(
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
                _buildDriverSection(rideData),
                const SizedBox(height: _sectionSpacing),
                _buildVehicleSection(rideData),
                const SizedBox(height: _sectionSpacing),
                _buildTripSection(rideData),
                const SizedBox(height: _sectionSpacing),
                _buildSeatBookingSection(context),
                const SizedBox(height: _sectionSpacing),
                _buildBottomSheet(),
                const SizedBox(height: _sectionSpacing),
              ],
            ),
          );
        },
      ),
    );
  }

  // Extracted widgets for better organization and reusability
  Widget _buildDriverSection(dynamic rideData) {
    return DriverProfileWidget(
      name: rideData?.driverName ?? '',
      textStyle: const TextStyle(
        fontSize: 16,
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
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                rideData?.vehicleModel ?? '',
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

  Widget _buildTripSection(dynamic rideData) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'My Trip',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
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
                Get.to(() => const RideDetailsScreen());
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

  Widget _buildBottomSheet() {
    return ActionButton(
      isPrimary: true,
      text: 'Start Ride',
      onPressed: () => Get.to(() => const RideStartPage()),
    );
  }
}
