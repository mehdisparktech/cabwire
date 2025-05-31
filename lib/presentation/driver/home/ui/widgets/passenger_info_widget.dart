import 'package:cabwire/core/config/app_assets.dart'; // Assuming AppAssets is accessible
import 'package:cabwire/core/config/app_screen.dart';
import 'package:cabwire/core/static/ui_const.dart';
import 'package:cabwire/presentation/common/components/custom_text.dart';
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
      padding: EdgeInsets.symmetric(horizontal: 16.px),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20.px,
            backgroundImage: AssetImage(
              AppAssets.icProfileImage,
            ), // Use passed data if dynamic
          ),
          gapW12,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Use passed data if dynamic
                CustomText(
                  'Santiago Dslob',
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF1E1E1E),
                  fontSize: 14.px,
                ),
                gapH2,
                CustomText(
                  'Block B, Banasree, Dhaka.',
                  fontWeight: FontWeight.w700,
                  fontSize: 14.px,
                ),
              ],
            ),
          ),
          CustomText(
            // Use passed data if dynamic
            '3.3 km',
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 12.px,
              color: Color(0xFF1E1E1E),
            ),
          ),
        ],
      ),
    );
  }
}
