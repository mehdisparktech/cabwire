import 'dart:async';

import 'package:cabwire/core/config/app_color.dart';
import 'package:cabwire/core/utility/utility.dart';
import 'package:cabwire/presentation/passenger/car_booking/ui/screens/ride_share_screen.dart';
import 'package:cabwire/presentation/passenger/passenger_history/ui/widgets/passenger_route_information_widget.dart';
import 'package:flutter/material.dart';
// For context.theme in RideshareBottomSheet itself
import 'package:responsive_sizer/responsive_sizer.dart';

// Adjust path as needed
import 'payment_info_widget.dart'; // Adjust path as needed

class FindingRideshareBottomSheet extends StatefulWidget {
  const FindingRideshareBottomSheet({super.key});

  @override
  State<FindingRideshareBottomSheet> createState() =>
      _FindingRideshareBottomSheetState();
}

class _FindingRideshareBottomSheetState
    extends State<FindingRideshareBottomSheet>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  bool isRiderFound = false;
  @override
  void initState() {
    super.initState();
    _initializeAnimation();
    _onRideStart();
  }

  void _onRideStart() async {
    Duration duration = const Duration(seconds: 5);
    await Future.delayed(duration, () {
      Navigator.push(
        // ignore: use_build_context_synchronously
        context,
        MaterialPageRoute(builder: (context) => const RideShareScreen()),
      );
    });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
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
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Your Trip',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Edit',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              PassengerRouteInformationWidget(
                pickupLocation: 'Green Road, Dhanmondi, Dhaka.',
                dropoffLocation: 'Green Road, Dhanmondi, Dhaka.',
              ),
            ],
          ),
          // Use the new widget
          SizedBox(height: 16.px),
          const PaymentInfoWidget(),
          SizedBox(height: 16.px),
          _buildCancelButton(),
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
                  // Add your onTap logic here
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
