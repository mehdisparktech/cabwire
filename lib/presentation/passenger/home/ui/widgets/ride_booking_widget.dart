import 'package:cabwire/core/config/app_assets.dart';
import 'package:cabwire/core/config/app_screen.dart';
import 'package:cabwire/presentation/common/components/common_image.dart';
import 'package:cabwire/presentation/passenger/home/ui/screens/passenger_pickup_location_screen.dart';
import 'package:cabwire/presentation/passenger/home/ui/screens/passenger_search_destination_page.dart';
import 'package:flutter/material.dart';

class RideBookingWidget extends StatefulWidget {
  final String title;
  final String pickupLabel;
  final String dropoffLabel;
  final String searchPlaceholder;
  final Function(String? pickup, String? dropoff, String? destination)?
  onLocationSelected;
  final EdgeInsets? padding;
  final double? borderRadius;

  const RideBookingWidget({
    super.key,
    this.title = 'Looking for your next ride?',
    this.pickupLabel = 'Pickup Location',
    this.dropoffLabel = 'Drop-Off Location',
    this.searchPlaceholder = 'Where To?',
    this.onLocationSelected,
    this.padding,
    this.borderRadius = 8.0,
  });

  @override
  State<RideBookingWidget> createState() => _RideBookingWidgetState();
}

class _RideBookingWidgetState extends State<RideBookingWidget> {
  String? _pickupLocation;
  String? _dropoffLocation;
  final TextEditingController _searchController = TextEditingController();

  // Constants for styling
  static const Color _primaryTextColor = Color(0xFF1E1E1E);
  static const Color _shadowColor = Color(0x3F407BFF);
  static const Color _cardShadowColor = Color(0x26000000);

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding:
          widget.padding ??
          EdgeInsets.symmetric(horizontal: 13.px, vertical: 19.px),
      decoration: _buildMainContainerDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          SizedBox(height: 13.px),
          _buildLocationSelectors(),
          SizedBox(height: 20.px),
          _buildSearchField(),
        ],
      ),
    );
  }

  ShapeDecoration _buildMainContainerDecoration() {
    return ShapeDecoration(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(widget.borderRadius!),
      ),
      shadows: const [
        BoxShadow(color: _shadowColor, blurRadius: 4, offset: Offset.zero),
      ],
    );
  }

  Widget _buildHeader() {
    return Text(
      widget.title,
      style: TextStyle(
        color: _primaryTextColor,
        fontSize: 16.px,
        fontWeight: FontWeight.w600,
        height: 1.5,
      ),
    );
  }

  Widget _buildLocationSelectors() {
    return Row(
      children: [
        Expanded(
          child: _buildLocationButton(
            label: widget.pickupLabel,
            icon: Icons.my_location,
            isSelected: _pickupLocation != null,
            onTap: () => _handleLocationSelection(true),
          ),
        ),
        const SizedBox(width: 9),
        Expanded(
          child: _buildLocationButton(
            label: widget.dropoffLabel,
            icon: Icons.location_on,
            isSelected: _dropoffLocation != null,
            onTap: () => _handleLocationSelection(false),
          ),
        ),
      ],
    );
  }

  Widget _buildLocationButton({
    required String label,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.px, vertical: 12.px),
        decoration: _buildCardDecoration(isSelected),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CommonImage(
              imageSrc: AppAssets.icLocation,
              imageType: ImageType.svg,
              width: 18.px,
              height: 18.px,
            ),
            const SizedBox(width: 8),
            Flexible(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  label,
                  style: TextStyle(
                    color: _primaryTextColor,
                    fontSize: 12.px,
                    fontWeight: FontWeight.w500,
                    height: 1.5,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchField() {
    return Container(
      decoration: _buildCardDecoration(false),
      child: TextField(
        controller: _searchController,
        onSubmitted: _handleSearch,
        decoration: InputDecoration(
          hintText: widget.searchPlaceholder,
          hintStyle: TextStyle(
            color: _primaryTextColor,
            fontSize: 14.px,
            fontWeight: FontWeight.w400,
            height: 1.5,
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(
            horizontal: 14.px,
            vertical: 12.px,
          ),
          prefixIcon: Icon(Icons.search, size: 18.px),
          suffixIcon:
              _searchController.text.isNotEmpty
                  ? IconButton(
                    icon: Icon(Icons.clear, size: 18.px),
                    onPressed: () {
                      _searchController.clear();
                      setState(() {});
                    },
                  )
                  : Icon(Icons.voice_chat, size: 18.px),
        ),
        onChanged: (value) => setState(() {}),
      ),
    );
  }

  ShapeDecoration _buildCardDecoration(bool isSelected) {
    return ShapeDecoration(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(widget.borderRadius!),
        side:
            isSelected
                ? const BorderSide(color: Colors.blue, width: 1)
                : BorderSide.none,
      ),
      shadows: const [
        BoxShadow(color: _cardShadowColor, blurRadius: 4, offset: Offset.zero),
      ],
    );
  }

  void _handleLocationSelection(bool isPickup) {
    // Show location picker dialog or navigate to map
    // showDialog(
    //   context: context,
    //   builder:
    //       (context) => LocationPickerDialog(
    //         title:
    //             isPickup
    //                 ? 'Select Pickup Location'
    //                 : 'Select Drop-off Location',
    //         onLocationSelected: (location) {
    //           setState(() {
    //             if (isPickup) {
    //               _pickupLocation = location;
    //             } else {
    //               _dropoffLocation = location;
    //             }
    //           });
    //           _notifyLocationChange();
    //         },
    //       ),
    // );
    if (isPickup) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const PassengerPickupLocationScreen(),
        ),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const PassengerSearchDestinationScreen(),
        ),
      );
    }
  }

  void _handleSearch(String destination) {
    if (destination.isNotEmpty) {
      _notifyLocationChange(destination: destination);
    }
  }

  void _notifyLocationChange({String? destination}) {
    widget.onLocationSelected?.call(
      _pickupLocation,
      _dropoffLocation,
      destination ?? _searchController.text,
    );
  }
}

// Reusable Location Picker Dialog
class LocationPickerDialog extends StatelessWidget {
  final String title;
  final Function(String) onLocationSelected;

  const LocationPickerDialog({
    super.key,
    required this.title,
    required this.onLocationSelected,
  });

  // Sample locations for demo
  static const List<String> _sampleLocations = [
    'Current Location',
    'Home',
    'Work',
    'Airport',
    'Mall',
    'Hospital',
    'University',
    'Train Station',
  ];

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: SizedBox(
        width: double.maxFinite,
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: _sampleLocations.length,
          itemBuilder: (context, index) {
            final location = _sampleLocations[index];
            return ListTile(
              leading: Icon(
                location == 'Current Location'
                    ? Icons.my_location
                    : Icons.location_on,
                color: Colors.blue,
              ),
              title: Text(location),
              onTap: () {
                onLocationSelected(location);
                Navigator.of(context).pop();
              },
            );
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
      ],
    );
  }
}

// Utility class for location data
class LocationData {
  final String name;
  final double? latitude;
  final double? longitude;

  const LocationData({required this.name, this.latitude, this.longitude});

  @override
  String toString() => name;
}

// Extension for easy theming
extension RideBookingTheme on ThemeData {
  static const Color primaryTextColor = Color(0xFF1E1E1E);
  static const Color shadowColor = Color(0x3F407BFF);
  static const Color cardShadowColor = Color(0x26000000);
}
