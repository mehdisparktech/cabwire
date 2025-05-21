import 'dart:async';

import 'package:cabwire/core/utility/utility.dart';
import 'package:cabwire/presentation/common/components/action_button.dart';
import 'package:cabwire/presentation/driver/chat/ui/chat_page.dart';
import 'package:cabwire/presentation/driver/chat/widgets/phone_button.dart';
import 'package:cabwire/presentation/driver/create_post/ui/rideshare_trip_close_otp_page.dart';
import 'package:cabwire/presentation/driver/home/widgets/message_button_widget.dart';
import 'package:cabwire/presentation/driver/home/widgets/passenger_info_widget.dart';
import 'package:cabwire/presentation/driver/home/widgets/payment_info_widget.dart';
import 'package:cabwire/presentation/driver/home/widgets/pickup_info_widget.dart';
import 'package:cabwire/presentation/driver/home/widgets/trip_stoppage_info_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart'; // For context.theme in RideshareBottomSheet itself

class RideBottomSheet extends StatefulWidget {
  const RideBottomSheet({super.key});

  @override
  State<RideBottomSheet> createState() => _RideBottomSheetState();
}

class _RideBottomSheetState extends State<RideBottomSheet> {
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
              Expanded(flex: 1, child: PhoneButton()),
            ],
          ),
          const SizedBox(height: 16),
          const TripStoppageInfoWidget(
            stoppageLocation: 'Green Road, Dhanmondi, Dhaka.',
          ), // Use the new widget
          // Use the new widget
          isRideStart
              ? ActionButton(
                isPrimary: true,
                text: isRideProcessing ? 'Trip Closure' : 'Start Ride',
                onPressed: () {
                  // You can define specific onTap behavior here if needed
                  if (isRideProcessing) {
                    Get.to(() => RideshareTripCloseOtpPage());
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
