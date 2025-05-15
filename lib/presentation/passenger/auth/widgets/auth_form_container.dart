import 'package:flutter/material.dart';
import 'package:cabwire/core/config/app_assets.dart';
import 'package:cabwire/core/static/ui_const.dart';
import 'app_logo_display.dart';

class AuthFormContainer extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final List<Widget> formFields;
  final Widget actionButton;
  final List<Widget> bottomWidgets;
  final bool showLogo;

  const AuthFormContainer({
    super.key,
    required this.formKey,
    required this.formFields,
    required this.actionButton,
    this.bottomWidgets = const [],
    this.showLogo = true,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (showLogo) ...[
            AppLogoDisplay(
              logoAssetPath: AppAssets.icPassengerLogo,
              logoAssetPath2: AppAssets.icCabwireLogo,
            ),
            gapH30,
          ],
          ...formFields,
          gapH30,
          actionButton,
          if (bottomWidgets.isNotEmpty) ...[gapH20, ...bottomWidgets],
        ],
      ),
    );
  }
}
