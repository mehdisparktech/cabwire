// ride_details_page.dart
// (No significant changes from the previous combined presenter version for this file,
// ensure it uses presenter.currentUiState.selectedRideDetails)

import 'package:cabwire/core/config/app_assets.dart';
import 'package:cabwire/data/models/ride/ride_response_model.dart';
import 'package:cabwire/presentation/common/components/action_button.dart';
import 'package:cabwire/presentation/common/components/custom_app_bar.dart';
import 'package:cabwire/presentation/common/components/custom_text.dart';
import 'package:cabwire/presentation/common/components/common_image.dart';
import 'package:cabwire/presentation/passenger/car_booking/ui/screens/sucessfull_screen.dart';
import 'package:cabwire/presentation/passenger/passenger_history/ui/widgets/passenger_profile_widget.dart';
import 'package:cabwire/presentation/passenger/passenger_history/ui/widgets/passenger_route_information_widget.dart';
import 'package:flutter/material.dart';

class CarBookingDetailsScreen extends StatelessWidget {
  final RideResponseModel rideResponse;
  const CarBookingDetailsScreen({super.key, required this.rideResponse});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Trip Details',
        showBackButton: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              PassengerProfileWidget(
                name: 'John Doe',
                address: '123 Main St, Anytown, USA',
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    // Added Expanded for long vehicle numbers
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
                  const SizedBox(width: 10), // Spacing
                  CommonImage(
                    imageSrc: AppAssets.icCarImage,
                    imageType: ImageType.png,
                    height: 40,
                    width: 100,
                    fill: BoxFit.contain, // Ensure image fits
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Your Trip',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  PassengerRouteInformationWidget(
                    pickupLocation: rideResponse.data.pickupLocation.address,
                    dropoffLocation: rideResponse.data.dropoffLocation.address,
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const CustomText(
                    'Total Distance:',
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                  CustomText(
                    '${rideResponse.data.distance} km',
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const CustomText(
                    'Travel Time:',
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                  CustomText(
                    '${rideResponse.data.duration} min',
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.receipt_long, size: 20),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    // Added Expanded for long payment methods
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Cash Payment Received',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          '\$ ${rideResponse.data.fare.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              TextField(
                controller: TextEditingController(),
                readOnly: false,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: const BorderSide(color: Color(0xFF001C60)),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Color(0xFF001C60)),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Color(0xFF001C60)),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  hintText: 'Enter your valuable feedback',
                  hintStyle: const TextStyle(color: Colors.black45),
                ),
                maxLines: 4,
              ),

              const SizedBox(height: 40),

              // if (uiState.viewMode == PassengerHistoryViewMode.details &&
              //     details != null &&
              //     (details.existingFeedback == null ||
              //         details.existingFeedback!.isEmpty))
              //   ActionButton(
              //     text: 'Add Feedback',
              //     onPressed: presenter.showFeedbackFormForSelectedRide,
              //   ),

              // if (uiState.viewMode == PassengerHistoryViewMode.feedback)
              //   ActionButton(
              //     isPrimary: true,
              //     text: 'Submit Feedback',
              //     onPressed: presenter.submitFeedback,
              //   ),
              ActionButton(
                isPrimary: true,
                text: 'Submit Feedback',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SucessfullScreen()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
