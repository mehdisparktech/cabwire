import 'package:cabwire/core/config/app_assets.dart';
import 'package:cabwire/core/config/app_screen.dart';
import 'package:cabwire/core/static/ui_const.dart';
import 'package:cabwire/presentation/common/components/action_button.dart';
import 'package:cabwire/presentation/common/components/circular_icon_button.dart';
import 'package:cabwire/presentation/common/components/custom_text.dart';
import 'package:cabwire/presentation/driver/home/presenter/driver_home_presenter.dart';
import 'package:cabwire/presentation/driver/home/presenter/driver_home_ui_state.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cabwire/core/di/service_locator.dart';
import 'package:cabwire/core/external_libs/presentable_widget_builder.dart';

class DriverHomePage extends StatelessWidget {
  final DriverHomePresenter presenter = locate<DriverHomePresenter>();

  DriverHomePage({super.key});

  @override
  Widget build(BuildContext context) {
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
          backgroundImage: AssetImage(AppAssets.icProfileImage),
        ),
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomText(
                'Hello ${uiState.userName}',
                fontWeight: FontWeight.bold,
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
      myLocationEnabled: false,
      myLocationButtonEnabled: true,
      zoomControlsEnabled: false,
      mapToolbarEnabled: false,
      markers: {
        Marker(
          markerId: MarkerId('source'),
          position: uiState.sourceMapCoordinates,
          icon: uiState.sourceIcon,
        ),
        Marker(
          markerId: MarkerId('destination'),
          position: uiState.destinationMapCoordinates,
          icon: uiState.destinationIcon,
        ),
        if (uiState.currentLocation != null)
          Marker(
            markerId: MarkerId('currentLocation'),
            position: uiState.currentLocation!,
            icon: uiState.currentLocationIcon,
          ),
      },
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
                Positioned(
                  bottom: 40.px,
                  child: _rideCard(
                    context: context,
                    presenter: presenter,
                    name: 'Passenger 1',
                    rideId: 'ride1',
                    distance: '3.3 km',
                    pickupLocation: 'Block B, Banasree, Dhaka.',
                    profileImageUrl: AppAssets.icProfileImage,
                    rating: 5,
                    ratingCount: 5,
                  ),
                ),
                Positioned(
                  bottom: 20.px,
                  child: _rideCard(
                    context: context,
                    presenter: presenter,
                    name: 'Passenger 2',
                    rideId: 'ride2',
                    distance: '2.5 km',
                    pickupLocation: 'Block C, Mirpur, Dhaka.',
                    profileImageUrl: AppAssets.icProfileImage,
                    rating: 4,
                    ratingCount: 12,
                  ),
                ),
                Positioned(
                  bottom: 0.px,
                  child: _rideCard(
                    context: context,
                    presenter: presenter,
                    name: 'Passenger 3',
                    rideId: 'ride3',
                    distance: '5.1 km',
                    pickupLocation: 'Block D, Gulshan, Dhaka.',
                    profileImageUrl: AppAssets.icProfileImage,
                    rating: 5,
                    ratingCount: 8,
                  ),
                ),
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
    required String name,
    required String rideId,
    required String distance,
    required String pickupLocation,
    required String profileImageUrl,
    required int rating,
    required int ratingCount,
  }) {
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
              CircleAvatar(backgroundImage: AssetImage(profileImageUrl)),
              gapW12,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomText(name, fontWeight: FontWeight.bold),
                        CustomText(distance),
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
          gapH8,
          Divider(color: Colors.grey.shade300),
          CustomText('PICK UP', fontSize: 12.px, color: Colors.grey),
          CustomText(pickupLocation, fontWeight: FontWeight.w500),
          gapH8,
          Divider(color: Colors.grey.shade300),
          Row(
            children: [
              Expanded(
                child: ActionButton(
                  text: 'Decline',
                  onPressed: () {
                    presenter.declineRide(rideId);
                  },
                ),
              ),
              gapW12,
              Expanded(
                child: ActionButton(
                  text: 'Accept',
                  isPrimary: true,
                  onPressed: () {
                    presenter.acceptRide(rideId);
                  },
                ),
              ),
            ],
          ),
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
