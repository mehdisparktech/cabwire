import 'package:cabwire/core/utility/utility.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart'; // For context.theme in RideshareBottomSheet itself

// --- Import your new widget files ---
import 'pickup_info_widget.dart'; // Adjust path as needed
import 'passenger_info_widget.dart'; // Adjust path as needed
import 'message_button_widget.dart'; // Adjust path as needed
import 'trip_stoppage_info_widget.dart'; // Adjust path as needed
import 'payment_info_widget.dart'; // Adjust path as needed

class RideshareBottomSheet extends StatelessWidget {
  const RideshareBottomSheet({super.key});

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
          const PickupInfoWidget(), // Use the new widget
          const SizedBox(height: 16),
          const PassengerInfoWidget(), // Use the new widget
          const SizedBox(height: 16),
          MessageButtonWidget(
            // Use the new widget
            onTap: () {
              // You can define specific onTap behavior here if needed
              Get.snackbar(
                "Custom Action",
                "Message button tapped from BottomSheet!",
              );
            },
          ),
          const SizedBox(height: 16),
          const TripStoppageInfoWidget(), // Use the new widget
          const PaymentInfoWidget(), // Use the new widget
        ],
      ),
    );
  }
}
