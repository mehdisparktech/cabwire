import 'package:cabwire/core/config/app_assets.dart';
import 'package:cabwire/presentation/common/components/custom_app_bar.dart';
import 'package:cabwire/presentation/driver/profile/widgets/common_image.dart';
import 'package:flutter/material.dart';

class TermsAndConditionsScreen extends StatelessWidget {
  const TermsAndConditionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Terms and Conditions', showBackButton: true),
      body: const Center(
        child: CommonImage(
          imageSrc: AppAssets.icNoDataFound,
          imageType: ImageType.svg,
          height: 220,
          width: 300,
        ),
      ),
    );
  }
}
