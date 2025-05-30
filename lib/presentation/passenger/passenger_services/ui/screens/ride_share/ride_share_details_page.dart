// ride_details_page.dart
import 'package:cabwire/core/config/app_assets.dart';
import 'package:cabwire/core/config/app_screen.dart';
import 'package:cabwire/presentation/common/components/action_button.dart';
import 'package:cabwire/presentation/common/components/custom_app_bar.dart';
import 'package:cabwire/presentation/common/components/custom_text.dart';
import 'package:cabwire/presentation/common/components/common_image.dart';
import 'package:cabwire/presentation/common/components/payment_method_card.dart';
import 'package:cabwire/presentation/passenger/car_booking/ui/screens/sucessfull_screen.dart';
import 'package:cabwire/presentation/passenger/passenger_history/ui/widgets/passenger_profile_widget.dart';
import 'package:cabwire/presentation/passenger/passenger_history/ui/widgets/passenger_route_information_widget.dart';
import 'package:flutter/material.dart';

class RideShareDetailsScreen extends StatelessWidget {
  const RideShareDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(),
      bottomSheet: _buildBottomSheet(context),
    );
  }

  /// Builds the custom app bar
  PreferredSizeWidget _buildAppBar() {
    return CustomAppBar(
      title: 'Trip Details',
      showBackButton: true,
      elevation: 0,
    );
  }

  /// Builds the main body content
  Widget _buildBody() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildPassengerProfile(),
            const SizedBox(height: 24),
            _buildVehicleInformation(),
            const SizedBox(height: 24),
            _buildTripInformation(),
            const SizedBox(height: 24),
            _buildTripMetrics(),
            const SizedBox(height: 12),
            _buildSeatNumberInput(),
            const SizedBox(height: 24),
            _buildPaymentReceived(),
            const SizedBox(height: 40),
            _buildPaymentMethodSelector(),
            SizedBox(height: 60.px),
          ],
        ),
      ),
    );
  }

  /// Builds passenger profile widget
  Widget _buildPassengerProfile() {
    return PassengerProfileWidget(
      name: 'John Doe',
      address: '123 Main St, Anytown, USA',
    );
  }

  /// Builds vehicle information section
  Widget _buildVehicleInformation() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'DHK METRO HA 64-8549',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                'Volvo XC90',
                style: const TextStyle(fontSize: 14, color: Colors.black87),
              ),
            ],
          ),
        ),
        const SizedBox(width: 10),
        CommonImage(
          imageSrc: AppAssets.icCarImage,
          imageType: ImageType.png,
          height: 40,
          width: 100,
          fill: BoxFit.contain,
        ),
      ],
    );
  }

  /// Builds trip route information section
  Widget _buildTripInformation() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Your Trip',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        PassengerRouteInformationWidget(
          pickupLocation: '123 Main St, Anytown, USA',
          dropoffLocation: '123 Main St, Anytown, USA',
        ),
      ],
    );
  }

  /// Builds trip metrics (distance and travel time)
  Widget _buildTripMetrics() {
    return Column(
      children: [
        _buildMetricRow('Seat Available:', '2/3'),
        const SizedBox(height: 12),
        _buildMetricRow(
          'Total Distance:',
          '100 km',
        ), // Note: This seems like it should be time, not km
        const SizedBox(height: 12),
        _buildMetricRow('Per Km Rate:', '\$1'),
        const SizedBox(height: 12),
        _buildMetricRow('Departure time:', '10:00 AM'),
      ],
    );
  }

  /// Builds a single metric row
  Widget _buildMetricRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CustomText(label, fontSize: 14, fontWeight: FontWeight.w700),
        CustomText(value, fontSize: 14, fontWeight: FontWeight.w700),
      ],
    );
  }

  /// Builds seat number input field
  Widget _buildSeatNumberInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Seat Book',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        TextField(
          controller: TextEditingController()..text = '1',
          readOnly: false,
          decoration: InputDecoration(
            border: _buildInputBorder(),
            enabledBorder: _buildInputBorder(),
            focusedBorder: _buildInputBorder(),
            hintText: 'Enter your seat number',
            hintStyle: const TextStyle(color: Colors.black45),
          ),
        ),
      ],
    );
  }

  /// Builds input border style
  OutlineInputBorder _buildInputBorder() {
    return OutlineInputBorder(
      borderSide: const BorderSide(color: Color(0xFF001C60)),
      borderRadius: BorderRadius.circular(8),
    );
  }

  /// Builds payment received section
  Widget _buildPaymentReceived() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(Icons.receipt_long, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total Payment',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(width: 12),
              Text(
                '\$10',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Builds payment method selector
  Widget _buildPaymentMethodSelector() {
    return PaymentMethodSelector(
      paymentMethods: [
        PaymentMethod(
          title: 'Online Payment',
          imageSrc: AppAssets.icOnlinePayment,
          isSelected: true,
        ),
        PaymentMethod(
          title: 'Cash Payment',
          imageSrc: AppAssets.icCashPayment,
          isSelected: false,
        ),
      ],
    );
  }

  /// Builds bottom action sheet
  Widget _buildBottomSheet(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: ActionButton(
        isPrimary: true,
        borderRadius: 0,
        text: 'Book Now',
        onPressed: () => _onBookNowPressed(context),
      ),
    );
  }

  /// Handles book now button press
  void _onBookNowPressed(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SucessfullScreen()),
    );
  }
}
