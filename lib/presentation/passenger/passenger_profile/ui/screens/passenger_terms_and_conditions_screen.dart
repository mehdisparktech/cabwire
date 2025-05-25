import 'package:cabwire/core/config/app_assets.dart';
import 'package:cabwire/presentation/common/components/custom_app_bar.dart';
import 'package:cabwire/presentation/common/components/common_image.dart';
import 'package:flutter/material.dart';

class PassengerTermsAndConditionsScreen extends StatelessWidget {
  const PassengerTermsAndConditionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Terms and Conditions', showBackButton: true),
      body: const Center(
        child: CommonImage(
          imageSrc: AppAssets.icPassengerNoDataFound,
          imageType: ImageType.png,
          height: 220,
          width: 300,
        ),
      ),
    );
  }
}
