import 'package:cabwire/core/config/app_assets.dart';
import 'package:cabwire/presentation/common/components/action_button.dart';
import 'package:cabwire/presentation/common/components/circular_icon_button.dart';
import 'package:cabwire/presentation/driver/home/presenter/driver_home_presenter.dart';
import 'package:cabwire/presentation/driver/home/presenter/driver_home_ui_state.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cabwire/core/di/service_locator.dart';
import 'package:cabwire/core/external_libs/presentable_widget_builder.dart';

const Widget gapH10 = SizedBox(height: 10);
const Widget gapW10 = SizedBox(width: 10);

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
      toolbarHeight: 80,
      leading: Padding(
        padding: const EdgeInsets.all(4.0),
        child: CircleAvatar(
          backgroundImage: AssetImage(AppAssets.icProfileImage),
        ),
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Hello ${uiState.userName}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(width: 5),
              Icon(
                Icons.circle,
                size: 10,
                color: uiState.isOnline ? Colors.green : Colors.grey,
              ),
            ],
          ),
          Text(
            uiState.isOnline ? 'You\'re Now Online' : 'You\'re Offline',
            style: const TextStyle(fontSize: 12),
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
          margin: 10.0,
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
        target: uiState.centerMapCoordinates,
        zoom: 14.0,
      ),
      myLocationEnabled: true,
      myLocationButtonEnabled: false,
      zoomControlsEnabled: false,
      mapToolbarEnabled: false,
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
        padding: const EdgeInsets.only(bottom: 20),
        child: SizedBox(
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              if (uiState.isOnline) ...[
                Positioned(
                  bottom: 40,
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
                  bottom: 20,
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
                  bottom: 0,
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
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
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
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          name,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(distance),
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
                        Text(
                          ' $rating ($ratingCount)',
                          style: const TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Divider(color: Colors.grey.shade300),
          const Text(
            'PICK UP',
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
          Text(
            pickupLocation,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 8),
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
              const SizedBox(width: 12),
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
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(color: Colors.black26, blurRadius: 6, offset: Offset(0, 4)),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            'Ready to drive?',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
          ),
          gapH10,
          const Text(
            'Your status is offline. Please go online to get your next ride.',
            style: TextStyle(fontWeight: FontWeight.w500),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          ActionButton(
            text: 'Go Online',
            isPrimary: true,
            onPressed: presenter.goOnline,
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ActionButton(
              text: 'Not Now',
              onPressed: presenter.handleNotNow,
            ),
          ),
        ],
      ),
    );
  }
}
