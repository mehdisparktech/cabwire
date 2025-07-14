import 'package:flutter/material.dart';
import 'package:get/get.dart'; // For context.theme

class PickupInfoWidget extends StatelessWidget {
  final int timerLeft;
  final String pickupText;
  final bool isRideStart;
  final bool isRideProcessing;
  final bool isRideEnd;
  const PickupInfoWidget({
    super.key,
    required this.timerLeft,
    required this.pickupText,
    this.isRideStart = false,
    this.isRideProcessing = false,
    this.isRideEnd = false,
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
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              color: context.theme.colorScheme.primary,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              pickupText,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 8),

          // Display timer for both ride start and ride processing
          if (isRideStart || isRideProcessing && timerLeft > 0)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: context.theme.colorScheme.primary,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                _formatTime(timerLeft),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
