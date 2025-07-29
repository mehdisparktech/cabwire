import 'package:cabwire/core/config/app_color.dart';
import 'package:cabwire/core/utility/utility.dart';
import 'package:cabwire/data/models/ride/ride_response_model.dart';
import 'package:cabwire/presentation/common/components/action_button.dart';
import 'package:cabwire/presentation/passenger/car_booking/presenter/finding_rides_presenter.dart';
import 'package:cabwire/presentation/passenger/home/ui/screens/passenger_search_destination_page.dart';
import 'package:cabwire/presentation/passenger/passenger_history/ui/widgets/passenger_route_information_widget.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'dart:async';

import 'payment_info_widget.dart';

class FindingRideshareBottomSheet extends StatefulWidget {
  final String rideId;
  final RideResponseModel rideResponse;
  final FindingRidesPresenter presenter;

  const FindingRideshareBottomSheet({
    super.key,
    required this.rideId,
    required this.rideResponse,
    required this.presenter,
  });

  @override
  State<FindingRideshareBottomSheet> createState() =>
      _FindingRideshareBottomSheetState();
}

class _FindingRideshareBottomSheetState
    extends State<FindingRideshareBottomSheet>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  StreamSubscription? _uiStateSubscription;

  @override
  void initState() {
    super.initState();
    _initializeAnimation();
    _listenToRideUpdates();
  }

  void _listenToRideUpdates() {
    // Cancel existing subscription
    _uiStateSubscription?.cancel();

    // Listen to UI state changes
    _uiStateSubscription = widget.presenter.uiState.stream.listen((state) {
      if (mounted) {
        // If a driver accepts the ride or ride is started, navigate to the RideShareScreen
        if (state.isRideAccepted || state.isRideStarted) {
          widget.presenter.navigateToRideShareScreen(
            context,
            widget.rideId,
            widget.rideResponse,
          );
        }
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _uiStateSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacityInt(0.12),
            blurRadius: 10,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 16.px),
          _buildHeader(),
          SizedBox(height: 16.px),
          _buildDriverCard(),
          SizedBox(height: 16.px),
          _buildProgressBar(),
          SizedBox(height: 16.px),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.px),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Your Trip',
                      style: TextStyle(
                        fontSize: 16.px,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) =>
                                    const PassengerSearchDestinationScreen(),
                          ),
                        );
                      },
                      child: Text(
                        'Edit',
                        style: TextStyle(
                          fontSize: 14.px,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                PassengerRouteInformationWidget(
                  pickupLocation:
                      widget.rideResponse.data.pickupLocation.address,
                  dropoffLocation:
                      widget.rideResponse.data.dropoffLocation.address,
                ),
              ],
            ),
          ),
          SizedBox(height: 16.px),
          PaymentInfoWidget(
            paymentType:
                widget.rideResponse.data.paymentMethod == 'offline'
                    ? 'Cash Payment'
                    : 'Online Payment',
            amount: widget.rideResponse.data.fare.toString(),
          ),
          SizedBox(height: 16.px),
          _buildCancelButton(),
          SizedBox(height: 16.px),
        ],
      ),
    );
  }

  void _initializeAnimation() {
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _animation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
    _controller.repeat();
  }

  Widget _buildHeader() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 14.px),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Finding nearby rides..',
            style: TextStyle(fontSize: 18.px, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          Text(
            "We have sent your ride request to the nearby Driver's.",
            style: TextStyle(fontSize: 12.px, height: 1.4),
          ),
        ],
      ),
    );
  }

  Widget _buildDriverCard() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 14.px),
      child: Row(
        children: [
          _buildProfilePicture(),
          SizedBox(width: 16.px),
          Expanded(child: _buildDriverInfo()),
        ],
      ),
    );
  }

  Widget _buildProfilePicture() {
    return Container(
      width: 60,
      height: 60,
      decoration: const BoxDecoration(
        color: Color(0xffC1C7D0),
        shape: BoxShape.circle,
      ),
    );
  }

  Widget _buildDriverInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSkeletonLoader(width: 120),
        const SizedBox(height: 12),
        _buildSkeletonLoader(width: 120),
      ],
    );
  }

  Widget _buildSkeletonLoader({required double width}) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          height: 10,
          width: width,
          decoration: BoxDecoration(
            color: const Color(0xffC1C7D0),
            borderRadius: BorderRadius.circular(8),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: _animation.value,
              backgroundColor: Colors.grey[300],
              valueColor: const AlwaysStoppedAnimation<Color>(
                Color(0xffC1C7D0),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildProgressBar() {
    return Container(
      width: double.infinity,
      height: 4,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(2),
      ),
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: _animation.value,
            child: Container(
              decoration: BoxDecoration(
                color: AppColor.primary,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCancelButton() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 14.px),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Cancel this ride?',
            style: TextStyle(fontSize: 12.px, fontWeight: FontWeight.w600),
          ),
          SizedBox(width: 16.px),
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder:
                        (context) => AlertDialog(
                          title: Text(
                            'Are you sure you want to cancel this ride?',
                            style: TextStyle(
                              fontSize: 18.px,
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          content: Row(
                            children: [
                              Expanded(
                                child: ActionButton(
                                  text: 'No',
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                ),
                              ),
                              SizedBox(width: 16.px),
                              Expanded(
                                child: ActionButton(
                                  isPrimary: true,
                                  text: 'Yes',
                                  onPressed: () {
                                    widget.presenter.cancelRideRequest(
                                      context,
                                      widget.rideId,
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                  );
                },
                child: Text(
                  'Cancel Now',
                  style: TextStyle(
                    fontSize: 12.px,
                    fontWeight: FontWeight.w600,
                    color: Colors.red,
                  ),
                ),
              ),
              SizedBox(width: 4.px),
              Icon(Icons.close_outlined, color: Colors.red, size: 16.px),
            ],
          ),
        ],
      ),
    );
  }
}
