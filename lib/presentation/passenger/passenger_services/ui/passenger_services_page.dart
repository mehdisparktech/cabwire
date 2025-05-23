import 'package:cabwire/core/config/app_assets.dart';
import 'package:cabwire/core/config/app_screen.dart';
import 'package:cabwire/presentation/common/components/custom_app_bar.dart';
import 'package:cabwire/presentation/common/components/custom_services_card.dart';
import 'package:flutter/material.dart';

class PassengerServicesPage extends StatelessWidget {
  const PassengerServicesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Services'),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.px, vertical: 16.px),
        child: CustomServicesCard(
          services: [
            Service(
              title: 'Car',
              imageUrl: AppAssets.icServiceCar,
              fontWeight: FontWeight.w600,
            ),
            Service(
              title: 'Emergency Car',
              imageUrl: AppAssets.icServiceCar,
              fontWeight: FontWeight.w400,
            ),
            Service(
              title: 'Rental Car',
              imageUrl: AppAssets.icServiceCar,
              fontWeight: FontWeight.w400,
            ),
            Service(
              title: 'Cabwire Share',
              imageUrl: AppAssets.icServiceCar,
              fontWeight: FontWeight.w400,
            ),
            Service(
              title: 'Package delivery',
              imageUrl: AppAssets.icPackageDelivery,
              fontWeight: FontWeight.w400,
            ),
          ],
        ),
      ),
    );
  }
}
