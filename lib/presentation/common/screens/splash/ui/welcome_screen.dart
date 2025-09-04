import 'package:cabwire/core/config/app_assets.dart';
import 'package:cabwire/core/config/app_color.dart';
import 'package:cabwire/core/config/app_screen.dart';
import 'package:cabwire/core/di/service_locator.dart';
import 'package:cabwire/core/static/ui_const.dart';
import 'package:cabwire/core/utility/utility.dart';
import 'package:cabwire/presentation/common/components/common_image.dart';
import 'package:cabwire/presentation/common/screens/splash/presenter/welcome_presenter.dart';
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
          padding: EdgeInsets.all(px20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: px12, vertical: px16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(px32),
                  boxShadow: [
                    BoxShadow(
                      color: AppColor.primary.withOpacityInt(0.2),
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: CommonImage(
                  imageSrc: AppAssets.icPassengerLogo,
                  width: px100,
                  height: px100,
                ),
              ),
              gapH30,
              CustomText(
                'Welcome To Cabwire',
                fontSize: px26,
                fontWeight: FontWeight.w700,
                color: context.color.secondaryTextColor,
              ),
              gapH10,
              CustomText(
                'Choose your journey',
                fontSize: px16,
                fontWeight: FontWeight.w400,
                color: context.color.secondaryTextColor,
              ),
              gapH100,
              _buildOptionButton(
                context,
                'Rider',
                AppAssets.icPassenger,
                () => presenter.onPassengerButtonPressed(context),
                AppColor.passengerButtonPrimaryStart,
                AppColor.passengerButtonPrimaryEnd,
              ),
              gapH20,
              _buildOptionButton(
                context,
                'Driver',
                AppAssets.icDriver,
                () => presenter.onDriverButtonPressed(context),
                AppColor.driverButtonPrimaryStart,
                AppColor.driverButtonPrimaryEnd,
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
        padding: EdgeInsets.symmetric(horizontal: px50, vertical: px14),
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
            CommonImage(imageSrc: icon, width: px24, height: px14),
            gapW12,
            CustomText(
              text,
              fontSize: px18,
              fontWeight: FontWeight.bold,
              color: AppColor.white,
            ),
            gapW12,
            CommonImage(
              imageSrc: AppAssets.icArrowRight,
              width: px24,
              height: px24,
              imageColor: AppColor.white,
            ),
          ],
        ),
      ),
    );
  }
}
