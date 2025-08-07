import 'package:cabwire/core/config/api/api_end_point.dart';
import 'package:cabwire/core/config/app_assets.dart';
import 'package:cabwire/core/config/app_screen.dart';
import 'package:cabwire/core/static/ui_const.dart';
import 'package:cabwire/data/services/storage/storage_services.dart';
import 'package:cabwire/presentation/common/components/action_button.dart';
import 'package:cabwire/presentation/common/components/circular_icon_button.dart';
import 'package:cabwire/presentation/common/components/common_image.dart';
import 'package:cabwire/presentation/common/components/custom_text.dart';
import 'package:cabwire/presentation/driver/home/presenter/driver_home_presenter.dart';
import 'package:cabwire/presentation/driver/home/presenter/driver_home_ui_state.dart';
import 'package:cabwire/data/models/ride/ride_request_model.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cabwire/core/di/service_locator.dart';
import 'package:cabwire/core/external_libs/presentable_widget_builder.dart';
import 'package:intl/intl.dart';

class DriverHomePage extends StatefulWidget {
  const DriverHomePage({super.key});

  @override
  State<DriverHomePage> createState() => _DriverHomePageState();
}

class _DriverHomePageState extends State<DriverHomePage>
    with AutomaticKeepAliveClientMixin {
  final DriverHomePresenter presenter = locate<DriverHomePresenter>();

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    // Any initialization if needed
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Refresh data when screen becomes visible
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return PresentableWidgetBuilder(
      presenter: presenter,
      builder: () {
        final uiState = presenter.currentUiState;
        return Scaffold(
          appBar: _buildAppBar(context, presenter),
          body: Stack(
            children: [
              _buildMap(presenter, uiState),
              _buildStackedCards(context, presenter, uiState),
            ],
          ),
        );
      },
    );
  }

  AppBar _buildAppBar(BuildContext context, DriverHomePresenter presenter) {
    final uiState = presenter.currentUiState;

    return AppBar(
      toolbarHeight: 80.px,
      leading: Padding(
        padding: EdgeInsets.all(4.px),
        child: CircleAvatar(
          backgroundColor: Colors.white,
          child: ClipOval(
            child: CommonImage(
              imageSrc: ApiEndPoint.imageUrl + LocalStorage.myImage,
              imageType: ImageType.network,
              width: 40,
              height: 40,
              fill: BoxFit.cover,
            ),
          ),
        ),
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: CustomText(
                  'Hello ${uiState.userName}',
                  fontWeight: FontWeight.bold,
                ),
              ),
              gapW5,
              Icon(
                Icons.circle,
                size: 10,
                color: uiState.isOnline ? Colors.green : Colors.grey,
              ),
            ],
          ),
          CustomText(
            uiState.isOnline ? 'You\'re Now Online' : 'You\'re Offline',
            fontSize: 12.px,
          ),
        ],
      ),
      actions: [
        Transform.scale(
          scale: 0.75,
          child: Switch(
            padding: EdgeInsets.zero,
            value: uiState.isOnline,
            onChanged: (value) {
              presenter.toggleOnlineStatus(value);
            },
          ),
        ),
        gapW10,
        CircularIconButton(
          hMargin: 10.0,
          imageSrc: AppAssets.icNotifcationActive,
          onTap: presenter.goToNotifications,
        ),
      ],
    );
  }

  Widget _buildMap(DriverHomePresenter presenter, DriverHomeUiState uiState) {
    return GoogleMap(
      onMapCreated: presenter.onMapCreated,
      initialCameraPosition: CameraPosition(
        target: uiState.currentLocation ?? uiState.centerMapCoordinates,
        zoom: 18.0,
      ),
      myLocationEnabled: true,
      myLocationButtonEnabled: true,
      zoomControlsEnabled: false,
      mapToolbarEnabled: false,
      mapType: MapType.normal,
      markers: {
        // Marker(
        //   markerId: MarkerId('source'),
        //   position: uiState.sourceMapCoordinates,
        //   icon: uiState.sourceIcon,
        // ),
        // Marker(
        //   markerId: MarkerId('destination'),
        //   position: uiState.destinationMapCoordinates,
        //   icon: uiState.destinationIcon,
        // ),
        if (uiState.currentLocation != null)
          Marker(
            markerId: MarkerId('currentLocation'),
            position: uiState.currentLocation!,
            icon: uiState.currentLocationIcon,
          ),
      },
      // polylines: {
      //   Polyline(
      //     polylineId: PolylineId('polyline'),
      //     points: uiState.polylineCoordinates ?? [],
      //     color: Colors.black,
      //     width: 3,
      //   ),
      // },
    );
  }

  Widget _buildStackedCards(
    BuildContext context,
    DriverHomePresenter presenter,
    DriverHomeUiState uiState,
  ) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: EdgeInsets.only(bottom: 20.px),
        child: SizedBox(
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              if (uiState.isOnline) ...[
                for (int i = 0; i < uiState.rideRequests.length; i++) ...[
                  Positioned(
                    bottom: (40 - i * 20).px,
                    child: _rideCard(
                      context: context,
                      presenter: presenter,
                      rideRequest: uiState.rideRequests[i],
                      index: i,
                    ),
                  ),
                ],
                if (uiState.rideRequests.isEmpty) _noRideRequestsCard(context),
              ],
              if (!uiState.isOnline) ...[_rideOfflineCard(context, presenter)],
            ],
          ),
        ),
      ),
    );
  }

  Widget _rideCard({
    required BuildContext context,
    required DriverHomePresenter presenter,
    required RideRequestModel rideRequest,
    required int index,
  }) {
    // Format the distance to show 2 decimal places
    final formattedDistance = rideRequest.distance.toStringAsFixed(2);

    // Format the duration
    final duration = "${rideRequest.duration} min";

    // Format the fare
    final formatCurrency = NumberFormat.currency(
      locale: 'en_US',
      symbol: '\$',
      decimalDigits: 0,
    );
    final formattedFare = formatCurrency.format(rideRequest.fare);

    // Calculate estimated rating (just for UI purposes, in real app would come from API)
    final int rating = 4 + (index % 2);
    final int ratingCount = 5 + index * 3;

    // Get passenger name placeholder (in real app would come from API)
    final passengerName = "Passenger ${index + 1}";

    return Container(
      width: MediaQuery.of(context).size.width * 0.85,
      padding: EdgeInsets.all(16.px),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.px),
        boxShadow: const [
          BoxShadow(color: Colors.black26, blurRadius: 6, offset: Offset(0, 4)),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          gapH10,
          Row(
            children: [
              CircleAvatar(
                backgroundImage: AssetImage(AppAssets.icProfileImage),
              ),
              gapW12,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomText(passengerName, fontWeight: FontWeight.bold),
                        CustomText("$formattedDistance km"),
                      ],
                    ),
                    Row(
                      children: [
                        Row(
                          children: List.generate(
                            5,
                            (index) => Icon(
                              Icons.star,
                              size: 14,
                              color:
                                  index < rating
                                      ? Colors.amber
                                      : Colors.grey.shade300,
                            ),
                          ),
                        ),
                        CustomText(' $rating ($ratingCount)', fontSize: 12.px),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (rideRequest.service == 'emergency-car') ...[
            gapH8,
            Divider(color: Colors.grey.shade300),
            CustomText(
              'Emergency Car Booking',
              fontWeight: FontWeight.bold,
              fontSize: 16.px,
              color: Theme.of(context).primaryColor,
            ),
            CustomText(
              'An urgent ride request is waiting. Accept to provide immediate service.',
              fontWeight: FontWeight.w500,
            ),
            gapH8,
          ],
          gapH8,
          Divider(color: Colors.grey.shade300),
          CustomText('PICK UP', fontSize: 12.px, color: Colors.grey),
          CustomText(rideRequest.pickupAddress, fontWeight: FontWeight.w500),
          gapH8,
          CustomText('DROP OFF', fontSize: 12.px, color: Colors.grey),
          CustomText(rideRequest.dropoffAddress, fontWeight: FontWeight.w500),
          gapH8,
          Divider(color: Colors.grey.shade300),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    'ESTIMATED FARE',
                    fontSize: 12.px,
                    color: Colors.grey,
                  ),
                  CustomText(
                    formattedFare,
                    fontWeight: FontWeight.bold,
                    fontSize: 16.px,
                    color: Theme.of(context).primaryColor,
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText('DURATION', fontSize: 12.px, color: Colors.grey),
                  CustomText(duration, fontWeight: FontWeight.w500),
                ],
              ),
            ],
          ),
          gapH8,
          Divider(color: Colors.grey.shade300),
          Row(
            children: [
              Expanded(
                child: ActionButton(
                  text: 'Decline',
                  isLoading: presenter.currentUiState.isLoading,
                  onPressed: () {
                    presenter.declineRide(rideRequest.id);
                  },
                ),
              ),
              gapW12,
              Expanded(
                child: ActionButton(
                  text: 'Accept',
                  isPrimary: true,
                  isLoading: presenter.currentUiState.isLoading,
                  onPressed: () {
                    presenter.acceptRide(rideRequest.rideId);
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _noRideRequestsCard(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.85,
      padding: EdgeInsets.all(20.px),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.px),
        boxShadow: const [
          BoxShadow(color: Colors.black26, blurRadius: 6, offset: Offset(0, 4)),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CustomText(
            'No ride requests',
            fontSize: 18.px,
            fontWeight: FontWeight.w700,
          ),
          gapH10,
          CustomText(
            'You\'re online. Waiting for ride requests...',
            fontWeight: FontWeight.w500,
            textAlign: TextAlign.center,
          ),
          gapH12,
        ],
      ),
    );
  }

  Widget _rideOfflineCard(BuildContext context, DriverHomePresenter presenter) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      padding: EdgeInsets.all(20.px),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16.px),
        boxShadow: const [
          BoxShadow(color: Colors.black26, blurRadius: 6, offset: Offset(0, 4)),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CustomText(
            'Ready to drive?',
            fontSize: 18.px,
            fontWeight: FontWeight.w700,
          ),
          gapH10,
          CustomText(
            'Your status is offline. Please go online to get your next ride.',
            fontWeight: FontWeight.w500,
            textAlign: TextAlign.center,
          ),
          gapH12,
          ActionButton(
            text: 'Go Online',
            isPrimary: true,
            onPressed: presenter.goOnline,
          ),
          gapH12,
          SizedBox(
            width: double.infinity,
            child: ActionButton(
              text: 'Not Now',
              onPressed: () => presenter.handleNotNowPassenger(context),
            ),
          ),
        ],
      ),
    );
  }
}
