import 'package:cabwire/core/config/app_assets.dart';
import 'package:cabwire/core/di/service_locator.dart';
import 'package:cabwire/presentation/common/components/custom_app_bar.dart';
import 'package:cabwire/presentation/common/components/custom_services_card.dart';
import 'package:cabwire/presentation/passenger/home/presenter/presenter_home_presenter.dart';
import 'package:flutter/material.dart';

class PassengerHomeScreen extends StatelessWidget {
  PassengerHomeScreen({super.key});
  final PassengerHomePresenter presenter = locate<PassengerHomePresenter>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Passenger Home',
        showBackButton: true,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: ServicesWidget(
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
              title: 'Bike',
              imageUrl: AppAssets.icServiceCar,
              fontWeight: FontWeight.w500,
            ),
            Service(
              title: 'Truck',
              imageUrl: AppAssets.icServiceCar,
              fontWeight: FontWeight.w600,
            ),
          ],
        ),
      ),
    );
  }
}
