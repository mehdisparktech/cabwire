// ride_details_page.dart
// (No significant changes from the previous combined presenter version for this file,
// ensure it uses presenter.currentUiState.selectedRideDetails)

import 'package:cabwire/core/config/app_assets.dart';
import 'package:cabwire/core/di/service_locator.dart';
import 'package:cabwire/core/external_libs/presentable_widget_builder.dart';
import 'package:cabwire/presentation/common/components/action_button.dart';
import 'package:cabwire/presentation/common/components/custom_app_bar.dart';
import 'package:cabwire/presentation/common/components/custom_text.dart';
import 'package:cabwire/presentation/common/components/common_image.dart';
import 'package:cabwire/presentation/driver/ride_history/presenter/ride_history_ui_state.dart';
import 'package:cabwire/presentation/driver/ride_history/widgets/driver_profile_widget.dart';
import 'package:cabwire/presentation/driver/ride_history/widgets/route_information_widget.dart';
import 'package:cabwire/presentation/driver/ride_history/presenter/ride_history_presenter.dart';
import 'package:flutter/material.dart';

class RideDetailsScreen extends StatelessWidget {
  final RideHistoryPresenter presenter = locate<RideHistoryPresenter>();

  RideDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        presenter.goBackFromDetails();
        return false;
      },
      child: Scaffold(
        appBar: CustomAppBar(
          title: 'Trip Details',
          showBackButton: true,
          elevation: 0,
        ),
        body: PresentableWidgetBuilder(
          presenter: presenter,
          builder: () {
            final uiState = presenter.currentUiState;
            final details = uiState.selectedRideDetails;

            if (uiState.isLoading && details == null) {
              return const Center(child: CircularProgressIndicator());
            }

            if (details == null) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (ModalRoute.of(context)?.isCurrent ?? false) {
                  // Only pop if current
                  presenter.goBackFromDetails();
                }
              });
              return const Center(child: Text('Loading details or error...'));
            }

            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DriverProfileWidget(
                      name: details.driverName,
                      address: details.driverLocation,
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
                                details.vehicleNumber ?? 'N/A',
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.5,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                details.vehicleModel ?? 'N/A',
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
                          imageSrc:
                              details.vehicleImageUrl ?? AppAssets.icCarImage,
                          imageType:
                              (details.vehicleImageUrl ?? "").startsWith('http')
                                  ? ImageType.network
                                  : ImageType.png,
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
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        RouteInformationWidget(
                          pickupLocation: details.pickupLocation,
                          dropoffLocation: details.dropoffLocation,
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
                          details.distance,
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
                          details.duration,
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
                                details.paymentMethod ?? 'N/A',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(width: 12),
                              Text(
                                '\$100',
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

                    if (uiState.viewMode == RideViewMode.feedback ||
                        (uiState.viewMode == RideViewMode.details &&
                            details.existingFeedback != null &&
                            details.existingFeedback!.isNotEmpty))
                      TextField(
                        controller: presenter.feedbackController,
                        readOnly:
                            uiState.viewMode == RideViewMode.details &&
                            details.existingFeedback != null,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Color(0xFF001C60),
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Color(0xFF001C60),
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Color(0xFF001C60),
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          hintText:
                              uiState.viewMode == RideViewMode.feedback
                                  ? 'Enter your valuable feedback'
                                  : 'Your Feedback',
                          hintStyle: const TextStyle(color: Colors.black45),
                        ),
                        maxLines: 4,
                      ),

                    const SizedBox(height: 40),

                    if (uiState.viewMode == RideViewMode.details &&
                        (details.existingFeedback == null ||
                            details.existingFeedback!.isEmpty))
                      ActionButton(
                        text: 'Add Feedback',
                        onPressed: presenter.showFeedbackFormForSelectedRide,
                      ),

                    if (uiState.viewMode == RideViewMode.feedback)
                      ActionButton(
                        isPrimary: true,
                        text: 'Submit Feedback',
                        onPressed: presenter.submitFeedback,
                      ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
