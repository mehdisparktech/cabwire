import 'package:cabwire/core/di/service_locator.dart';
import 'package:cabwire/core/external_libs/presentable_widget_builder.dart';
import 'package:cabwire/core/utility/utility.dart';
import 'package:cabwire/presentation/common/components/action_button.dart';
import 'package:cabwire/presentation/driver/home/presenter/driver_home_presenter.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class DriverHomePageOffline extends StatelessWidget {
  final DriverHomePresenter presenter = locate<DriverHomePresenter>();

  DriverHomePageOffline({super.key});

  @override
  Widget build(BuildContext context) {
    // This page is specifically for the offline state.
    // The PresentableWidgetBuilder will ensure UI updates if the state changes,
    // though for this specific "offline-only" view, it might not be strictly necessary
    // unless other parts of DriverHomeUiState affect this view.
    return PresentableWidgetBuilder(
      presenter: presenter,
      builder: () {
        // final uiState = presenter.currentUiState; // Get the current state
        return Scaffold(
          body: Stack(
            children: [
              _buildMap(presenter), // Pass presenter to map creation
              // Full screen overlay shadow
              Container(
                color: Colors.black.withOpacityInt(
                  0.3,
                ), // Corrected: withOpacity
                width: double.infinity,
                height: double.infinity,
              ),
              _buildOfflineCard(
                context,
                presenter,
              ), // Pass context and presenter
            ],
          ),
        );
      },
    );
  }

  Widget _buildMap(DriverHomePresenter presenter) {
    // The map controller is now managed by the presenter
    return GoogleMap(
      onMapCreated: presenter.onMapCreated, // Use presenter's method
      initialCameraPosition: CameraPosition(
        target:
            presenter
                .currentUiState
                .centerMapCoordinates, // From presenter's state
        zoom: 14.0,
      ),
      myLocationEnabled: true, // Or get from presenter's state if configurable
      myLocationButtonEnabled: false,
      zoomControlsEnabled: false,
      mapToolbarEnabled: false,
      // Map interaction disabled as per original code
      scrollGesturesEnabled: false,
      zoomGesturesEnabled: false,
      tiltGesturesEnabled: false,
      rotateGesturesEnabled: false,
    );
  }

  Widget _buildOfflineCard(
    BuildContext context,
    DriverHomePresenter presenter,
  ) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: SizedBox(
        // Added SizedBox to constrain width if needed, though infinity is set
        width: double.infinity,
        child: Container(
          // Removed redundant Stack, Container is enough
          width: double.infinity,
          margin: const EdgeInsets.all(
            16,
          ), // Added margin for better spacing from screen edges
          padding: const EdgeInsets.all(24), // Increased padding for content
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20), // Slightly more rounded
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacityInt(
                  0.1,
                ), // Corrected and softer shadow
                blurRadius: 10,
                offset: const Offset(0, -2),
                // spreadRadius: 2, // Optional: spread can make it look heavier
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Ready to drive?',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8), // Increased spacing
              const Text(
                'Switch to online mode to receive your first ride.',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                ), // Adjusted style
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24), // Increased spacing
              SizedBox(
                width: double.infinity,
                child: ActionButton(
                  text: 'Go Online',
                  isPrimary: true,
                  onPressed: () {
                    presenter.setOnlineAndNavigate(context);
                  },
                ),
              ),
              const SizedBox(height: 16), // Increased spacing
              SizedBox(
                width: double.infinity,
                child: ActionButton(
                  text: 'Not Now',
                  onPressed: () {
                    presenter.handleNotNow(context);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
