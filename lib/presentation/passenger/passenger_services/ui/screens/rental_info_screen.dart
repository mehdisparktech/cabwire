import 'package:cabwire/core/config/app_color.dart';
import 'package:cabwire/core/static/ui_const.dart';
import 'package:cabwire/core/utility/utility.dart';
import 'package:cabwire/presentation/common/components/action_button.dart';
import 'package:cabwire/presentation/common/components/custom_app_bar.dart';
import 'package:cabwire/presentation/common/components/custom_text.dart';
import 'package:cabwire/presentation/passenger/home/ui/screens/passenger_search_destination_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RentalInfoScreen extends StatelessWidget {
  const RentalInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'How long will it take?'),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          gapH40,
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildRoundedIconButton(Icons.add, () {}),
              gapW20,
              CustomText(
                '20 hours',
                style: context.theme.textTheme.titleLarge?.copyWith(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                ),
              ),
              gapW20,
              _buildRoundedIconButton(Icons.remove, () {}),
            ],
          ),
          CustomText('20 km'),
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: AppColor.whiteColor,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacityInt(0.1),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomText(
                  'Total Amount',
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                CustomText('\$2000', fontSize: 16, fontWeight: FontWeight.bold),
              ],
            ),
            gapH20,
            ActionButton(
              isPrimary: true,
              text: 'Search Trip',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) => const PassengerSearchDestinationScreen(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRoundedIconButton(
    IconData icon,
    VoidCallback onPressed, {
    double iconSize = 30,
  }) {
    return Container(
      padding: const EdgeInsets.all(2.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
        border: Border.all(color: AppColor.passengerPrimaryColor, width: 6),
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(icon, color: AppColor.passengerBorder, size: iconSize),
      ),
    );
  }
}
