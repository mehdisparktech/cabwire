import 'package:cabwire/core/config/app_assets.dart';
import 'package:cabwire/core/config/app_color.dart';
import 'package:cabwire/core/config/app_screen.dart';
import 'package:cabwire/core/di/service_locator.dart';
import 'package:cabwire/core/external_libs/presentable_widget_builder.dart';
import 'package:cabwire/core/static/ui_const.dart';
import 'package:cabwire/core/utility/utility.dart';
import 'package:cabwire/presentation/common/components/common_image.dart';
import 'package:cabwire/presentation/common/splash/presenter/welcome_presenter.dart';
import 'package:cabwire/presentation/common/widgets/custom_text.dart';
import 'package:flutter/material.dart';

class WelcomeScreen extends StatelessWidget {
  WelcomeScreen({super.key});
  final WelcomePresenter presenter = locate<WelcomePresenter>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.color.backgroundColor,
      body: Builder(
        builder: (context) {
          return PresentableWidgetBuilder(
            presenter: presenter,
            builder: () {
              return Center(
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
                              color: context.color.primaryColor.withOpacityInt(
                                0.2,
                              ),
                              blurRadius: 10,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: CommonImage(
                          AppAssets.icLogo,
                          width: 80,
                          height: 120,
                        ),
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
                        presenter.onPassengerButtonPressed,
                      ),
                      gapH20,
                      _buildOptionButton(
                        context,
                        'Driver',
                        AppAssets.icDriver,
                        AppColor.driverButtonPrimaryStart,
                        presenter.onDriverButtonPressed,
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
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
}
