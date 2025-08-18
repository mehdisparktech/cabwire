import 'package:cabwire/core/config/api/api_end_point.dart';
import 'package:cabwire/core/di/service_locator.dart';
import 'package:cabwire/core/external_libs/presentable_widget_builder.dart';
import 'package:cabwire/data/services/storage/storage_services.dart';
import 'package:cabwire/presentation/common/components/common_image.dart';
import 'package:cabwire/presentation/common/components/custom_text.dart';
import 'package:cabwire/presentation/common/screens/live_trips/presenter/live_trips_presenter.dart';
import 'package:cabwire/presentation/common/screens/live_trips/presenter/live_trips_ui_state.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class LiveTripsScreen extends StatelessWidget {
  final String rideId;
  const LiveTripsScreen({super.key, required this.rideId});

  @override
  Widget build(BuildContext context) {
    final LiveTripsPresenter presenter = locate<LiveTripsPresenter>();
    presenter.init(rideId: rideId);
    return PresentableWidgetBuilder(
      presenter: presenter,
      builder: () {
        final uiState = presenter.currentUiState;
        return Scaffold(
          appBar: _buildAppBar(context, presenter),
          body: Stack(children: [_buildMap(presenter, uiState)]),
        );
      },
    );
  }

  AppBar _buildAppBar(BuildContext context, LiveTripsPresenter presenter) {
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
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            'Hello ${LocalStorage.myName}',
            fontWeight: FontWeight.bold,
          ),
          CustomText(
            uiState.isOnline ? 'Ride is Live' : 'Ride is not Live',
            fontSize: 12.px,
          ),
        ],
      ),
    );
  }

  Widget _buildMap(LiveTripsPresenter presenter, LiveTripsUiState uiState) {
    return GoogleMap(
      onMapCreated: presenter.onMapCreated,
      initialCameraPosition: CameraPosition(
        target: LatLng(
          uiState.currentLocation!.latitude,
          uiState.currentLocation!.longitude,
        ),
        zoom: 18.0,
      ),
      myLocationEnabled: true,
      myLocationButtonEnabled: true,
      zoomControlsEnabled: false,
      mapToolbarEnabled: false,
      mapType: MapType.normal,
      markers: {
        Marker(
          markerId: MarkerId('source'),
          position: LatLng(
            uiState.sourceMapCoordinates!.latitude,
            uiState.sourceMapCoordinates!.longitude,
          ),
          icon: uiState.sourceIcon!,
        ),
        Marker(
          markerId: MarkerId('destination'),
          position: LatLng(
            uiState.destinationMapCoordinates!.latitude,
            uiState.destinationMapCoordinates!.longitude,
          ),
          icon: uiState.destinationIcon!,
        ),
        if (uiState.currentLocation != null)
          Marker(
            markerId: MarkerId('currentLocation'),
            position: LatLng(
              uiState.currentLocation!.latitude,
              uiState.currentLocation!.longitude,
            ),
            icon: uiState.currentLocationIcon!,
          ),
      },
      polylines: {
        Polyline(
          polylineId: PolylineId('polyline'),
          points: uiState.polylineCoordinates ?? [],
          color: Colors.black,
          width: 3,
        ),
      },
    );
  }
}
