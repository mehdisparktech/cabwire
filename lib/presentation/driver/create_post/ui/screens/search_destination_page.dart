import 'package:cabwire/core/config/app_screen.dart';
import 'package:cabwire/core/di/service_locator.dart';
import 'package:cabwire/core/external_libs/presentable_widget_builder.dart';
import 'package:cabwire/core/static/ui_const.dart';
import 'package:cabwire/core/utility/utility.dart';
import 'package:cabwire/presentation/common/components/action_button.dart';
import 'package:cabwire/presentation/driver/create_post/presenter/search_destination_presenter.dart';
import 'package:cabwire/presentation/driver/create_post/presenter/search_destination_ui_state.dart'
    as ui_state;
import 'package:cabwire/presentation/driver/create_post/ui/screens/create_post_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class SearchDestinationScreen extends StatelessWidget {
  const SearchDestinationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final SearchDestinationPresenter presenter =
        locate<SearchDestinationPresenter>();
    return PresentableWidgetBuilder(
      presenter: presenter,
      builder: () {
        return Scaffold(
          backgroundColor: context.theme.colorScheme.surface,
          body: Stack(
            children: [
              _buildMap(context, presenter),
              _buildDestinationContainer(context, presenter),
            ],
          ),
          bottomSheet: _buildBottomSheet(context, presenter),
        );
      },
    );
  }

  Widget _buildMap(BuildContext context, SearchDestinationPresenter presenter) {
    return GoogleMap(
      onMapCreated: presenter.onDestinationMapCreated,
      initialCameraPosition: CameraPosition(
        target:
            presenter.currentUiState.currentLocation ??
            const LatLng(23.8103, 90.4125),
        zoom: 14.0,
      ),
      myLocationEnabled: true,
      myLocationButtonEnabled: false,
      zoomControlsEnabled: false,
      mapToolbarEnabled: false,
      // Map interaction disable করা হয়েছে
      scrollGesturesEnabled: false,
      zoomGesturesEnabled: false,
      tiltGesturesEnabled: false,
      rotateGesturesEnabled: false,
    );
  }

  Widget _buildDestinationContainer(
    BuildContext context,
    SearchDestinationPresenter presenter,
  ) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: SizedBox(
        height: context.height * 0.9,
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
            children: [
              _buildHeader(context),
              _buildSearchInputs(context, presenter),
              _buildMultipleLocations(context, presenter),
              _buildAddButton(context, presenter),
              _buildContent(context, presenter),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Get.back(),
            child: Container(
              padding: EdgeInsets.all(8.px),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8.px),
              ),
              child: Icon(
                Icons.arrow_back_ios,
                size: 20,
                color: context.color.blackColor950,
              ),
            ),
          ),
          gapW16,
          Text(
            'Search Your Destination',
            style: TextStyle(
              fontSize: 20.px,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchInputs(
    BuildContext context,
    SearchDestinationPresenter presenter,
  ) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.px),
      padding: EdgeInsets.all(16.px),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.px),
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
            controller: presenter.currentUiState.destinationController,
            hintText: 'Block B, Banasree, Dhaka.',
            icon: Icons.location_on,
            iconColor: context.color.primaryBtn,
            showVoiceIcon: true,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.px),
            child: Divider(color: context.color.strokePrimary),
          ),
          _buildSearchField(
            controller: presenter.currentUiState.fromController,
            hintText: 'To',
            icon: Icons.location_on,
            iconColor: context.color.primaryBtn,
            showCloseIcon: true,
            onClosePressed: () => presenter.clearFromField(),
          ),
        ],
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
    VoidCallback? onClosePressed,
  }) {
    return TextField(
      controller: controller,
      style: const TextStyle(fontSize: 16, color: Colors.black87),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(color: Colors.grey[600], fontSize: 16.px),
        prefixIcon: Icon(icon, color: iconColor, size: 22.px),
        suffixIcon:
            showVoiceIcon
                ? Icon(Icons.mic, color: Colors.grey[600], size: 22.px)
                : showCloseIcon
                ? GestureDetector(
                  onTap: onClosePressed,
                  child: Icon(
                    Icons.close,
                    color: Colors.grey[600],
                    size: 22.px,
                  ),
                )
                : null,
        border: InputBorder.none,
        enabledBorder: InputBorder.none,
        focusedBorder: InputBorder.none,
        contentPadding: EdgeInsets.symmetric(
          horizontal: 16.px,
          vertical: 16.px,
        ),
      ),
    );
  }

  Widget _buildMultipleLocations(
    BuildContext context,
    SearchDestinationPresenter presenter,
  ) {
    if (presenter.currentUiState.multipleLocations.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.px),
      child: Column(
        children:
            presenter.currentUiState.multipleLocations.asMap().entries.map((
              entry,
            ) {
              final index = entry.key;
              final location = entry.value;
              return Container(
                margin: EdgeInsets.only(bottom: 8.px),
                padding: EdgeInsets.all(12.px),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(8.px),
                  border: Border.all(color: Colors.grey[200]!),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.location_on,
                      color: context.color.primaryBtn,
                      size: 20.px,
                    ),
                    gapW12,
                    Expanded(
                      child: Text(
                        location.address.isEmpty
                            ? 'Select location'
                            : location.address,
                        style: TextStyle(
                          fontSize: 14.px,
                          color:
                              location.address.isEmpty
                                  ? Colors.grey[600]
                                  : Colors.black87,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => presenter.removeMultipleLocation(index),
                      child: Icon(
                        Icons.close,
                        color: Colors.grey[600],
                        size: 18.px,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
      ),
    );
  }

  Widget _buildAddButton(
    BuildContext context,
    SearchDestinationPresenter presenter,
  ) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.px, vertical: 8.px),
      child: Align(
        alignment: Alignment.centerRight,
        child: TextButton(
          onPressed: () => presenter.addMultipleLocation(),
          style: TextButton.styleFrom(
            backgroundColor: context.color.whiteColor,
            padding: EdgeInsets.symmetric(horizontal: 20.px, vertical: 12.px),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.px),
              side: BorderSide(color: context.color.primaryBtn),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.add, color: context.color.primaryBtn, size: 18.px),
              gapW8,
              Text(
                'Add Stop',
                style: TextStyle(
                  color: context.color.primaryBtn,
                  fontSize: 16.px,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchHistory(
    BuildContext context,
    SearchDestinationPresenter presenter,
  ) {
    return Expanded(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: px24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Search History',
              style: TextStyle(
                fontSize: 18.px,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            gapH16,
            Expanded(
              child: ListView.separated(
                itemCount: presenter.currentUiState.searchHistory.length,
                separatorBuilder: (context, index) => gapH20,
                itemBuilder: (context, index) {
                  final ui_state.SearchHistoryItem item =
                      presenter.currentUiState.searchHistory[index];
                  return _buildHistoryItem(context, item, presenter);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHistoryItem(
    BuildContext context,
    ui_state.SearchHistoryItem item,
    SearchDestinationPresenter presenter,
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
                size: 18.px,
              ),
              gapH4,
              Text(
                item.distance,
                style: TextStyle(fontSize: 12.px, color: Colors.grey[600]),
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
                  style: TextStyle(
                    fontSize: 14.px,
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

  Widget _buildContent(
    BuildContext context,
    SearchDestinationPresenter presenter,
  ) {
    // Show suggestions if any field has suggestions
    if (presenter.currentUiState.destinationSuggestions.isNotEmpty) {
      return _buildSuggestionsList(
        context,
        presenter.currentUiState.destinationSuggestions,
        (suggestion) => presenter.selectDestinationSuggestion(suggestion),
        'Destination Suggestions',
      );
    }

    if (presenter.currentUiState.fromSuggestions.isNotEmpty) {
      return _buildSuggestionsList(
        context,
        presenter.currentUiState.fromSuggestions,
        (suggestion) => presenter.selectFromSuggestion(suggestion),
        'From Suggestions',
      );
    }

    // Show search history by default
    return _buildSearchHistory(context, presenter);
  }

  Widget _buildSuggestionsList(
    BuildContext context,
    List<String> suggestions,
    Function(String) onSuggestionTap,
    String title,
  ) {
    return Expanded(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: px24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 18.px,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            gapH16,
            Expanded(
              child: ListView.separated(
                itemCount: suggestions.length,
                separatorBuilder:
                    (context, index) =>
                        Divider(color: context.color.strokePrimary, height: 1),
                itemBuilder: (context, index) {
                  final suggestion = suggestions[index];
                  return _buildSuggestionItem(
                    context,
                    suggestion,
                    onSuggestionTap,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSuggestionItem(
    BuildContext context,
    String suggestion,
    Function(String) onTap,
  ) {
    return GestureDetector(
      onTap: () => onTap(suggestion),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12.px),
        child: Row(
          children: [
            Icon(
              Icons.location_on,
              color: context.color.primaryBtn,
              size: 20.px,
            ),
            gapW16,
            Expanded(
              child: Text(
                suggestion,
                style: TextStyle(
                  fontSize: 16.px,
                  color: Colors.black87,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            Icon(Icons.arrow_forward_ios, color: Colors.grey[400], size: 16.px),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomSheet(
    BuildContext context,
    SearchDestinationPresenter presenter,
  ) {
    return Container(
      padding: EdgeInsets.all(16.px),
      child: SafeArea(
        child: ActionButton(
          borderRadius: 12,
          isPrimary: true,
          text: 'Continue',
          onPressed: () {
            presenter.handleContinuePress(context, const CreatePostPage());
          },
        ),
      ),
    );
  }
}
