import 'package:cabwire/core/config/app_assets.dart';
import 'package:cabwire/core/static/ui_const.dart';
import 'package:cabwire/presentation/common/components/action_button.dart';
import 'package:cabwire/presentation/common/components/custom_app_bar.dart';
import 'package:cabwire/presentation/driver/main/ui/driver_main_page.dart';
import 'package:cabwire/presentation/driver/profile/widgets/common_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SuccessfulPayment extends StatelessWidget {
  const SuccessfulPayment({super.key});

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
              imageSrc: AppAssets.icSuccessful,
              imageType: ImageType.png,
            ),
            gapH20,
            Text(
              'Payment Received',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            gapH14,
            Text('Payment received! Thank you for your transaction.'),
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
            Get.to(DriverMainPage());
          },
        ),
      ),
    );
  }
}
