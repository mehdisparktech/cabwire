import 'package:cabwire/core/config/app_assets.dart';
import 'package:cabwire/core/config/app_screen.dart';
import 'package:cabwire/core/di/service_locator.dart';
import 'package:cabwire/core/external_libs/presentable_widget_builder.dart';
import 'package:cabwire/core/static/ui_const.dart';
import 'package:cabwire/presentation/common/components/action_button.dart';
import 'package:cabwire/presentation/common/components/custom_app_bar.dart';
import 'package:cabwire/presentation/common/components/custom_text.dart';
import 'package:cabwire/presentation/driver/create_post/presenter/create_post_presenter.dart';
import 'package:cabwire/presentation/driver/create_post/ui/screens/create_post_details_page.dart';
import 'package:cabwire/presentation/common/components/common_image.dart';
import 'package:cabwire/presentation/driver/ride_history/ui/widgets/driver_profile_widget.dart';
import 'package:cabwire/presentation/driver/ride_history/ui/widgets/route_information_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RideOverviewScreen extends StatelessWidget {
  final bool isCreatePost;

  RideOverviewScreen({super.key, this.isCreatePost = false});
  final CreatePostPresenter _presenter = locate<CreatePostPresenter>();

  // Extract static data to avoid recreation on every build
  // static const RideData _rideData = RideData(
  //   driverName: 'Santiago Dslab',
  //   vehicleNumber: 'DHK METRO HA 64-8549',
  //   vehicleModel: 'Volvo XC90',
  //   pickupLocation: 'Block B, Banasree, Dhaka.',
  //   dropoffLocation: 'Green Road, Dhanmondi, Dhaka.',
  //   dropoffLocation2: 'Green Road, Dhanmondi, Dhaka.',
  //   statistics: [
  //     TripStatistic(title: 'Total Distance:', value: '20 km'),
  //     TripStatistic(title: 'Per Km Rate:', value: '\$1'),
  //     TripStatistic(title: 'Seat Available:', value: '2'),
  //     TripStatistic(title: 'Last Booking Time:', value: '45 Minutes'),
  //   ],
  //   totalAmount: '\$100',
  // );

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
      body: PresentableWidgetBuilder<CreatePostPresenter>(
        presenter: _presenter,
        builder: () {
          final rideData = _presenter.currentUiState.rideData;
          return SingleChildScrollView(
            padding: const EdgeInsets.all(_defaultSpacing),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDriverSection(rideData),
                const SizedBox(height: _sectionSpacing),
                _buildVehicleSection(rideData),
                const SizedBox(height: _sectionSpacing),
                _buildTripSection(rideData),
                const SizedBox(height: _sectionSpacing),
                _buildStatisticsSection(rideData),
                const SizedBox(height: 20),
                _buildPaymentSection(rideData),
                const SizedBox(height: _sectionSpacing),
              ],
            ),
          );
        },
      ),
      bottomSheet: _buildBottomSheet(),
    );
  }

  // Extracted widgets for better organization and reusability
  Widget _buildDriverSection(dynamic rideData) {
    return DriverProfileWidget(
      name: rideData?.driverName ?? '',
      textStyle: TextStyle(
        fontSize: 16.px,
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
                  fontSize: 14.px,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
              gapH4,
              Text(
                rideData?.vehicleModel ?? '',
                style: TextStyle(fontSize: 14.px, color: Colors.black87),
              ),
            ],
          ),
        ),
        CommonImage(
          imageSrc: AppAssets.icCarImage,
          imageType: ImageType.png,
          height: 40.px,
          width: 100.px,
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
          style: TextStyle(fontSize: 16.px, fontWeight: FontWeight.bold),
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

  Widget _buildStatisticsSection(dynamic rideData) {
    return Column(
      children:
          rideData?.statistics
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

  Widget _buildPaymentSection(dynamic rideData) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(8.px),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(8.px),
          ),
          child: Icon(Icons.wallet, size: 20.px),
        ),
        gapW12,
        Expanded(
          child: CustomText(
            'Total Amount',
            style: TextStyle(fontSize: 18.px, fontWeight: FontWeight.w600),
          ),
        ),
        CustomText(
          rideData?.totalAmount ?? '',
          style: TextStyle(fontSize: 16.px, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }

  Widget _buildBottomSheet() {
    if (!isCreatePost) return const SizedBox.shrink();

    return Padding(
      padding: EdgeInsets.only(bottom: 16.px),
      child: ActionButton(
        borderRadius: 0,
        isPrimary: true,
        text: 'Create Post',
        onPressed: () => Get.to(() => CreatePostDetailsScreen()),
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
