import 'package:cabwire/presentation/common/components/custom_app_bar.dart';
import 'package:cabwire/presentation/driver/ride_history/ui/ride_details_page.dart';
import 'package:cabwire/presentation/driver/ride_history/widgets/ride_card.dart';
import 'package:flutter/material.dart';

class RideHistoryPage extends StatelessWidget {
  const RideHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Trip History',
        showBackButton: true,
        elevation: 0,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            RideCard(
              driverName: 'Santiago Dslab',
              driverLocation: 'Block B, Banasree, Dhaka.',
              pickupLocation: 'Block B, Banasree, Dhaka.',
              dropoffLocation: 'Green Road, Dhanmondi, Dhaka.',
              distance: '10.5 km',
              duration: '45 Minutes',
              isCarRide: false,
              page: RideDetailsScreen(),
            ),
            SizedBox(height: 16),
            RideCard(
              driverName: 'Santiago Dslab',
              driverLocation: 'Block B, Banasree, Dhaka.',
              pickupLocation: 'Block B, Banasree, Dhaka.',
              dropoffLocation: 'Green Road, Dhanmondi, Dhaka.',
              distance: '10.5 km',
              duration: '45 Minutes',
              isCarRide: true,
              page: RideDetailsScreen(),
            ),
          ],
        ),
      ),
    );
  }
}
