import 'package:cabwire/core/config/app_assets.dart';
import 'package:cabwire/data/models/ride_completed_response_model.dart';
import 'package:cabwire/presentation/common/components/action_button.dart';
import 'package:cabwire/presentation/common/components/common_image.dart';
import 'package:cabwire/presentation/common/components/custom_app_bar.dart';
import 'package:cabwire/presentation/common/components/custom_text.dart';
import 'package:cabwire/presentation/driver/main/ui/screens/driver_main_page.dart';
import 'package:cabwire/presentation/driver/ride_history/ui/widgets/driver_profile_widget.dart';
import 'package:cabwire/presentation/driver/ride_history/ui/widgets/route_information_widget.dart';
import 'package:flutter/material.dart';

class CarBookingDetailsScreen extends StatelessWidget {
  final RideCompletedResponseModel rideCompletedResponse;
  const CarBookingDetailsScreen({
    super.key,
    required this.rideCompletedResponse,
  });

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
              DriverProfileWidget(
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
                  DriverRouteInformationWidget(
                    pickupLocation:
                        rideCompletedResponse.data?.pickupLocation?.address ??
                        '',
                    dropoffLocation:
                        rideCompletedResponse.data?.dropoffLocation?.address ??
                        '',
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
                    '${rideCompletedResponse.data?.distance.toString()} km',
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
                    rideCompletedResponse.data?.duration.toString() ?? '',
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
                          '\$ ${rideCompletedResponse.data?.fare.toString() ?? ''}',
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
            ],
          ),
        ),
      ),
      bottomSheet: ActionButton(
        isPrimary: true,
        text: 'Trip Completed',
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => DriverMainPage()),
          );
        },
      ),
    );
  }
}
