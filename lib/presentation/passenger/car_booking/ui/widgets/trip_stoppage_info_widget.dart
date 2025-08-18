import 'package:cabwire/core/enum/service_type.dart';
import 'package:cabwire/presentation/passenger/car_booking/ui/screens/add_stoppage_screen.dart';
import 'package:cabwire/presentation/common/components/share_trip_dropdown.dart';
import 'package:cabwire/presentation/common/components/share_trip_presenter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart'; // For context.theme

class TripStoppageInfoWidget extends StatelessWidget {
  final String stoppageLocation;
  final String? stoppageLocation2;
  final String? rideId;

  const TripStoppageInfoWidget({
    super.key,
    required this.stoppageLocation,
    this.stoppageLocation2,
    this.rideId,
  });

  void _shareTrip(String type) {
    if (rideId == null) return;

    final sharePresenter = ShareTripPresenter();

    switch (type) {
      case 'whatsapp':
        sharePresenter.shareToWhatsApp(rideId!);
        break;
      case 'messenger':
        sharePresenter.shareToMessenger(rideId!);
        break;
      case 'email':
        sharePresenter.shareViaEmail(rideId!);
        break;
      case 'general':
        sharePresenter.shareGeneral(rideId!);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Trip Stoppage',
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
                ),
                if (rideId != null)
                  ShareTripDropdown(
                    rideId: rideId!,
                    onWhatsAppShare: () => _shareTrip('whatsapp'),
                    onMessengerShare: () => _shareTrip('messenger'),
                    onEmailShare: () => _shareTrip('email'),
                    onGeneralShare: () => _shareTrip('general'),
                  ),
              ],
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
