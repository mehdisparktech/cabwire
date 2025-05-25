import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RouteInformationWidget extends StatelessWidget {
  final String pickupLocation;
  final String dropoffLocation;
  final String? dropoffLocation2;

  const RouteInformationWidget({
    super.key,
    required this.pickupLocation,
    required this.dropoffLocation,
    this.dropoffLocation2,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            const Icon(Icons.directions_car, size: 20, color: Colors.black87),
            Container(width: 2, height: 30, color: Colors.grey.shade300),
            Icon(
              Icons.location_on,
              size: 20,
              color: context.theme.colorScheme.primary,
            ),
            if (dropoffLocation2 != null)
              Icon(
                Icons.location_on,
                size: 20,
                color: context.theme.colorScheme.primary,
              ),
          ],
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                pickupLocation,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                dropoffLocation,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              if (dropoffLocation2 != null)
                Text(
                  dropoffLocation2!,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
