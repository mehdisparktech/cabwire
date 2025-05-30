import 'package:cabwire/core/config/app_assets.dart';
import 'package:cabwire/core/config/app_screen.dart';
import 'package:cabwire/presentation/common/components/custom_app_bar.dart';
import 'package:cabwire/presentation/common/components/custom_services_card.dart';
import 'package:cabwire/presentation/passenger/home/ui/screens/passenger_search_destination_page.dart';
import 'package:cabwire/presentation/passenger/passenger_services/ui/screens/package_delivery/payment_method_screen.dart';
import 'package:cabwire/presentation/passenger/passenger_services/ui/screens/rental_car_welcome_screen.dart';
import 'package:cabwire/presentation/passenger/passenger_services/ui/screens/ride_share/ride_share_car_type_screen.dart';
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
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) => const PassengerSearchDestinationScreen(),
                  ),
                );
              },
            ),
            Service(
              title: 'Emergency Car',
              imageUrl: AppAssets.icServiceCar,
              fontWeight: FontWeight.w400,
              onTap: () {},
            ),
            Service(
              title: 'Rental Car',
              imageUrl: AppAssets.icServiceCar,
              fontWeight: FontWeight.w400,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const RentalCarWelcomeScreen(),
                  ),
                );
              },
            ),
            Service(
              title: 'Cabwire Share',
              imageUrl: AppAssets.icServiceCar,
              fontWeight: FontWeight.w400,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) => const PassengerSearchDestinationScreen(
                          nextScreen: RideShareCarTypeScreen(),
                        ),
                  ),
                );
              },
            ),
            Service(
              title: 'Package delivery',
              imageUrl: AppAssets.icPackageDelivery,
              fontWeight: FontWeight.w400,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PaymentMethodScreen(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
