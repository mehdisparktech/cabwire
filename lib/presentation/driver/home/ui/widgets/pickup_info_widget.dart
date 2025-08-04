import 'package:cabwire/core/config/app_screen.dart';
import 'package:cabwire/core/static/ui_const.dart';
import 'package:cabwire/presentation/common/components/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart'; // For context.theme

class PickupInfoWidget extends StatelessWidget {
  final int timerLeft;
  final String pickupText;
  final bool isRideStart;
  final bool isRideProcessing;
  const PickupInfoWidget({
    super.key,
    required this.timerLeft,
    required this.pickupText,
    this.isRideStart = false,
    this.isRideProcessing = false,
  });

  // Format the time to show as hours and minutes or just minutes
  String _formatTime(int minutes) {
    if (minutes >= 60) {
      final hours = minutes ~/ 60;
      final mins = minutes % 60;
      return '$hours h ${mins > 0 ? '$mins min' : ''}';
    } else {
      return '$minutes min';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.px),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            width: 10.px,
            height: 10.px,
            decoration: BoxDecoration(
              color: context.theme.colorScheme.primary,
              shape: BoxShape.circle,
            ),
          ),
          gapW8,
          Expanded(
            child: CustomText(
              pickupText,
              fontSize: 14.px,
              fontWeight: FontWeight.w500,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          gapW8,
          // Display timer for both ride start and ride processing
          if ((!isRideStart || isRideProcessing) && timerLeft > 0)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8.px, vertical: 4.px),
              decoration: BoxDecoration(
                color: context.theme.colorScheme.primary,
                borderRadius: BorderRadius.circular(8.px),
              ),
              child: CustomText(
                _formatTime(timerLeft),
                color: Colors.white,
                fontSize: 12.px,
                fontWeight: FontWeight.bold,
              ),
            ),
        ],
      ),
    );
  }
}
