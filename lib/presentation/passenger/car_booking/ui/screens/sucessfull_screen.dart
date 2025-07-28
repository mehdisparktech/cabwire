import 'package:cabwire/presentation/passenger/main/ui/screens/passenger_main_screen.dart';
import 'package:flutter/material.dart';

import 'package:cabwire/core/config/app_assets.dart';
import 'package:cabwire/core/static/ui_const.dart';
import 'package:cabwire/presentation/common/components/action_button.dart';
import 'package:cabwire/presentation/common/components/custom_app_bar.dart';
import 'package:cabwire/presentation/common/components/common_image.dart';
import 'package:get/get.dart';

class SucessfullScreen extends StatelessWidget {
  const SucessfullScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Trip OverView'),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CommonImage(
              height: 280,
              width: 320,
              imageSrc: AppAssets.icSuccessfulPassenger,
              imageType: ImageType.png,
            ),
            gapH20,
            Text(
              'Payment Successful',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            gapH14,
            Text(
              'Thank you for your payment.\nYour transaction has been successfully processed.',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
      bottomSheet: Padding(
        padding: const EdgeInsets.only(bottom: 16.0),
        child: ActionButton(
          borderRadius: 0,
          isPrimary: true,
          text: 'Done',
          onPressed: () {
            Get.to(PassengerMainPage());
          },
        ),
      ),
    );
  }
}
