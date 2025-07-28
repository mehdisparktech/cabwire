import 'package:cabwire/core/config/app_assets.dart';
import 'package:cabwire/core/config/app_screen.dart';
import 'package:cabwire/core/di/service_locator.dart';
import 'package:cabwire/core/external_libs/presentable_widget_builder.dart';
import 'package:cabwire/core/static/ui_const.dart';
import 'package:cabwire/domain/entities/driver/create_cabwire_entity.dart';
import 'package:cabwire/presentation/common/components/action_button.dart';
import 'package:cabwire/presentation/common/components/circular_icon_button.dart';
import 'package:cabwire/presentation/common/components/custom_app_bar.dart';
import 'package:cabwire/presentation/common/components/custom_text.dart';
import 'package:cabwire/presentation/driver/chat/ui/screens/chat_page.dart';
import 'package:cabwire/presentation/driver/create_post/presenter/create_post_presenter.dart';
import 'package:cabwire/presentation/driver/create_post/ui/screens/ride_details_page.dart';
import 'package:cabwire/presentation/driver/create_post/ui/screens/ride_start_page.dart';
import 'package:cabwire/presentation/common/components/common_image.dart';
import 'package:cabwire/presentation/driver/ride_history/ui/widgets/driver_profile_widget.dart';
import 'package:cabwire/presentation/driver/ride_history/ui/widgets/route_information_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CreatePostDetailsScreen extends StatefulWidget {
  final bool isCreatePost;
  final CabwireResponseEntity cabwireResponseEntity;

  const CreatePostDetailsScreen({
    super.key,
    this.isCreatePost = false,
    required this.cabwireResponseEntity,
  });

  @override
  State<CreatePostDetailsScreen> createState() =>
      _CreatePostDetailsScreenState();
}

class _CreatePostDetailsScreenState extends State<CreatePostDetailsScreen> {
  late final CreatePostPresenter _presenter;

  @override
  void initState() {
    super.initState();
    _presenter = locate<CreatePostPresenter>();
    // Explicitly reload driver profile when screen is shown
    Future.microtask(() => _presenter.loadDriverProfile());
  }

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
  //static const double _sectionSpacing = 24.0;

  @override
  Widget build(BuildContext context) {
    // Debug log to see if driver name is available

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
                _buildDriverSection(),
                gapH10,
                _buildVehicleSection(rideData),
                gapH10,
                _buildTripSection(rideData),
                gapH10,
                _buildSeatBookingSection(context),
                gapH10,
                _buildBottomSheet(),
                gapH10,
              ],
            ),
          );
        },
      ),
    );
  }

  // Extracted widgets for better organization and reusability
  Widget _buildDriverSection() {
    final driverName = _presenter.currentUiState.driverName;

    return DriverProfileWidget(
      name: driverName?.isNotEmpty == true ? driverName! : 'Driver Name',
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
        DriverRouteInformationWidget(
          pickupLocation:
              widget.cabwireResponseEntity.data.pickupLocation.address,
          dropoffLocation:
              widget.cabwireResponseEntity.data.dropoffLocation.address,
          dropoffLocation2:
              widget.cabwireResponseEntity.data.dropoffLocation.address,
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
            CustomText('0/${widget.cabwireResponseEntity.data.setAvailable}'),
            gapH10,
            GestureDetector(
              onTap: () {
                Get.to(
                  () => CreatePostRideDetailsScreen(
                    cabwireResponseEntity: widget.cabwireResponseEntity,
                    driverName:
                        _presenter.currentUiState.rideData?.driverName ?? '',
                    vehicleNumber:
                        _presenter.currentUiState.rideData?.vehicleNumber ?? '',
                    vehicleModel:
                        _presenter.currentUiState.rideData?.vehicleModel ?? '',
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
              icon: Icons.message_outlined,
              onTap: () {
                Get.to(
                  () => ChatPage(chatId: widget.cabwireResponseEntity.data.id),
                );
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
      text: 'Continue',
      onPressed: () => Get.to(() => const RideStartPage()),
    );
  }
}
