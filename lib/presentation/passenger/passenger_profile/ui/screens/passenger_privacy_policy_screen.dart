import 'package:cabwire/core/config/app_assets.dart';
import 'package:cabwire/presentation/common/components/custom_app_bar.dart';
import 'package:cabwire/presentation/common/components/common_image.dart';
import 'package:flutter/material.dart';

class PassengerPrivacyPolicyScreen extends StatelessWidget {
  const PassengerPrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Privacy Policy', showBackButton: true),
      body: Center(
        child: CommonImage(
          height: 220,
          width: 300,
          imageSrc: AppAssets.icPassengerNoDataFound,
          imageType: ImageType.png,
        ),
      ),
    );
  }
}
