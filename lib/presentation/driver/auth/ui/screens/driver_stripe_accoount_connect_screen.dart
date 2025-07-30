import 'package:cabwire/core/config/app_assets.dart';
import 'package:cabwire/core/di/service_locator.dart';
import 'package:cabwire/core/static/app_strings.dart';
import 'package:cabwire/core/static/ui_const.dart';
import 'package:cabwire/core/utility/utility.dart';
import 'package:cabwire/presentation/common/components/auth/auth_screen_wrapper.dart';
import 'package:cabwire/presentation/common/components/auth/custom_button.dart';
import 'package:cabwire/presentation/common/components/common_image.dart';
import 'package:cabwire/presentation/driver/auth/presenter/driver_stripe_accoount_connect_presenter.dart';
import 'package:flutter/material.dart';

class DriverStripeAccoountConnectScreen extends StatelessWidget {
  const DriverStripeAccoountConnectScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final presenter = locate<DriverStripeAccoountConnectPresenter>();

    return AuthScreenWrapper(
      title: AppStrings.connectStripe,
      subtitle: AppStrings.connectStripeSubtitle,
      textColor: context.color.blackColor100,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          gapH100,
          CommonImage(imageSrc: AppAssets.isStripimg, height: 250, width: 250),
          gapH40,
          _buildLoginButton(context, presenter),
        ],
      ),
    );
  }

  /// Builds the login button
  Widget _buildLoginButton(
    BuildContext context,
    DriverStripeAccoountConnectPresenter presenter,
  ) {
    return CustomButton(
      text: AppStrings.connectWithStripe,
      onPressed: () => presenter.onStripeAccountConnect(context),
    );
  }
}
