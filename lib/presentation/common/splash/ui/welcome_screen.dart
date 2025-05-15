import 'package:cabwire/core/config/app_assets.dart';
import 'package:cabwire/core/config/app_color.dart';
import 'package:cabwire/core/config/app_screen.dart';
import 'package:cabwire/core/di/service_locator.dart';
import 'package:cabwire/core/static/ui_const.dart';
import 'package:cabwire/core/utility/utility.dart';
import 'package:cabwire/presentation/common/components/common_image.dart';
import 'package:cabwire/presentation/common/splash/presenter/welcome_presenter.dart';
import 'package:cabwire/presentation/common/components/custom_text.dart';
import 'package:flutter/material.dart';

class WelcomeScreen extends StatelessWidget {
  WelcomeScreen({super.key});
  final WelcomePresenter presenter = locate<WelcomePresenter>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.color.backgroundColor,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 16,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(32),
                  boxShadow: [
                    BoxShadow(
                      color: AppColor.primary.withOpacityInt(0.2),
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: CommonImage(
                  AppAssets.icPassengerLogo,
                  width: 80,
                  height: 120,
                ),
              ),
              gapH30,
              CustomText(
                'Welcome To Cabwire',
                fontSize: twentySixPx,
                fontWeight: FontWeight.w700,
                color: context.color.secondaryTextColor,
              ),
              gapH10,
              CustomText(
                'Choose your journey',
                fontSize: sixteenPx,
                fontWeight: FontWeight.w400,
                color: context.color.secondaryTextColor,
              ),
              gapH100,
              _buildOptionButton(
                context,
                'Passenger',
                AppAssets.icPassenger,
                presenter.onPassengerButtonPressed,
                AppColor.passengerButtonPrimaryGradient,
                AppColor.passengerButtonSecondaryGradient,
              ),
              gapH20,
              _buildOptionButton(
                context,
                'Driver',
                AppAssets.icDriver,
                presenter.onDriverButtonPressed,
                AppColor.driverButtonPrimaryGradient,
                AppColor.driverButtonSecondaryGradient,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOptionButton(
    BuildContext context,
    String text,
    String icon,
    VoidCallback onPressed,
    Color gradientStart,
    Color gradientEnd,
  ) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.8,
        padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 14),
        decoration: ShapeDecoration(
          gradient: LinearGradient(
            begin: Alignment(0.00, 0.50),
            end: Alignment(1.00, 0.50),
            colors: [gradientStart, gradientEnd],
          ),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CommonImage(icon, width: 18, height: 18),
            gapW12,
            CustomText(
              text,
              fontSize: eighteenPx,
              fontWeight: FontWeight.bold,
              color: AppColor.white,
            ),
            gapW12,
            CommonImage(
              AppAssets.icArrowRight,
              width: 24,
              height: 24,
              color: AppColor.white,
            ),
          ],
        ),
      ),
    );
  }
}
