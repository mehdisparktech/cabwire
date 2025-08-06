import 'package:cabwire/core/utility/utility.dart';
import 'package:cabwire/presentation/common/components/circular_icon_button.dart';
import 'package:cabwire/presentation/common/components/action_button.dart';
import 'package:cabwire/presentation/driver/home/presenter/rideshare_presenter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// --- Import your widget files ---
import 'pickup_info_widget.dart';
import 'passenger_info_widget.dart';
import 'message_button_widget.dart';
import 'trip_stoppage_info_widget.dart';
import 'payment_info_widget.dart';

class RideshareBottomSheet extends StatelessWidget {
  final RidesharePresenter presenter;
  const RideshareBottomSheet({super.key, required this.presenter});

  String _getPickupText(uiState) {
    if (uiState.isRideProcessing) {
      return 'Your Trip Will Complete In Approximately';
    } else if (uiState.isRideStart) {
      return 'Ready To Start The Ride';
    } else {
      return 'You\'re on the way to pick up the passenger.';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final uiState = presenter.currentUiState;

      return Container(
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacityInt(0.12),
              blurRadius: 10,
              spreadRadius: 0,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12),
            PickupInfoWidget(
              timerLeft: uiState.timerLeft,
              pickupText: _getPickupText(uiState),
              isRideStart: uiState.isRideStart,
              isRideProcessing: uiState.isRideProcessing,
            ),
            const SizedBox(height: 16),
            PassengerInfoWidget(
              passengerName: "Danial",
              passengerAddress: uiState.rideRequest!.pickupAddress,
              distance:
                  '${uiState.rideRequest!.distance.toStringAsFixed(2)} km',
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  flex: 5,
                  child: MessageButtonWidget(onTap: presenter.navigateToChat),
                ),
                Expanded(
                  flex: 1,
                  child: CircularIconButton(
                    icon: Icons.phone,
                    onTap: presenter.navigateToCall,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TripStoppageInfoWidget(
              stoppageLocation: uiState.rideRequest!.dropoffAddress,
            ),
            uiState.isRideStart
                ? Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: ActionButton(
                    isPrimary: true,
                    text:
                        uiState.isRideProcessing
                            ? 'Trip Closure'
                            : 'Start Ride',
                    onPressed: () {
                      if (uiState.isRideProcessing) {
                        presenter.endRide();
                      } else {
                        presenter.startRide();
                      }
                    },
                  ),
                )
                : PaymentInfoWidget(fare: uiState.rideRequest!.fare),
          ],
        ),
      );
    });
  }
}
