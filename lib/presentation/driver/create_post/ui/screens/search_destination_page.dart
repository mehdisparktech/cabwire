import 'package:cabwire/core/config/app_screen.dart';
import 'package:cabwire/core/static/ui_const.dart';
import 'package:cabwire/core/utility/utility.dart';
import 'package:cabwire/presentation/common/components/action_button.dart';
import 'package:cabwire/presentation/driver/create_post/ui/screens/set_ride_information_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class SearchDestinationScreen extends StatefulWidget {
  const SearchDestinationScreen({super.key});

  @override
  State<SearchDestinationScreen> createState() =>
      _SearchDestinationScreenState();
}

class _SearchDestinationScreenState extends State<SearchDestinationScreen> {
  final TextEditingController _destinationController = TextEditingController();
  final TextEditingController _fromController = TextEditingController();
  late GoogleMapController mapController;

  final LatLng _center = const LatLng(23.8103, 90.4125);

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  // Sample search history data
  final List<SearchHistoryItem> _searchHistory = [
    SearchHistoryItem(location: 'Block B, Banasree, Dhaka.', distance: '3.8mi'),
    SearchHistoryItem(location: 'Block B, Banasree, Dhaka.', distance: '3.8mi'),
    SearchHistoryItem(location: 'Block B, Banasree, Dhaka.', distance: '3.8mi'),
    SearchHistoryItem(location: 'Block B, Banasree, Dhaka.', distance: '3.8mi'),
    SearchHistoryItem(location: 'Block B, Banasree, Dhaka.', distance: '3.8mi'),
  ];

  @override
  void initState() {
    super.initState();
    _destinationController.text = 'Block B, Banasree, Dhaka.';
  }

  @override
  void dispose() {
    _destinationController.dispose();
    _fromController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.colorScheme.surface,
      body: Stack(children: [_buildMap(), _buildDestinationContainer()]),
      bottomSheet: Padding(
        padding: const EdgeInsets.only(bottom: 16.0),
        child: ActionButton(
          borderRadius: 0,
          isPrimary: true,
          text: 'Continue',
          onPressed: () {
            Get.to(() => const SetRideInformationScreen());
          },
        ),
      ),
    );
  }

  Widget _buildMap() {
    return GoogleMap(
      onMapCreated: _onMapCreated,
      initialCameraPosition: CameraPosition(target: _center, zoom: 14.0),
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

  Widget _buildDestinationContainer() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: SizedBox(
        height: context.height * 0.9,
        child: Stack(
          children: [
            Container(
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
                  _buildHeader(),
                  _buildSearchInputs(),
                  _buildAddButton(),
                  _buildSearchHistory(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.arrow_back_ios,
                size: 20,
                color: context.color.blackColor950,
              ),
            ),
          ),
          const SizedBox(width: 16),
          const Text(
            'Search Your Destination',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchInputs() {
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
            controller: _destinationController,
            hintText: 'Block B, Banasree, Dhaka.',
            icon: Icons.location_on,
            iconColor: context.color.primaryBtn,
            showVoiceIcon: true,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Divider(color: context.color.strokePrimary),
          ),
          _buildSearchField(
            controller: _fromController,
            hintText: 'From',
            icon: Icons.location_on,
            iconColor: context.color.primaryBtn,
            showCloseIcon: true,
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
  }) {
    return TextField(
      controller: controller,
      style: const TextStyle(fontSize: 16, color: Colors.black87),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(color: Colors.grey[600], fontSize: 16),
        prefixIcon: Icon(icon, color: iconColor, size: 22),
        suffixIcon:
            showVoiceIcon
                ? Icon(Icons.mic, color: Colors.grey[600], size: 22)
                : showCloseIcon
                ? Icon(Icons.close, color: Colors.grey[600], size: 22)
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

  Widget _buildAddButton() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Align(
        alignment: Alignment.centerRight,
        child: TextButton(
          onPressed: () {
            // Add functionality here
          },
          style: TextButton.styleFrom(
            backgroundColor: context.color.whiteColor,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Text(
            'Add',
            style: TextStyle(
              color: context.color.blackColor950,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSearchHistory() {
    return Expanded(
      child: Container(
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
            Expanded(
              child: ListView.separated(
                itemCount: _searchHistory.length,
                separatorBuilder: (context, index) => gapH20,
                itemBuilder: (context, index) {
                  final item = _searchHistory[index];
                  return _buildHistoryItem(item);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHistoryItem(SearchHistoryItem item) {
    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.location_on, color: context.color.primaryBtn, size: 18),
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
    );
  }
}

// Data model for search history items
class SearchHistoryItem {
  final String location;
  final String distance;

  SearchHistoryItem({required this.location, required this.distance});
}
