import 'package:cabwire/core/config/app_assets.dart';
import 'package:cabwire/core/config/app_color.dart';
import 'package:cabwire/core/config/app_screen.dart';
import 'package:cabwire/core/static/ui_const.dart';
import 'package:cabwire/core/utility/utility.dart';
import 'package:cabwire/presentation/common/common_image.dart';
import 'package:cabwire/presentation/common/widgets/custom_text.dart';
import 'package:cabwire/presentation/passenger/onboarding/ui/passenger_onboarding_screen.dart';
import 'package:cabwire/presentation/driver/onboarding/ui/driver_onboarding_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.color.backgroundColor,
      body: SafeArea(
        child: Center(
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
                        color: context.color.primaryColor.withOpacityInt(0.2),
                        blurRadius: 10,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: CommonImage(AppAssets.icLogo, width: 80, height: 120),
                ),
                gapH30,
                CustomText(
                  'Welcome To Cabwire',
                  fontSize: twentyFourPx,
                  fontWeight: FontWeight.bold,
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
                  context.color.primaryColor,
                  () => _navigateToPassengerOnboarding(context),
                ),
                gapH20,
                _buildOptionButton(
                  context,
                  'Driver',
                  AppAssets.icDriver,
                  AppColor.driverButtonPrimaryStart,
                  () => _navigateToDriverOnboarding(context),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOptionButton(
    BuildContext context,
    String text,
    String icon,
    Color? color,
    VoidCallback onPressed,
  ) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: color ?? context.color.primaryColor,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color ?? context.color.primaryColor),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CommonImage(icon, width: 20, height: 20),
            gapW12,
            CustomText(
              text,
              fontSize: eighteenPx,
              fontWeight: FontWeight.bold,
              color: context.color.btnText,
            ),
            CommonImage(
              AppAssets.icArrowRight,
              width: 24,
              height: 24,
              color: context.color.btnText,
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToPassengerOnboarding(BuildContext context) {
    // Set passenger theme if needed
    // Get.changeTheme(passengerTheme);

    // Navigate to passenger onboarding
    Get.to(() => PassengerOnboardingScreen());
  }

  void _navigateToDriverOnboarding(BuildContext context) {
    // Set driver theme if needed
    // Get.changeTheme(driverTheme);

    // Navigate to driver onboarding
    Get.to(() => DriverOnboardingScreen());
  }
}
