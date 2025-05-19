import 'dart:async';

import 'package:cabwire/core/utility/utility.dart';
import 'package:cabwire/presentation/driver/chat/ui/chat_page.dart';
import 'package:cabwire/presentation/driver/home/ui/driver_trip_close_otp_page.dart';
import 'package:cabwire/presentation/driver/home/widgets/ride_action_button.dart';
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
  }

  void _onRideStart() async {
    Duration duration = const Duration(seconds: 5);
    await Future.delayed(duration, () {
      setState(() {
        isRideStart = true;
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
                    ? 'You\'re on the way to pick up the passenger.'
                    : 'Ready To Start The Ride',
            isRideStart: isRideStart,
          ), // Use the new widget
          const SizedBox(height: 16),
          const PassengerInfoWidget(), // Use the new widget
          const SizedBox(height: 16),
          MessageButtonWidget(
            // Use the new widget
            onTap: () {
              // You can define specific onTap behavior here if needed
              Get.to(() => ChatPage());
            },
          ),
          const SizedBox(height: 16),
          const TripStoppageInfoWidget(), // Use the new widget
          // Use the new widget
          isRideStart
              ? RideActionButton(
                isPrimary: true,
                text: isRideProcessing ? 'Trip Closure' : 'Start Ride',
                onPressed: () {
                  // You can define specific onTap behavior here if needed
                  if (isRideProcessing) {
                    Get.to(() => DriverTripCloseOtpPage());
                  } else {
                    setState(() {
                      isRideProcessing = true;
                    });
                  }
                },
              )
              : const PaymentInfoWidget(),
        ],
      ),
    );
  }
}
