// ride_history_page.dart
// (No significant changes from the previous combined presenter version for this file)
import 'package:cabwire/core/di/service_locator.dart';
import 'package:cabwire/core/external_libs/presentable_widget_builder.dart';
import 'package:cabwire/presentation/common/components/custom_app_bar.dart';
import 'package:cabwire/presentation/driver/ride_history/presenter/ride_history_presenter.dart';
import 'package:cabwire/presentation/driver/ride_history/ui/widgets/ride_card.dart';
import 'package:flutter/material.dart';

class RideHistoryPage extends StatelessWidget {
  final RideHistoryPresenter presenter = locate<RideHistoryPresenter>();

  RideHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Trip History',
        showBackButton: true,
        elevation: 0,
      ),
      body: PresentableWidgetBuilder(
        presenter: presenter,
        builder: () {
          final uiState = presenter.currentUiState;

          if (uiState.isLoading && uiState.rides.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (uiState.rides.isEmpty && !uiState.isLoading) {
            return const Center(child: Text('No trip history found.'));
          }

          return SafeArea(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: uiState.rides.length,
              itemBuilder: (context, index) {
                final ride = uiState.rides[index];
                return Padding(
                  padding: EdgeInsets.only(
                    bottom: (index == uiState.rides.length - 1) ? 0 : 16.0,
                  ),
                  child: RideCard(
                    driverName: ride.driverName,
                    driverLocation: ride.driverLocation,
                    pickupLocation: ride.pickupLocation,
                    dropoffLocation: ride.dropoffLocation,
                    distance: ride.distance,
                    duration: ride.duration,
                    isCarRide: ride.isCarRide,
                    onTap: () {
                      presenter.selectRideAndShowDetails(ride.id);
                    },
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
