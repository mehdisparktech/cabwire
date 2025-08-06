import 'package:cabwire/core/config/app_assets.dart';
import 'package:cabwire/core/di/service_locator.dart';
import 'package:cabwire/core/external_libs/presentable_widget_builder.dart';
import 'package:cabwire/presentation/common/components/common_text.dart';
import 'package:cabwire/presentation/common/components/custom_app_bar.dart';
import 'package:cabwire/presentation/common/components/common_image.dart';
import 'package:cabwire/presentation/driver/profile/presenter/driver_profile_presenter.dart';
import 'package:flutter/material.dart';

class TermsAndConditionsScreen extends StatelessWidget {
  const TermsAndConditionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final presenter = locate<DriverProfilePresenter>();
    return PresentableWidgetBuilder(
      presenter: presenter,
      builder: () {
        return Scaffold(
          appBar: CustomAppBar(
            title: 'Terms and Conditions',
            showBackButton: true,
          ),
          body:
              presenter.uiState.value.termsAndConditions?.isEmpty ?? true
                  ? Center(
                    child: CommonImage(
                      imageSrc: AppAssets.icNoDataFound,
                      imageType: ImageType.svg,
                      height: 220,
                      width: 300,
                    ),
                  )
                  : SingleChildScrollView(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(24.0),
                      child: CommonText(
                        text: presenter.uiState.value.termsAndConditions ?? '',
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        textAlign: TextAlign.justify,
                        maxLines: 100,
                      ),
                    ),
                  ),
        );
      },
    );
  }
}
