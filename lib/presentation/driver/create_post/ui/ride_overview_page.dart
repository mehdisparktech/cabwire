import 'package:cabwire/core/config/app_assets.dart';
import 'package:cabwire/data/driver/models/ride_data_model.dart';
import 'package:cabwire/data/driver/models/trip_statistic_model.dart';
import 'package:cabwire/presentation/common/components/action_button.dart';
import 'package:cabwire/presentation/common/components/custom_app_bar.dart';
import 'package:cabwire/presentation/common/components/custom_text.dart';
import 'package:cabwire/presentation/driver/create_post/ui/create_post_details_page.dart';
import 'package:cabwire/presentation/driver/profile/widgets/common_image.dart';
import 'package:cabwire/presentation/driver/ride_history/widgets/driver_profile_widget.dart';
import 'package:cabwire/presentation/driver/ride_history/widgets/route_information_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RideOverviewScreen extends StatelessWidget {
  final bool isCreatePost;

  const RideOverviewScreen({super.key, this.isCreatePost = false});

  // Extract static data to avoid recreation on every build
  static const RideData _rideData = RideData(
    driverName: 'Santiago Dslab',
    vehicleNumber: 'DHK METRO HA 64-8549',
    vehicleModel: 'Volvo XC90',
    pickupLocation: 'Block B, Banasree, Dhaka.',
    dropoffLocation: 'Green Road, Dhanmondi, Dhaka.',
    dropoffLocation2: 'Green Road, Dhanmondi, Dhaka.',
    statistics: [
      TripStatistic(title: 'Total Distance:', value: '20 km'),
      TripStatistic(title: 'Per Km Rate:', value: '\$1'),
      TripStatistic(title: 'Seat Available:', value: '2'),
      TripStatistic(title: 'Last Booking Time:', value: '45 Minutes'),
    ],
    totalAmount: '\$100',
  );

  // Constants for better maintainability
  static const double _defaultSpacing = 16.0;
  static const double _sectionSpacing = 24.0;
  static const double _smallSpacing = 12.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Ride Overview',
        showBackButton: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(_defaultSpacing),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDriverSection(),
            const SizedBox(height: _sectionSpacing),
            _buildVehicleSection(),
            const SizedBox(height: _sectionSpacing),
            _buildTripSection(),
            const SizedBox(height: _sectionSpacing),
            _buildStatisticsSection(),
            const SizedBox(height: 20),
            _buildPaymentSection(),
            const SizedBox(height: _sectionSpacing),
          ],
        ),
      ),
      bottomSheet: _buildBottomSheet(),
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

  Widget _buildStatisticsSection() {
    return Column(
      children:
          _rideData.statistics
              ?.map(
                (stat) => Padding(
                  padding: const EdgeInsets.only(bottom: _smallSpacing),
                  child: _TripStatisticItem(
                    title: stat.title,
                    value: stat.value,
                  ),
                ),
              )
              .toList() ??
          [],
    );
  }

  Widget _buildPaymentSection() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(Icons.wallet, size: 20),
        ),
        const SizedBox(width: 12),
        const Expanded(
          child: CustomText(
            'Total Amount',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
        ),
        CustomText(
          _rideData.totalAmount,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }

  Widget _buildBottomSheet() {
    if (!isCreatePost) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: ActionButton(
        borderRadius: 0,
        isPrimary: true,
        text: 'Create Post',
        onPressed: () => Get.to(() => const CreatePostDetailsScreen()),
      ),
    );
  }
}

// Extracted as a separate widget for better performance and reusability
class _TripStatisticItem extends StatelessWidget {
  final String title;
  final String value;

  const _TripStatisticItem({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CustomText(title, fontSize: 14, fontWeight: FontWeight.w600),
        CustomText(value, fontSize: 14, fontWeight: FontWeight.w600),
      ],
    );
  }
}
