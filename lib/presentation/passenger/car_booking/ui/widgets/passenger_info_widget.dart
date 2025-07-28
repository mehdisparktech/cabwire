import 'package:cabwire/core/config/app_assets.dart'; // Assuming AppAssets is accessible
import 'package:cabwire/core/config/app_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:get/get.dart'; // Not directly using context.theme here, but could if colors were themed

class PassengerInfoWidget extends StatelessWidget {
  const PassengerInfoWidget({super.key});
  // If passenger data was dynamic, you'd pass it here:
  // final String passengerName;
  // final String passengerAddress;
  // final String distance;
  // final String profileImageUrl; // Or AssetImage
  // const PassengerInfoWidget({
  //   super.key,
  //   required this.passengerName,
  //   required this.passengerAddress,
  //   required this.distance,
  //   required this.profileImageUrl,
  // });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              color: context.theme.colorScheme.primary,
              shape: BoxShape.circle,
            ),
            child: Padding(
              padding: const EdgeInsets.all(2.0),
              child: const CircleAvatar(
                radius: 24,
                backgroundImage: AssetImage(
                  AppAssets.icProfileImage,
                ), // Use passed data if dynamic
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Use passed data if dynamic
                const Text(
                  'Santiago Dslob',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF1E1E1E),
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.yellow, size: 14),
                    const SizedBox(width: 4),
                    const Text('4.65', style: TextStyle(fontSize: 12)),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      height: 12.px,
                      width: 1,
                      color: Color(0xFF1E1E1E),
                    ),
                    const SizedBox(width: 4),
                    const Text('2534 Trips', style: TextStyle(fontSize: 12)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
