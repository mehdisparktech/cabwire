import 'package:cabwire/core/config/app_assets.dart'; // Assuming AppAssets is accessible
import 'package:cabwire/core/config/app_screen.dart';
import 'package:cabwire/core/static/ui_const.dart';
import 'package:cabwire/presentation/common/components/custom_text.dart';
import 'package:flutter/material.dart';
// import 'package:get/get.dart'; // Not directly using context.theme here, but could if colors were themed

class PassengerInfoWidget extends StatelessWidget {
  final String passengerName;
  final String? passengerAddress;
  final String? distance;

  const PassengerInfoWidget({
    super.key,
    required this.passengerName,
    this.passengerAddress = 'Block B, Banasree, Dhaka.',
    this.distance = '3.3 km',
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.px),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20.px,
            backgroundImage: AssetImage(AppAssets.icProfileImage),
          ),
          gapW12,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  passengerName,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF1E1E1E),
                  fontSize: 14.px,
                ),
                gapH2,
                CustomText(
                  passengerAddress ?? 'Unknown address',
                  fontWeight: FontWeight.w700,
                  fontSize: 14.px,
                ),
              ],
            ),
          ),
          CustomText(
            distance ?? '',
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
