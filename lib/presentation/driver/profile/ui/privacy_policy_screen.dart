import 'package:cabwire/core/config/app_assets.dart';
import 'package:cabwire/presentation/common/components/custom_app_bar.dart';
import 'package:cabwire/presentation/driver/profile/widgets/common_image.dart';
import 'package:flutter/material.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Privacy Policy', showBackButton: true),
      body: Center(
        child: CommonImage(
          height: 220,
          width: 300,
          imageSrc: AppAssets.icNoDataFound,
          imageType: ImageType.svg,
        ),
      ),
    );
  }
}
