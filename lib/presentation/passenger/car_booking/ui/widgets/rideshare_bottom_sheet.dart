import 'dart:async';

import 'package:cabwire/core/config/app_assets.dart';
import 'package:cabwire/core/config/app_screen.dart';
import 'package:cabwire/core/utility/utility.dart';
import 'package:cabwire/presentation/common/components/circular_icon_button.dart';
import 'package:cabwire/presentation/common/components/common_image.dart';
import 'package:cabwire/presentation/driver/chat/ui/screens/audio_call_page.dart';
import 'package:cabwire/presentation/driver/chat/ui/screens/chat_page.dart';
import 'package:cabwire/presentation/common/components/action_button.dart';
import 'package:cabwire/presentation/passenger/car_booking/ui/screens/passenger_trip_close_otp_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart'; // For context.theme in RideshareBottomSheet itself

// --- Import your new widget files ---
import 'pickup_info_widget.dart'; // Adjust path as needed
import 'passenger_info_widget.dart'; // Adjust path as needed
import 'message_button_widget.dart'; // Adjust path as needed
import 'trip_stoppage_info_widget.dart'; // Adjust path as needed
import 'payment_info_widget.dart'; // Adjust path as needed

class RideshareBottomSheet extends StatefulWidget {
  const RideshareBottomSheet({super.key});

  @override
  State<RideshareBottomSheet> createState() => _RideshareBottomSheetState();
}

class _RideshareBottomSheetState extends State<RideshareBottomSheet> {
  bool isRideStart = false;
  int timerLeft = 5;
  bool isRideEnd = false;
  bool isRideProcessing = false;
  @override
  void initState() {
    super.initState();
    _onRideStart();
    _onRideProcessing();
    _onRideEnd();
  }

  void _onRideStart() async {
    Duration duration = const Duration(seconds: 5);
    await Future.delayed(duration, () {
      setState(() {
        isRideStart = true;
      });
    });
  }

  void _onRideProcessing() async {
    Duration duration = const Duration(seconds: 10);
    await Future.delayed(duration, () {
      setState(() {
        isRideProcessing = true;
      });
    });
  }

  void _onRideEnd() async {
    Duration duration = const Duration(seconds: 15);
    await Future.delayed(duration, () {
      setState(() {
        isRideProcessing = false;
        isRideEnd = true;
      });
    });
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
          const SizedBox(height: 12),
          PickupInfoWidget(
            timerLeft: timerLeft,
            pickupText:
                !isRideStart
                    ? 'Driver is on the way to pickup.'
                    : isRideProcessing
                    ? 'Your Trip Is Completed With-in'
                    : isRideEnd
                    ? 'Your Trip Is Completed'
                    : 'Ready To Start The Ride',
            isRideStart: isRideStart,
            isRideProcessing: isRideProcessing,
          ), // Use the new widget
          SizedBox(height: 16.px),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  // Added Expanded for long vehicle numbers
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'DHK METRO HA 64-8549',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Volvo XC90',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10), // Spacing
                CommonImage(
                  imageSrc: AppAssets.icCarImage,
                  imageType: ImageType.png,
                  height: 40,
                  width: 100,
                  fill: BoxFit.contain, // Ensure image fits
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),
          const PassengerInfoWidget(), // Use the new widget
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                flex: 5,
                child: MessageButtonWidget(
                  // Use the new widget
                  onTap: () {
                    // You can define specific onTap behavior here if needed
                    Get.to(() => ChatPage());
                  },
                ),
              ),
              Expanded(
                flex: 1,
                child: CircularIconButton(
                  icon: Icons.phone,
                  onTap: () {
                    Get.to(() => const AudioCallScreen());
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const TripStoppageInfoWidget(
            stoppageLocation: 'Green Road, Dhanmondi, Dhaka.',
          ), // Use the new widget
          const SizedBox(height: 16),
          const PaymentInfoWidget(),
          // Use the new widget
          if (isRideProcessing || isRideEnd)
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: ActionButton(
                isPrimary: true,
                text: 'Trip Closure',
                onPressed: () {
                  // You can define specific onTap behavior here if needed
                  if (isRideEnd) {
                    Get.to(() => PassengerTripCloseOtpPage());
                  } else {
                    setState(() {
                      isRideProcessing = true;
                    });
                  }
                },
              ),
            ),
        ],
      ),
    );
  }
}
