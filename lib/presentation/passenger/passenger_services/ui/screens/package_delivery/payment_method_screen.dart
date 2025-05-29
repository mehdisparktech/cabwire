import 'package:cabwire/core/config/app_assets.dart';
import 'package:cabwire/core/config/app_screen.dart';
import 'package:cabwire/core/utility/utility.dart';
import 'package:cabwire/presentation/common/components/action_button.dart';
import 'package:cabwire/presentation/common/components/payment_method_card.dart';
import 'package:cabwire/presentation/passenger/car_booking/ui/screens/ride_share_screen.dart';
import 'package:cabwire/presentation/passenger/home/ui/screens/passenger_search_destination_page.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class PaymentMethodScreen extends StatelessWidget {
  const PaymentMethodScreen({super.key});

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
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildAppBar(context),
          SizedBox(height: 16.px),
          PaymentMethodSelector(
            isIWillPay: true,
            paymentMethods: [
              PaymentMethod(
                title: 'Online Payment',
                imageSrc: AppAssets.icOnlinePayment,
                isSelected: true, // Default selection
                isRecommended: true, // Show as recommended option
              ),
              PaymentMethod(
                title: 'Cash Payment',
                imageSrc: AppAssets.icCashPayment,
                isSelected: false,
              ),
            ],
          ),
          SizedBox(height: 16.px),
          ActionButton(
            isPrimary: true,
            text: 'Continue',
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder:
                      (context) => PassengerSearchDestinationScreen(
                        bottomSheet: const RideShareScreen(),
                      ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return AppBar(
      title: Text(
        'Choose Your\nPayment Method',
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 18.px, fontWeight: FontWeight.w700),
      ),
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
}
