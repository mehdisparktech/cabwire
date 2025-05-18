import 'package:cabwire/core/config/app_assets.dart'; // Assuming AppAssets is accessible
import 'package:flutter/material.dart';
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
          const CircleAvatar(
            radius: 20,
            backgroundImage: AssetImage(
              AppAssets.icProfileImage,
            ), // Use passed data if dynamic
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                // Use passed data if dynamic
                Text(
                  'Santiago Dslob',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF1E1E1E),
                    fontSize: 14,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'Block B, Banasree, Dhaka.',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                ),
              ],
            ),
          ),
          const Text(
            // Use passed data if dynamic
            '3.3 km',
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 12,
              color: Color(0xFF1E1E1E),
            ),
          ),
        ],
      ),
    );
  }
}
