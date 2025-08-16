import 'package:cabwire/core/enum/service_type.dart';
import 'package:cabwire/presentation/passenger/car_booking/ui/screens/add_stoppage_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart'; // For context.theme

class TripStoppageInfoWidget extends StatelessWidget {
  final String stoppageLocation;
  final String? stoppageLocation2;

  const TripStoppageInfoWidget({
    super.key,
    required this.stoppageLocation,
    this.stoppageLocation2,
  });

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
                Expanded(
                  child: Text(
                    stoppageLocation,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.black87,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: () {
                    Get.to(
                      () => AddStoppageScreen(
                        serviceType: ServiceType.none,
                        serviceId: null,
                      ),
                    );
                  },
                  child: Text(
                    "Add Stoppage",
                    style: TextStyle(
                      fontSize: 12,
                      color: context.theme.colorScheme.primary,
                      fontWeight: FontWeight.w600,
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
