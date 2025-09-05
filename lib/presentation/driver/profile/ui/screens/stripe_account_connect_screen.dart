import 'package:cabwire/core/config/app_assets.dart';
import 'package:cabwire/core/di/service_locator.dart';
import 'package:cabwire/core/static/app_colors.dart';
import 'package:cabwire/core/static/app_strings.dart';
import 'package:cabwire/core/static/ui_const.dart';
import 'package:cabwire/presentation/common/components/auth/custom_button.dart';
import 'package:cabwire/presentation/common/components/common_image.dart';
import 'package:cabwire/presentation/driver/profile/presenter/stripe_account_connect_presenter.dart';
import 'package:flutter/material.dart';

class StripeAccountConnectScreen extends StatelessWidget {
  const StripeAccountConnectScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final presenter = locate<StripeAccountConnectPresenter>();

    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.connectStripe),
        centerTitle: true,
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CommonImage(imageSrc: AppAssets.isStripimg, height: 250, width: 250),
            gapH40,
            _buildLoginButton(context, presenter),
            gapH60,
          ],
          ),
        ),
      ),
    );
  }

  /// Builds the login button
  Widget _buildLoginButton(
    BuildContext context,
    StripeAccountConnectPresenter presenter,
  ) {
    return CustomButton(
      text: AppStrings.connectWithStripe,
      onPressed: () => presenter.onStripeAccountConnect(context),
      isLoading: presenter.uiState.value.isLoading,
    );
  }
}
