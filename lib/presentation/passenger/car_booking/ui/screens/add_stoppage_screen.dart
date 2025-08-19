import 'package:cabwire/core/config/app_screen.dart';
import 'package:cabwire/core/enum/service_type.dart';
import 'package:cabwire/core/di/service_locator.dart';
import 'package:cabwire/core/external_libs/presentable_widget_builder.dart';
import 'package:cabwire/core/static/ui_const.dart';
import 'package:cabwire/core/utility/utility.dart';
import 'package:cabwire/presentation/common/components/action_button.dart';
import 'package:cabwire/presentation/passenger/car_booking/presenter/add_new_drop_location_presenter.dart';
import 'package:cabwire/presentation/passenger/car_booking/presenter/add_new_drop_location_ui_state.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class AddStoppageScreen extends StatelessWidget {
  final Widget? nextScreen;
  final ServiceType serviceType;
  final String? serviceId;
  final String pickupAddress;
  final LatLng pickupLocation;
  final String? rideId;
  final String? currentDropAddress;

  const AddStoppageScreen({
    super.key,
    this.nextScreen,
    this.serviceType = ServiceType.none,
    this.serviceId,
    required this.pickupAddress,
    required this.pickupLocation,
    this.rideId,
    this.currentDropAddress,
  });

  @override
  Widget build(BuildContext context) {
    final AddNewDropLocationPresenter presenter =
        locate<AddNewDropLocationPresenter>();

    presenter.setServiceType(serviceType);
    presenter.setServiceId(serviceId);
    presenter.setPickupAddress(pickupAddress);
    presenter.setPickupLocation(pickupLocation);
    // ignore: deprecated_member_use
    return PresentableWidgetBuilder(
      presenter: presenter,
      builder: () {
        final state = presenter.currentUiState;
        return Scaffold(
          backgroundColor: context.theme.colorScheme.surface,
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(kToolbarHeight),
            child: _buildAppBar(context),
          ),
          body: Stack(
            children: [
              _buildMap(context, presenter, state),
              if (state.routePolylines != null &&
                  state.routePolylines!.isNotEmpty)
                _buildRouteVisualization(context, presenter, state),
              _buildDestinationContainer(context, presenter, state),
            ],
          ),
          bottomNavigationBar: SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(
                bottom: 16.0,
                left: 16.0,
                right: 16.0,
              ),
              child: ActionButton(
                borderRadius: 8.0,
                isPrimary: true,
                text: 'Confirm Stoppage',
                onPressed:
                    () => presenter.confirmStoppage(
                      context: context,
                      rideId: rideId,
                    ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildMap(
    BuildContext context,
    AddNewDropLocationPresenter presenter,
    AddNewDropLocationUiState state,
  ) {
    // Create markers set
    Set<Marker> markers = {};

    // Add origin marker if available (current/pickup location)
    if (state.currentLocation != null) {
      markers.add(
        Marker(
          markerId: const MarkerId('current_location'),
          position: state.currentLocation!,
          icon: BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueGreen,
          ),
          infoWindow: InfoWindow(
            title: 'Current Location',
            snippet: state.pickupAddress ?? 'Your Location',
          ),
        ),
      );
    }

    // Add pickup marker if it's different from current location
    if (state.selectedPickupLocation != null &&
        (state.currentLocation == null ||
            state.selectedPickupLocation!.latitude !=
                state.currentLocation!.latitude ||
            state.selectedPickupLocation!.longitude !=
                state.currentLocation!.longitude)) {
      markers.add(
        Marker(
          markerId: const MarkerId('pickup'),
          position: state.selectedPickupLocation!,
          icon: BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueAzure,
          ),
          infoWindow: InfoWindow(
            title: 'Pickup',
            snippet: state.pickupAddress ?? 'Starting Point',
          ),
        ),
      );
    }

    // Add destination marker if available
    if (state.destinationLocation != null) {
      markers.add(
        Marker(
          markerId: const MarkerId('destination'),
          position: state.destinationLocation!,
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
          infoWindow: InfoWindow(
            title: 'Destination',
            snippet: state.destinationAddress ?? 'End Point',
          ),
        ),
      );
    }

    // Create polylines set
    Set<Polyline> polylines = {};

    // Add route polyline if available
    if (state.routePolylines != null && state.routePolylines!.isNotEmpty) {
      polylines.add(
        Polyline(
          polylineId: const PolylineId('route'),
          points: state.routePolylines!,
          color: Colors.blue.shade700,
          width: 6,
          patterns: [PatternItem.dash(20), PatternItem.gap(5)],
          endCap: Cap.roundCap,
          startCap: Cap.roundCap,
          geodesic: true,
          visible: true,
          consumeTapEvents: false,
        ),
      );
    }

    // Calculate camera position based on available points
    CameraPosition initialCamera;

    // If we have both pickup and destination locations, fit the map to show both
    if (state.selectedPickupLocation != null &&
        state.destinationLocation != null) {
      // We'll set initial position to midpoint between pickup and destination
      initialCamera = CameraPosition(
        target: LatLng(
          (state.selectedPickupLocation!.latitude +
                  state.destinationLocation!.latitude) /
              2,
          (state.selectedPickupLocation!.longitude +
                  state.destinationLocation!.longitude) /
              2,
        ),
        zoom: 13.0, // Slightly zoomed out to show more of the route
      );
    } else {
      // Otherwise use current location or default
      initialCamera = CameraPosition(
        target: state.currentLocation ?? const LatLng(23.8103, 90.4125),
        zoom: 14.0,
      );
    }

    return GoogleMap(
      onMapCreated: (controller) {
        // Call the presenter's map created handler
        presenter.onDestinationMapCreated(controller);

        // Check if we need to show polylines
        if (state.selectedPickupLocation != null &&
            state.destinationLocation != null) {
          // Use a slight delay to ensure the map is fully initialized
          Future.delayed(const Duration(milliseconds: 500), () {
            // This explicit call ensures polylines are generated
            presenter.fetchRoutePolylines(
              state.selectedPickupLocation!,
              state.destinationLocation!,
            );

            // After a bit more delay to ensure polylines are loaded, fit bounds
            Future.delayed(const Duration(milliseconds: 800), () {
              presenter.fitBoundsOnMap();
            });
          });
        }
      },
      initialCameraPosition: initialCamera,
      myLocationEnabled: true,
      myLocationButtonEnabled: true,
      zoomControlsEnabled: true,
      mapToolbarEnabled: true,
      markers: markers,
      polylines: polylines,
      compassEnabled: true,
      scrollGesturesEnabled: true,
      zoomGesturesEnabled: true,
      tiltGesturesEnabled: false,
      rotateGesturesEnabled: true,
    );
  }

  // Helper method to fit map to show both markers with padding

  Widget _buildRouteVisualization(
    BuildContext context,
    AddNewDropLocationPresenter presenter,
    AddNewDropLocationUiState state,
  ) {
    if (state.routePolylines == null || state.routePolylines!.isEmpty) {
      return const SizedBox.shrink(); // Don't show anything if no route
    }

    return Positioned(
      top: 90,
      left: 10,
      right: 10,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        margin: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white.withOpacityInt(0.9),
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacityInt(0.1),
              blurRadius: 4,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Row(
          children: [
            const Icon(Icons.directions, color: Colors.blue),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Route from ${state.pickupAddress?.split(',').first ?? 'Origin'} to ${state.destinationAddress?.split(',').first ?? presenter.destinationController.text.split(',').first}',
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.blue,
                    ),
                  ),
                  if (state.routeDistance != null &&
                      state.routeDuration != null)
                    Text(
                      '${state.routeDistance} • ${state.routeDuration}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.black87,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDestinationContainer(
    BuildContext context,
    AddNewDropLocationPresenter presenter,
    AddNewDropLocationUiState state,
  ) {
    return DraggableScrollableSheet(
      initialChildSize: 0.8,
      minChildSize: 0.2,
      maxChildSize: 0.9,
      snap: true,
      snapSizes: const [0.4, 0.7, 0.9],
      builder: (BuildContext context, ScrollController scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(px32),
              topRight: Radius.circular(px32),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacityInt(0.1),
                blurRadius: 10,
                offset: Offset(0, -4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Drag handle
              Container(
                margin: const EdgeInsets.only(top: 12, bottom: 8),
                width: 40,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  physics: const ClampingScrollPhysics(),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      gapH20,
                      _buildSearchInputs(context, presenter, state),
                      gapH20,
                      if (state.routeDistance != null &&
                          state.routeDuration != null)
                        _buildRouteInfo(context, state),

                      if (state.destinationSuggestions.isNotEmpty)
                        _buildSuggestionList(
                          context,
                          presenter,
                          state.destinationSuggestions,
                          (suggestion) =>
                              presenter.selectDestinationSuggestion(suggestion),
                        ),
                      if (state.originSuggestions.isNotEmpty)
                        _buildSuggestionList(
                          context,
                          presenter,
                          state.originSuggestions,
                          (suggestion) =>
                              presenter.selectOriginSuggestion(suggestion),
                        ),
                      gapH20,
                      if (state.destinationSuggestions.isEmpty &&
                          state.originSuggestions.isEmpty &&
                          state.routeDistance == null)
                        SizedBox(
                          height: 300,
                          child: _buildSearchHistory(context, presenter, state),
                        ),
                      // Add extra padding at bottom to ensure content isn't hidden behind the bottom sheet
                      const SizedBox(height: 80),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      title: Text('Add Stoppage'),
      centerTitle: true,
      leading: IconButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        icon: Container(
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(100),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacityInt(0.1),
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Icon(Icons.arrow_back_ios_new),
          ),
        ),
      ),
    );
  }

  Widget _buildSearchInputs(
    BuildContext context,
    AddNewDropLocationPresenter presenter,
    AddNewDropLocationUiState state,
  ) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
        boxShadow: [
          BoxShadow(
            color: Colors.grey[200]!,
            blurRadius: 10,
            offset: const Offset(5, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildSearchField(
            controller: presenter.fromController,
            hintText: 'From',
            icon: Icons.location_on,
            iconColor: context.color.primaryBtn,
            onChanged:
                (_) => presenter.searchDestinationPlaces(
                  presenter.fromController.text,
                ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Divider(color: context.color.strokePrimary),
          ),
          _buildSearchField(
            controller: presenter.destinationController,
            hintText: 'To',
            icon: Icons.location_on,
            iconColor: context.color.primaryBtn,
            showCloseIcon: presenter.destinationController.text.isNotEmpty,
            onClearPressed: () => presenter.clearDestination(),
            onChanged:
                (_) => presenter.searchOriginPlaces(
                  presenter.destinationController.text,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildRouteInfo(
    BuildContext context,
    AddNewDropLocationUiState state,
  ) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.blue[100]!),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Column(
            children: [
              Text(
                'Distance',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.blue[800],
                  fontWeight: FontWeight.w500,
                ),
              ),
              gapH4,
              Text(
                state.routeDistance!,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.blue[900],
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          Container(height: 30, width: 1, color: Colors.blue[200]),
          Column(
            children: [
              Text(
                'Duration',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.blue[800],
                  fontWeight: FontWeight.w500,
                ),
              ),
              gapH4,
              Text(
                state.routeDuration!,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.blue[900],
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSuggestionList(
    BuildContext context,
    AddNewDropLocationPresenter presenter,
    List<String> suggestions,
    Function(String) onSuggestionSelected,
  ) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacityInt(0.1),
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        padding: EdgeInsets.zero,
        itemCount: suggestions.length > 5 ? 5 : suggestions.length,
        itemBuilder: (context, index) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (index > 0) Divider(height: 1, thickness: 1),
              ListTile(
                dense: true,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 0,
                ),
                minLeadingWidth: 20,
                leading: Icon(
                  Icons.location_on,
                  color: context.color.primaryBtn,
                  size: 20,
                ),
                title: Text(
                  suggestions[index],
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 14),
                ),
                onTap: () => onSuggestionSelected(suggestions[index]),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSearchField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    required Color iconColor,
    bool showVoiceIcon = false,
    bool showCloseIcon = false,
    VoidCallback? onClearPressed,
    Function(String)? onChanged,
  }) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      style: const TextStyle(fontSize: 16, color: Colors.black87),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(color: Colors.grey[600], fontSize: 16),
        prefixIcon: Icon(icon, color: iconColor, size: 22),
        suffixIcon:
            showVoiceIcon
                ? Icon(Icons.mic, color: Colors.grey[600], size: 22)
                : showCloseIcon
                ? IconButton(
                  icon: Icon(Icons.close, color: Colors.grey[600], size: 22),
                  onPressed: onClearPressed,
                )
                : null,
        border: InputBorder.none,
        enabledBorder: InputBorder.none,
        focusedBorder: InputBorder.none,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
      ),
    );
  }

  Widget _buildSearchHistory(
    BuildContext context,
    AddNewDropLocationPresenter presenter,
    AddNewDropLocationUiState state,
  ) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: px24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Search History',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          state.searchHistory.isEmpty
              ? Center(
                child: Text(
                  'No search history',
                  style: TextStyle(color: Colors.grey),
                ),
              )
              : SizedBox(
                height: 250, // Fixed height for the list
                child: ListView.separated(
                  shrinkWrap: true,
                  physics: BouncingScrollPhysics(),
                  itemCount: state.searchHistory.length,
                  separatorBuilder: (context, index) => gapH20,
                  itemBuilder: (context, index) {
                    final item = state.searchHistory[index];
                    return _buildHistoryItem(context, presenter, item);
                  },
                ),
              ),
        ],
      ),
    );
  }

  Widget _buildHistoryItem(
    BuildContext context,
    AddNewDropLocationPresenter presenter,
    AddNewDropLocationSearchHistoryItem item,
  ) {
    return GestureDetector(
      onTap: () => presenter.selectHistoryItem(item),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.location_on,
                color: context.color.primaryBtn,
                size: 18,
              ),
              const SizedBox(height: 4),
              Text(
                item.distance,
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
            ],
          ),
          gapW20,
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.location,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black87,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Divider(color: context.color.strokePrimary),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
