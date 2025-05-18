import 'package:flutter/material.dart';
import 'package:get/get.dart'; // For context.theme

class TripStoppageInfoWidget extends StatelessWidget {
  const TripStoppageInfoWidget({super.key});
  // If stoppageLocation was dynamic, you'd pass it here:
  // final String stoppageLocation;
  // const TripStoppageInfoWidget({super.key, required this.stoppageLocation});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Text(
              'Trip Stoppage',
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              children: [
                Icon(
                  Icons.location_on,
                  color: context.theme.colorScheme.error,
                  size: 20,
                ),
                const SizedBox(width: 8),
                const Expanded(
                  // Use passed data if dynamic
                  child: Text(
                    'Green Road, Dhanmondi, Dhaka.',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.black87,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
