import 'package:cabwire/core/di/service_locator.dart';
import 'package:cabwire/core/external_libs/presentable_widget_builder.dart';
import 'package:cabwire/data/models/ride/ride_request_model.dart';
import 'package:cabwire/presentation/driver/home/presenter/rideshare_presenter.dart';
import 'package:cabwire/presentation/driver/home/ui/widgets/rideshare_bottom_sheet.dart';
import 'package:cabwire/presentation/driver/home/ui/widgets/top_navigation_bar.dart';
import 'package:cabwire/presentation/driver/home/ui/widgets/driver_rideshare_showcase.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:get/get.dart';

class DriverRidesharePage extends StatefulWidget {
  final RideRequestModel rideRequest;
  final bool rideProgress;
  final String chatId;

  const DriverRidesharePage({
    super.key,
    required this.rideRequest,
    this.rideProgress = false,
    required this.chatId,
  });

  @override
  State<DriverRidesharePage> createState() => _DriverRidesharePageState();
}

class _DriverRidesharePageState extends State<DriverRidesharePage> {
  /// Check if tutorial should be shown and start it with proper ShowCase context
  Future<void> _checkAndShowTutorialWithContext(
    BuildContext showcaseContext,
  ) async {
    final shouldShow = await DriverRideshareShowcase.shouldShowTutorial();
    if (shouldShow && mounted && showcaseContext.mounted) {
      // Wait for ShowCaseWidget to be ready
      await _waitForShowCaseReady(showcaseContext);
      if (mounted && showcaseContext.mounted) {
        try {
          DriverRideshareShowcase.startShowcase(showcaseContext);
          await DriverRideshareShowcase.markTutorialCompleted();
        } catch (e) {
          if (kDebugMode) {
            print('Failed to start tutorial: $e');
          }
        }
      }
    }
  }

  /// Wait for ShowCaseWidget to be ready with timeout
  Future<void> _waitForShowCaseReady(BuildContext showcaseContext) async {
    const maxAttempts = 10;
    const delay = Duration(milliseconds: 200);

    for (int i = 0; i < maxAttempts; i++) {
      if (!mounted || !showcaseContext.mounted) {
        if (kDebugMode) {
          print('Context no longer mounted, stopping wait');
        }
        return;
      }

      if (DriverRideshareShowcase.isShowCaseReady(showcaseContext)) {
        if (kDebugMode) {
          print('ShowCaseWidget ready after ${i + 1} attempts');
        }
        return;
      }
      await Future.delayed(delay);
    }
    if (kDebugMode) {
      print('ShowCaseWidget not ready after $maxAttempts attempts');
    }
  }

  @override
  Widget build(BuildContext context) {
    final presenter = locate<RidesharePresenter>();
    return ShowCaseWidget(
      builder: (showcaseContext) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _checkAndShowTutorialWithContext(showcaseContext);
          });
        });

        return Scaffold(
          body: SafeArea(
            child: PresentableWidgetBuilder(
              presenter: presenter,
              builder: () {
                presenter.setRideRequest(widget.rideRequest, widget.chatId);
                if (widget.rideProgress) {
                  presenter.setRideProgress(true);
                }
                final uiState = presenter.currentUiState;
                return Stack(
                  children: [
                    // Map with enhanced features
                    DriverRideshareShowcase.buildMapShowcase(
                      child: _buildMap(presenter, uiState),
                    ),

                    // Top navigation bar
                    DriverRideshareShowcase.buildTopNavigationShowcase(
                      child: TopNavigationBar(
                        title: 'Rideshare',
                        subtitle: 'Rideshare',
                        distance:
                            '${uiState.rideRequest!.distance.toStringAsFixed(1)} km',
                        address:
                            uiState.isRideProcessing
                                ? uiState.rideRequest!.dropoffAddress
                                : uiState.rideRequest!.pickupAddress,
                        onBackPressed: () => Get.back(),
                      ),
                    ),

                    // Bottom sheet
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: RideshareBottomSheet(presenter: presenter),
                    ),
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }

  Widget _buildMap(RidesharePresenter presenter, uiState) {
    return Obx(() {
      final currentUiState = presenter.currentUiState;

      return GoogleMap(
        onMapCreated: presenter.onMapCreated,
        initialCameraPosition: CameraPosition(
          target: uiState.mapCenter ?? const LatLng(23.8103, 90.4125),
          zoom: 14.0,
        ),
        myLocationEnabled: true,
        myLocationButtonEnabled: false,
        zoomControlsEnabled: false,
        mapToolbarEnabled: false,
        scrollGesturesEnabled: true,
        zoomGesturesEnabled: true,
        tiltGesturesEnabled: true,
        rotateGesturesEnabled: true,
        markers: currentUiState.markers,
        polylines: {
          if (currentUiState.polylineCoordinates != null)
            Polyline(
              polylineId: const PolylineId('route'),
              points: currentUiState.polylineCoordinates!,
              color: Colors.blue,
              width: 5,
              patterns: [PatternItem.dash(20), PatternItem.gap(5)],
              endCap: Cap.roundCap,
              startCap: Cap.roundCap,
            ),
        },
      );
    });
  }
}
