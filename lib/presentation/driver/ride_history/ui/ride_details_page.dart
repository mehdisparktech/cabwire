import 'package:cabwire/core/config/app_assets.dart';
import 'package:cabwire/presentation/common/components/custom_app_bar.dart';
import 'package:cabwire/presentation/common/components/custom_text.dart';
import 'package:cabwire/presentation/driver/profile/widgets/common_image.dart';
import 'package:cabwire/presentation/driver/ride_history/widgets/driver_profile_widget.dart';
import 'package:cabwire/presentation/driver/ride_history/widgets/route_information_widget.dart';
import 'package:flutter/material.dart';

class RideDetailsScreen extends StatelessWidget {
  const RideDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Trip History',
        showBackButton: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Driver Profile
              const DriverProfileWidget(
                name: 'Santiago Dslab',
                address: 'Block B, Banasree, Dhaka.',
              ),

              const SizedBox(height: 24),

              // Vehicle Information
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Vehicle Information
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'DHK METRO HA 64-8549',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Volvo XC90',
                        style: TextStyle(fontSize: 14, color: Colors.black87),
                      ),
                    ],
                  ),

                  // Vehicle Image
                  CommonImage(
                    imageSrc: AppAssets.icCarImage,
                    imageType: ImageType.png,
                    height: 40,
                    width: 100,
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Trip Details
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Your Trip',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),

                  // Route Information
                  RouteInformationWidget(
                    pickupLocation: 'Block B, Banasree, Dhaka.',
                    dropoffLocation: 'Green Road, Dhanmondi, Dhaka.',
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Trip Statistics
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomText(
                    'Total Distance:',
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                  CustomText(
                    '10.5 km',
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ],
              ),

              const SizedBox(height: 12),

              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomText(
                    'Travel Time:',
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                  CustomText(
                    '45 Minutes',
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Payment Information
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
                  const Text(
                    'Cash Payment Received',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Feedback Section
              TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF001C60)),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF001C60)),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF001C60)),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  hintText: 'My valuable Feedback',
                  hintStyle: TextStyle(color: Colors.black45),
                ),

                maxLines: 4,
              ),

              // Buttons
            ],
          ),
        ),
      ),
    );
  }
}
