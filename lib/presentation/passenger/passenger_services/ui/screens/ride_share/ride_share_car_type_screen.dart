import 'package:cabwire/core/config/app_assets.dart';
import 'package:cabwire/core/config/app_color.dart';
import 'package:cabwire/core/config/app_screen.dart';
import 'package:cabwire/core/static/ui_const.dart';
import 'package:cabwire/core/utility/utility.dart';
import 'package:cabwire/presentation/common/components/action_button.dart';
import 'package:cabwire/presentation/passenger/passenger_services/ui/screens/ride_share/ride_share_details_page.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class RideShareCarTypeScreen extends StatelessWidget {
  const RideShareCarTypeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildMap(context),
      bottomSheet: _buildBottomSheet(context),
    );
  }

  Widget _buildMap(BuildContext context) {
    return GoogleMap(
      onMapCreated: (controller) {}, // Use presenter's method
      initialCameraPosition: CameraPosition(
        target: LatLng(23.8103, 90.4125),
        zoom: 14.0,
      ),
      myLocationEnabled: true,
      myLocationButtonEnabled: false,
      zoomControlsEnabled: false,
      mapToolbarEnabled: false,
      scrollGesturesEnabled: true,
      zoomGesturesEnabled: true,
      tiltGesturesEnabled: true,
      rotateGesturesEnabled: true,
    );
  }

  Widget _buildBottomSheet(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.px, vertical: 16.px),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16.px),
          topRight: Radius.circular(16.px),
        ),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildAppBar(context),
            SizedBox(height: 16.px),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return _buildCarServiceCard(context, index == 0);
              },
              separatorBuilder: (context, index) => SizedBox(height: 12.px),
              itemCount: 4,
            ),
            SizedBox(height: 18.px),
            ActionButton(
              isPrimary: true,
              text: 'Continue',
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const RideShareDetailsScreen(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return AppBar(
      title: Text('Car Booking'),
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

  Widget _buildCarServiceCard(BuildContext context, bool isSelected) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        width: 343.px,
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 13),
        decoration: _buildCardDecoration(isSelected),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDriverImage(),
            const SizedBox(width: 15),
            Expanded(child: _buildCarDetails(context, isSelected)),
            const SizedBox(width: 30),
            _buildPrice(context, isSelected),
          ],
        ),
      ),
    );
  }

  // Builder method for card decoration - keeps styling logic organized
  BoxDecoration _buildCardDecoration(bool isSelected) {
    return BoxDecoration(
      color: isSelected ? AppColor.primary : Colors.white,
      borderRadius: BorderRadius.circular(12),
      boxShadow: const [
        BoxShadow(
          color: Color(0x26000000), // 15% opacity for subtle shadow
          blurRadius: 4,
          offset: Offset.zero,
          spreadRadius: 0,
        ),
      ],
    );
  }

  // Builder method for car image with oval background and error handling
  Widget _buildDriverImage() {
    return Padding(
      padding: const EdgeInsets.all(6), // Inner padding to create border effect
      child: CircleAvatar(
        backgroundImage: AssetImage(AppAssets.icProfileImage),
        radius: 24.px,
      ),
    );
  }

  // Builder method for car details section - name and description
  Widget _buildCarDetails(BuildContext context, bool isSelected) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Santiago Dslab',
          style: TextStyle(
            color: isSelected ? Colors.white : const Color(0xFF1E1E1E),
          ),
        ),
        gapH8,
        // Car service name with theme-aware styling
        Text(
          'Volvo XC90',
          style:
              Theme.of(context).textTheme.titleMedium?.copyWith(
                color: isSelected ? Colors.white : const Color(0xFF1E1E1E),
                fontWeight: FontWeight.w700,
                fontFamily: 'Outfit',
              ) ??
              _getDefaultTitleStyle(), // Fallback if theme is not available
        ),
        const SizedBox(
          height: 5,
        ), // Consistent spacing between title and description
        // Service description with smaller font
        Text(
          'Departure time 10.30',
          style:
              Theme.of(context).textTheme.bodySmall?.copyWith(
                color: isSelected ? Colors.white : const Color(0xFF1E1E1E),
                fontFamily: 'Outfit',
              ) ??
              _getDefaultBodyStyle(), // Fallback styling
        ),
      ],
    );
  }

  // Builder method for price display with currency formatting
  Widget _buildPrice(BuildContext context, bool isSelected) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          '\$ 100',
          style:
              Theme.of(context).textTheme.titleMedium?.copyWith(
                color: isSelected ? Colors.white : const Color(0xFF1E1E1E),
                fontWeight: FontWeight.w700,
                fontSize: 14,
              ) ??
              _getDefaultTitleStyle(),
        ),
        SizedBox(height: 24.px),
        Text(
          '2/3', // Format price without decimal places
          style:
              Theme.of(context).textTheme.titleMedium?.copyWith(
                color: isSelected ? Colors.white : const Color(0xFF1E1E1E),
                fontWeight: FontWeight.w700,
                fontSize: 14,
              ) ??
              _getDefaultTitleStyle(),
        ),
      ],
    );
  }

  // Helper method for default title styling - ensures consistency
  TextStyle _getDefaultTitleStyle() {
    return const TextStyle(
      color: Color(0xFF1E1E1E),
      fontSize: 18,
      fontFamily: 'Outfit',
      fontWeight: FontWeight.w700,
      height: 1.5,
    );
  }

  // Helper method for default body text styling
  TextStyle _getDefaultBodyStyle() {
    return const TextStyle(
      color: Color(0xFF1E1E1E),
      fontSize: 12,
      fontFamily: 'Outfit',
      fontWeight: FontWeight.w400,
      height: 1.5,
    );
  }
}
