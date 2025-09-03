import 'package:cabwire/core/config/api/api_end_point.dart';
import 'package:cabwire/core/config/app_assets.dart';
import 'package:cabwire/core/config/app_screen.dart';
import 'package:cabwire/core/di/service_locator.dart';
import 'package:cabwire/core/enum/service_type.dart';
import 'package:cabwire/core/external_libs/presentable_widget_builder.dart';
import 'package:cabwire/data/services/storage/storage_services.dart';
import 'package:cabwire/domain/entities/passenger/passenger_service_entity.dart';
import 'package:cabwire/presentation/common/components/circular_icon_button.dart';
import 'package:cabwire/presentation/common/components/common_image.dart';
import 'package:cabwire/presentation/common/components/custom_services_card.dart';
import 'package:cabwire/presentation/passenger/home/presenter/presenter_home_presenter.dart';
import 'package:cabwire/presentation/passenger/home/ui/screens/passenger_search_destination_page.dart';
import 'package:cabwire/presentation/passenger/home/ui/widgets/ride_booking_widget.dart';
import 'package:cabwire/presentation/passenger/home/ui/widgets/passenger_home_showcase.dart';
import 'package:cabwire/presentation/passenger/passenger_notification/ui/screens/passenger_notification_page.dart';
import 'package:cabwire/presentation/passenger/passenger_services/ui/screens/package_delivery/payment_method_screen.dart';
import 'package:cabwire/presentation/passenger/passenger_services/ui/screens/rental_car_welcome_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:showcaseview/showcaseview.dart';

class PassengerHomeScreen extends StatefulWidget {
  const PassengerHomeScreen({super.key});

  @override
  State<PassengerHomeScreen> createState() => _PassengerHomeScreenState();
}

class _PassengerHomeScreenState extends State<PassengerHomeScreen>
    with AutomaticKeepAliveClientMixin {
  final PassengerHomePresenter presenter = locate<PassengerHomePresenter>();
  BuildContext? _showcaseContext;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    // Refresh profile data when screen is loaded
    WidgetsBinding.instance.addPostFrameCallback((_) {
      presenter.refreshUserProfile();
    });
  }

  /// Check if tutorial should be shown and start it with proper ShowCase context
  Future<void> _checkAndShowTutorialWithContext(
    BuildContext showcaseContext,
  ) async {
    final shouldShow = await PassengerHomeShowcase.shouldShowTutorial();
    if (shouldShow && mounted && showcaseContext.mounted) {
      // Wait for ShowCaseWidget to be ready
      await _waitForShowCaseReady(showcaseContext);
      if (mounted && showcaseContext.mounted) {
        try {
          PassengerHomeShowcase.startShowcase(showcaseContext);
          await PassengerHomeShowcase.markTutorialCompleted();
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
      // Check if context is still valid before using it
      if (!mounted || !showcaseContext.mounted) {
        if (kDebugMode) {
          print('Context no longer mounted, stopping wait');
        }
        return;
      }

      if (PassengerHomeShowcase.isShowCaseReady(showcaseContext)) {
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

  /// Manually start the tutorial (for testing or user request)
  void startTutorial() {
    if (_showcaseContext != null && _showcaseContext!.mounted) {
      PassengerHomeShowcase.startShowcase(_showcaseContext!);
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Refresh profile data when screen becomes visible
    presenter.refreshUserProfile();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ShowCaseWidget(
      builder: (showcaseContext) {
        // Store the showcase context for later use
        _showcaseContext = showcaseContext;
        // Schedule tutorial check after the ShowCaseWidget is built
        WidgetsBinding.instance.addPostFrameCallback((_) {
          // Wait for the next frame to ensure everything is rendered
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _checkAndShowTutorialWithContext(showcaseContext);
          });
        });

        return PresentableWidgetBuilder(
          presenter: presenter,
          builder: () {
            return Scaffold(
              appBar: _buildAppBar(showcaseContext),
              body: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.px,
                      vertical: 16.px,
                    ),
                    child: PassengerHomeShowcase.buildRideBookingShowcase(
                      child: RideBookingWidget(),
                    ),
                  ),
                  Expanded(
                    child: Stack(
                      children: [
                        Positioned(
                          top: 200.px, // Adjust based on services widget height
                          bottom: 0.px, // 10px from bottom for overlap effect
                          left: 0.px,
                          right: 0.px,
                          child: _buildMap(showcaseContext),
                        ),
                        Positioned(
                          top: 0,
                          left: 0,
                          right: 0,
                          child: PassengerHomeShowcase.buildServicesShowcase(
                            child: _buildServicesWidget(
                              showcaseContext,
                              presenter.currentUiState.services,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      toolbarHeight: 80,
      centerTitle: false,
      leading: Padding(
        padding: EdgeInsets.all(4.px),
        child: PassengerHomeShowcase.buildProfileShowcase(
          child: CircleAvatar(
            radius: 20.px,
            backgroundColor: Colors.grey.shade200,
            child: ClipOval(
              child: CommonImage(
                fill: BoxFit.cover,
                height: 40.px,
                width: 40.px,
                imageType: ImageType.network,
                imageSrc:
                    presenter
                                .currentUiState
                                .userProfile
                                ?.avatarUrl
                                .isNotEmpty ==
                            true
                        ? presenter.currentUiState.userProfile!.avatarUrl
                        : ApiEndPoint.imageUrl + LocalStorage.myImage,
              ),
            ),
          ),
        ),
      ),
      title: PassengerHomeShowcase.buildLocationShowcase(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hello ${presenter.currentUiState.userProfile?.name ?? 'User'}',
              style: TextStyle(fontSize: 16.px, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 4.px),
            Text(
              presenter.currentUiState.currentAddress ?? 'Loading...',
              style: TextStyle(fontSize: 12.px),
              maxLines: 2,
            ),
          ],
        ),
      ),
      actions: [
        PassengerHomeShowcase.buildNotificationShowcase(
          child: CircularIconButton(
            hMargin: 20.px,
            imageSrc: AppAssets.icNotifcationActive,
            onTap: () => Get.to(() => PassengerNotificationScreen()),
          ),
        ),
      ],
    );
  }

  Widget _buildServicesWidget(
    BuildContext context,
    List<PassengerServiceEntity> services,
  ) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.px),
      child: CustomServicesCard(
        showSeeAllButton: true,
        services:
            services
                .take(4)
                .map(
                  (service) => Service(
                    title: service.serviceName,
                    imageUrl: service.image,
                    fontWeight: FontWeight.w600,
                    onTap: () {
                      _navigateToService(context, service);
                    },
                  ),
                )
                .toList(),
      ),
    );
  }

  Widget _buildMap(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24.px),
          topRight: Radius.circular(24.px),
        ),
        color: Colors.grey.shade200,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24.px),
          topRight: Radius.circular(24.px),
        ),
        child: GoogleMap(
          onMapCreated: (controller) {}, // Use presenter's method
          initialCameraPosition: CameraPosition(
            target: LatLng(23.8103, 90.4125),
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
        ),
      ),
    );
  }

  void _navigateToService(
    BuildContext context,
    PassengerServiceEntity service,
  ) {
    switch (service.serviceName) {
      case 'car':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (context) => PassengerSearchDestinationScreen(
                  serviceType: ServiceType.carBooking,
                  serviceId: service.id,
                ),
          ),
        );
        break;
      case 'emergency-car':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (context) => PassengerSearchDestinationScreen(
                  serviceType: ServiceType.emergencyCar,
                  serviceId: service.id,
                ),
          ),
        );
        break;
      case 'rental-car':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RentalCarWelcomeScreen(serviceId: service.id),
          ),
        );
        break;
      case 'package':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (context) => PackagePaymentMethodScreen(serviceId: service.id),
          ),
        );
        break;
      case 'cabwire-share':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (context) => PassengerSearchDestinationScreen(
                  serviceType: ServiceType.cabwireShare,
                  serviceId: service.id,
                ),
          ),
        );
        break;
      default:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (context) =>
                    PassengerSearchDestinationScreen(serviceId: service.id),
          ),
        );
    }
  }
}
