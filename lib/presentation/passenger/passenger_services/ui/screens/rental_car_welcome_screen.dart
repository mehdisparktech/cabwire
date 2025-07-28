import 'package:cabwire/core/config/app_assets.dart';
import 'package:cabwire/core/static/ui_const.dart';
import 'package:cabwire/presentation/common/components/action_button.dart';
import 'package:cabwire/presentation/common/components/custom_app_bar.dart';
import 'package:cabwire/presentation/common/components/custom_text.dart';
import 'package:cabwire/presentation/passenger/passenger_services/ui/screens/rental_info_screen.dart';
import 'package:cabwire/presentation/common/components/common_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RentalCarWelcomeScreen extends StatelessWidget {
  final String? serviceId;
  const RentalCarWelcomeScreen({super.key, this.serviceId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Rental Car'),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CommonImage(
            imageType: ImageType.png,
            imageSrc: AppAssets.icRentalCar,
            width: double.infinity,
            height: 300,
          ),
          gapH20,
          CustomText(
            'Welcome to our Rental Service',
            fontSize: 20,
            fontWeight: FontWeight.bold,
            textAlign: TextAlign.center,
          ),
          gapH10,
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: CustomText(
              'Choose from a variety of well-maintained vehicles for both short and long-term rentals. Whether you’re planning a quick trip or an extended journey, we’ve got the perfect car for you. Complete your profile and booking to start your seamless experience.',
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: context.theme.colorScheme.onSurface,
              textAlign: TextAlign.justify,
            ),
          ),
          gapH60,
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: ActionButton(
              text: 'Get Started',
              isPrimary: true,
              onPressed: () {
                Get.to(() => RentalInfoScreen(serviceId: serviceId));
              },
            ),
          ),
        ],
      ),
    );
  }
}
