import 'package:cabwire/core/config/app_assets.dart';
import 'package:cabwire/core/di/service_locator.dart';
import 'package:cabwire/core/external_libs/presentable_widget_builder.dart';
import 'package:cabwire/presentation/common/components/common_text.dart';
import 'package:cabwire/presentation/common/components/custom_app_bar.dart';
import 'package:cabwire/presentation/common/components/common_image.dart';
import 'package:cabwire/presentation/passenger/passenger_profile/presenter/passenger_profile_presenter.dart';
import 'package:flutter/material.dart';

class PassengerPrivacyPolicyScreen extends StatelessWidget {
  const PassengerPrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final presenter = locate<PassengerProfilePresenter>();
    return PresentableWidgetBuilder(
      presenter: presenter,
      builder: () {
        return Scaffold(
          appBar: CustomAppBar(title: 'Privacy Policy', showBackButton: true),
          body:
              presenter.uiState.value.privacyPolicy?.isEmpty ?? true
                  ? Center(
                    child: CommonImage(
                      height: 220,
                      width: 300,
                      imageSrc: AppAssets.icPassengerNoDataFound,
                      imageType: ImageType.png,
                    ),
                  )
                  : Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: CommonText(
                      text: presenter.uiState.value.privacyPolicy ?? '',
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      textAlign: TextAlign.justify,
                    ),
                  ),
        );
      },
    );
  }
}
