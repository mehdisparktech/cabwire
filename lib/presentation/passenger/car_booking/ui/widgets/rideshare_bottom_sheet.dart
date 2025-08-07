import 'package:cabwire/core/config/app_assets.dart';
import 'package:cabwire/core/config/app_screen.dart';
import 'package:cabwire/core/utility/utility.dart';
import 'package:cabwire/presentation/common/components/action_button.dart';
import 'package:cabwire/presentation/common/components/circular_icon_button.dart';
import 'package:cabwire/presentation/common/components/common_image.dart';
import 'package:cabwire/presentation/passenger/passenger_chat/ui/screens/passenger_chat_page.dart';
import 'package:cabwire/presentation/passenger/passenger_chat/ui/screens/passenger_audio_call_page.dart';
import 'package:cabwire/presentation/passenger/car_booking/presenter/ride_share_presenter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// --- Import widget files ---
import 'pickup_info_widget.dart';
import 'passenger_info_widget.dart';
import 'message_button_widget.dart';
import 'trip_stoppage_info_widget.dart';
import 'payment_info_widget.dart';

class RideshareBottomSheet extends StatelessWidget {
  final RideSharePresenter presenter;
  final String chatId;

  const RideshareBottomSheet({
    super.key,
    required this.presenter,
    required this.chatId,
  });

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
              pickupText:
                  uiState.isRideStart
                      ? 'Driver is on the way to pickup.'
                      : uiState.isRideProcessing && uiState.timerLeft > 0
                      ? 'Your Trip Will Complete In Approximately'
                      : uiState.isRideEnd
                      ? 'Your Trip Is Completed'
                      : 'Driver is on the way to pickup',
              isRideStart: uiState.isRideStart,
              isRideProcessing:
                  uiState.isRideProcessing ||
                  uiState
                      .isRideStart, // Show timer for both ride processing and ride start
            ),
            SizedBox(height: 16.px),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'DHK METRO HA 64-8549',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Volvo XC90',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  CommonImage(
                    imageSrc: AppAssets.icCarImage,
                    imageType: ImageType.png,
                    height: 40,
                    width: 100,
                    fill: BoxFit.contain,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),
            const PassengerInfoWidget(),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  flex: 5,
                  child: MessageButtonWidget(
                    onTap:
                        () => Get.to(() => PassengerChatPage(chatId: chatId)),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: CircularIconButton(
                    icon: Icons.phone,
                    onTap: () => Get.to(() => const PassengerAudioCallPage()),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TripStoppageInfoWidget(
              stoppageLocation:
                  uiState.rideResponse?.data.dropoffLocation.address ?? '',
            ),
            const SizedBox(height: 16),
            PaymentInfoWidget(
              paymentType:
                  uiState.rideResponse?.data.paymentMethod == 'stripe'
                      ? 'Online Payment'
                      : 'Cash Payment',
              amount: uiState.rideResponse?.data.fare.toString() ?? '',
            ),
            if (uiState.isRideProcessing || uiState.isRideEnd)
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: ActionButton(
                  isPrimary: true,
                  text: 'Trip Closure',
                  onPressed: presenter.handleTripClosureButtonPress,
                ),
              ),
          ],
        ),
      );
    });
  }
}
