import 'package:cabwire/core/config/app_assets.dart';
import 'package:cabwire/core/config/app_screen.dart';
import 'package:cabwire/core/di/service_locator.dart';
import 'package:cabwire/core/external_libs/presentable_widget_builder.dart';
import 'package:cabwire/core/utility/utility.dart';
import 'package:cabwire/presentation/common/components/action_button.dart';
import 'package:cabwire/presentation/common/components/common_image.dart';
import 'package:cabwire/presentation/passenger/home/presenter/passenger_pickup_location_presenter.dart';
import 'package:cabwire/presentation/passenger/home/presenter/passenger_pickup_location_ui_state.dart';
import 'package:cabwire/presentation/passenger/home/presenter/passenger_drop_location_presenter.dart';
import 'package:cabwire/presentation/passenger/home/presenter/presenter_home_presenter.dart';
import 'package:cabwire/presentation/passenger/main/ui/screens/passenger_main_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class PassengerPickupLocationScreen extends StatelessWidget {
  const PassengerPickupLocationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final PassengerPickupLocationPresenter presenter =
        locate<PassengerPickupLocationPresenter>();
    return PresentableWidgetBuilder(
      presenter: presenter,
      builder: () {
        final state = presenter.currentUiState;
        return Scaffold(
          appBar: AppBar(
            title: Text(
              'Set Pickup Location',
              style: TextStyle(color: Colors.black),
            ),
            backgroundColor: Colors.white,
            elevation: 0,
            iconTheme: IconThemeData(color: Colors.black),
          ),
          body: Stack(
            children: [
              _buildMap(context, presenter, state),
              Positioned(
                top: 16.px,
                left: 16.px,
                right: 16.px,
                child: _buildSearchField(context, presenter, state),
              ),
              if (state.searchSuggestions.isNotEmpty)
                Positioned(
                  top: 70.px,
                  left: 16.px,
                  right: 16.px,
                  child: _buildSuggestionsList(context, presenter, state),
                ),
              if (state.isCameraMoving)
                Positioned.fill(child: _buildLocationPin(context)),
            ],
          ),
          bottomSheet: _buildBottomSheet(context, presenter, state),
        );
      },
    );
  }

  Widget _buildSearchField(
    BuildContext context,
    PassengerPickupLocationPresenter presenter,
    PassengerPickupLocationUiState state,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.px),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacityInt(0.1),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: state.searchController,
        decoration: InputDecoration(
          hintText: 'Search for a location',
          prefixIcon: Padding(
            padding: EdgeInsets.all(10.px),
            child: CommonImage(
              imageSrc: AppAssets.icLocation,
              imageType: ImageType.svg,
              imageColor: context.color.primaryButtonGradient,
              width: 12.px,
              height: 12.px,
            ),
          ),
          suffixIcon:
              state.searchController.text.isNotEmpty
                  ? IconButton(
                    icon: Icon(Icons.close, color: Colors.grey[600], size: 20),
                    onPressed: () {
                      state.searchController.clear();
                      presenter.onMapCreated(state.mapController!);
                    },
                  )
                  : null,
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(
            horizontal: 16.px,
            vertical: 12.px,
          ),
        ),
      ),
    );
  }

  Widget _buildSuggestionsList(
    BuildContext context,
    PassengerPickupLocationPresenter presenter,
    PassengerPickupLocationUiState state,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.px),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacityInt(0.1),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      constraints: BoxConstraints(maxHeight: 250.px),
      child: ListView.separated(
        shrinkWrap: true,
        itemCount:
            state.searchSuggestions.length > 5
                ? 5
                : state.searchSuggestions.length,
        separatorBuilder: (context, index) => Divider(height: 1),
        itemBuilder: (context, index) {
          final suggestion = state.searchSuggestions[index];
          return ListTile(
            dense: true,
            leading: Icon(Icons.location_on),
            title: Text(
              suggestion,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            onTap: () => presenter.selectSearchResult(suggestion),
          );
        },
      ),
    );
  }

  Widget _buildMap(
    BuildContext context,
    PassengerPickupLocationPresenter presenter,
    PassengerPickupLocationUiState state,
  ) {
    return GoogleMap(
      onMapCreated: presenter.onMapCreated,
      initialCameraPosition: CameraPosition(
        target: state.currentLocation ?? LatLng(23.8103, 90.4125),
        zoom: 14.0,
      ),
      myLocationEnabled: true,
      myLocationButtonEnabled: true,
      zoomControlsEnabled: false,
      mapToolbarEnabled: false,
      scrollGesturesEnabled: true,
      zoomGesturesEnabled: true,
      tiltGesturesEnabled: true,
      rotateGesturesEnabled: true,
      onTap: presenter.onMapTap,
      onCameraMove: presenter.onCameraMove,
      onCameraIdle: presenter.onCameraIdle,
      markers: presenter.markers,
    );
  }

  Widget _buildLocationPin(BuildContext context) {
    return Center(
      child: Container(
        margin: EdgeInsets.only(bottom: 40.px),
        child: Icon(
          Icons.location_pin,
          color: context.color.primaryButtonGradient,
          size: 40.px,
        ),
      ),
    );
  }

  Widget _buildBottomSheet(
    BuildContext context,
    PassengerPickupLocationPresenter presenter,
    PassengerPickupLocationUiState state,
  ) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.px, vertical: 16.px),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.px)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacityInt(0.1),
            blurRadius: 8,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Location display field
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.px, vertical: 16.px),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(8.px),
            ),
            child: Row(
              children: [
                CommonImage(
                  imageSrc: AppAssets.icLocation,
                  imageType: ImageType.svg,
                  imageColor: context.color.primaryButtonGradient,
                  width: 16.px,
                  height: 16.px,
                ),
                SizedBox(width: 12.px),
                Expanded(
                  child: Text(
                    state.pickupAddress ?? 'Tap on map to select location',
                    style: TextStyle(fontSize: 14.px),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 16.px),
          // Action buttons
          state.selectedPickupLocation == null
              ? ActionButton(
                isPrimary: true,
                text: 'Set Location',
                onPressed: () {}, // Disabled
              )
              : ActionButton(
                isPrimary: true,
                text: 'Set Location',
                onPressed: () {
                  // Get the presenters
                  final dropLocationPresenter =
                      locate<PassengerDropLocationPresenter>();
                  final homePresenter = locate<PassengerHomePresenter>();

                  // Update the PassengerDropLocationUiState with pickup location data
                  dropLocationPresenter.updatePickupLocation(
                    state.selectedPickupLocation!,
                    state.pickupAddress!,
                  );

                  // Update the PassengerHomePresenter with pickup location data
                  homePresenter.updatePickupLocationData(
                    state.selectedPickupLocation!,
                    state.pickupAddress!,
                  );

                  // Navigate to destination search screen
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => PassengerMainPage(),
                    ),
                  );
                },
              ),
        ],
      ),
    );
  }
}
