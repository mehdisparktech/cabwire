import 'package:cabwire/core/config/app_screen.dart';
import 'package:cabwire/core/di/service_locator.dart';
import 'package:cabwire/core/external_libs/presentable_widget_builder.dart';
import 'package:cabwire/core/static/ui_const.dart';
import 'package:cabwire/core/utility/utility.dart';
import 'package:cabwire/presentation/common/components/action_button.dart';
import 'package:cabwire/presentation/passenger/home/presenter/passenger_drop_location_presenter.dart';
import 'package:cabwire/presentation/passenger/home/presenter/passenger_drop_location_ui_state.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class PassengerSearchDestinationScreen extends StatelessWidget {
  final Widget? nextScreen;

  const PassengerSearchDestinationScreen({super.key, this.nextScreen});

  @override
  Widget build(BuildContext context) {
    final PassengerDropLocationPresenter presenter =
        locate<PassengerDropLocationPresenter>();

    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async {
        // Clean up resources before popping
        presenter.onClose();
        // Properly remove the presenter instance from service locator
        dislocate<PassengerDropLocationPresenter>();
        return true;
      },
      child: PresentableWidgetBuilder(
        presenter: presenter,
        builder: () {
          final state = presenter.currentUiState;

          // Handle button press based on state
          void handleContinuePress() {
            if (state.destinationLocation != null) {
              presenter.navigateToCarTypeSelection(context, nextScreen);
            }
          }

          return Scaffold(
            backgroundColor: context.theme.colorScheme.surface,
            body: Stack(
              children: [
                _buildMap(context, presenter, state),
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
                  text: 'Continue',
                  onPressed: handleContinuePress,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildMap(
    BuildContext context,
    PassengerDropLocationPresenter presenter,
    PassengerDropLocationUiState state,
  ) {
    return GoogleMap(
      onMapCreated: presenter.onDestinationMapCreated,
      initialCameraPosition: CameraPosition(
        target: state.currentLocation ?? LatLng(23.8103, 90.4125),
        zoom: 14.0,
      ),
      myLocationEnabled: true,
      myLocationButtonEnabled: false,
      zoomControlsEnabled: false,
      mapToolbarEnabled: false,
      scrollGesturesEnabled: false,
      zoomGesturesEnabled: false,
      tiltGesturesEnabled: false,
      rotateGesturesEnabled: false,
    );
  }

  Widget _buildRouteVisualization(
    BuildContext context,
    PassengerDropLocationPresenter presenter,
    PassengerDropLocationUiState state,
  ) {
    // This would display route path between pickup and destination
    return Positioned(
      top: 90,
      left: 10,
      right: 10,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        margin: EdgeInsets.symmetric(horizontal: 16),
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
        child: Text(
          'Route from ${state.pickupAddress?.split(',').first ?? 'Origin'} to ${state.destinationController.text.split(',').first}',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.blue[800],
          ),
        ),
      ),
    );
  }

  Widget _buildDestinationContainer(
    BuildContext context,
    PassengerDropLocationPresenter presenter,
    PassengerDropLocationUiState state,
  ) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        height: context.height * 0.9,
        child: SingleChildScrollView(
          physics: ClampingScrollPhysics(),
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(px32),
                topRight: Radius.circular(px32),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildAppBar(context),
                gapH20,
                _buildSearchInputs(context, presenter, state),
                gapH20,
                if (state.destinationLocation != null &&
                    state.selectedPickupLocation != null)
                  _buildRouteVisualization(context, presenter, state),
                gapH20,
                if (state.routeDistance != null && state.routeDuration != null)
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
                SizedBox(height: 80),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return AppBar(
      title: Text('Search Destination'),
      centerTitle: true,
      leading: IconButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        icon: Container(
          decoration: BoxDecoration(
            color: Colors.white,
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
    PassengerDropLocationPresenter presenter,
    PassengerDropLocationUiState state,
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
            offset: Offset(5, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildSearchField(
            controller: state.fromController,
            hintText: 'From',
            icon: Icons.location_on,
            iconColor: context.color.primaryBtn,
            showCloseIcon: state.fromController.text.isNotEmpty,
            onClearPressed: () => presenter.clearDestination(),
            onChanged: (_) {},
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Divider(color: context.color.strokePrimary),
          ),
          _buildSearchField(
            controller: state.destinationController,
            hintText: 'To',
            icon: Icons.location_on,
            iconColor: context.color.primaryBtn,
            showCloseIcon: state.destinationController.text.isNotEmpty,
            onClearPressed: () => presenter.clearDestination(),
            onChanged: (_) {},
          ),
        ],
      ),
    );
  }

  Widget _buildRouteInfo(
    BuildContext context,
    PassengerDropLocationUiState state,
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
    PassengerDropLocationPresenter presenter,
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
    PassengerDropLocationPresenter presenter,
    PassengerDropLocationUiState state,
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
    PassengerDropLocationPresenter presenter,
    SearchHistoryItem item,
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
