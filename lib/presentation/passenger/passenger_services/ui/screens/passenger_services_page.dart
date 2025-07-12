import 'package:cabwire/core/config/app_screen.dart';
import 'package:cabwire/core/enum/service_type.dart';
import 'package:cabwire/core/external_libs/presentable_widget_builder.dart';
import 'package:cabwire/domain/entities/passenger/passenger_service_entity.dart';
import 'package:cabwire/presentation/common/components/custom_app_bar.dart';
import 'package:cabwire/presentation/common/components/custom_services_card.dart';
import 'package:cabwire/presentation/common/components/loading_indicator.dart';
import 'package:cabwire/presentation/passenger/home/ui/screens/passenger_search_destination_page.dart';
import 'package:cabwire/presentation/passenger/main/ui/screens/passenger_main_screen.dart';
import 'package:cabwire/presentation/passenger/passenger_services/presenter/passenger_services_presenter.dart';
import 'package:cabwire/presentation/passenger/passenger_services/ui/screens/package_delivery/payment_method_screen.dart';
import 'package:cabwire/presentation/passenger/passenger_services/ui/screens/rental_car_welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:cabwire/core/di/service_locator.dart';

class PassengerServicesPage extends StatelessWidget {
  const PassengerServicesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final PassengerServicesPresenter presenter =
        locate<PassengerServicesPresenter>();
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Services',
        onBackPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => PassengerMainPage()),
          );
        },
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.px, vertical: 16.px),
        child: PresentableWidgetBuilder(
          presenter: presenter,
          builder: () {
            final uiState = presenter.currentUiState;

            if (uiState.isLoading) {
              return Center(child: LoadingIndicator(theme: Theme.of(context)));
            }

            if (uiState.error != null) {
              return Center(
                child: Text(
                  uiState.error ?? 'Something went wrong',
                  style: const TextStyle(color: Colors.red),
                ),
              );
            }

            if (uiState.services.isEmpty) {
              return const Center(child: Text('No services available'));
            }

            return CustomServicesCard(
              services:
                  uiState.services.map((service) {
                    return Service(
                      title: _formatServiceName(service.serviceName),
                      imageUrl: service.image,
                      fontWeight: FontWeight.w400,
                      onTap: () => _navigateToService(context, service),
                    );
                  }).toList(),
            );
          },
        ),
      ),
    );
  }

  String _formatServiceName(String serviceName) {
    // Convert 'service-name' to 'Service Name'
    final words = serviceName.split('-');
    return words
        .map(
          (word) =>
              word.isNotEmpty
                  ? '${word[0].toUpperCase()}${word.substring(1)}'
                  : '',
        )
        .join(' ');
  }

  void _navigateToService(
    BuildContext context,
    PassengerServiceEntity service,
  ) {
    switch (service.serviceName) {
      case 'car':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (context) => PassengerSearchDestinationScreen(
                  serviceType: ServiceType.carBooking,
                  serviceId: service.id,
                ),
          ),
        );
        break;
      case 'emergency-car':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (context) => PassengerSearchDestinationScreen(
                  serviceType: ServiceType.emergencyCar,
                  serviceId: service.id,
                ),
          ),
        );
        break;
      case 'rental-car':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const RentalCarWelcomeScreen(),
          ),
        );
        break;
      case 'package':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (context) => PackagePaymentMethodScreen(serviceId: service.id),
          ),
        );
        break;
      case 'cabwire-share':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (context) => PassengerSearchDestinationScreen(
                  serviceType: ServiceType.cabwireShare,
                  serviceId: service.id,
                ),
          ),
        );
        break;
      default:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (context) =>
                    PassengerSearchDestinationScreen(serviceId: service.id),
          ),
        );
    }
  }
}
