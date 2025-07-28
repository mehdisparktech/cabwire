import 'package:cabwire/core/config/app_assets.dart';
import 'package:cabwire/core/config/app_screen.dart';
import 'package:cabwire/core/di/service_locator.dart';
import 'package:cabwire/core/static/ui_const.dart';
import 'package:cabwire/core/utility/utility.dart';
import 'package:cabwire/presentation/common/components/auth/app_logo_display.dart';
import 'package:cabwire/presentation/common/components/custom_app_bar.dart';
import 'package:cabwire/presentation/common/components/action_button.dart';
import 'package:cabwire/presentation/common/components/custom_text.dart';
import 'package:cabwire/presentation/driver/home/presenter/driver_trip_close_otp_presenter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class DriverTripCloseOtpPage extends StatefulWidget {
  final String rideId;
  const DriverTripCloseOtpPage({super.key, required this.rideId});

  @override
  State<DriverTripCloseOtpPage> createState() => _DriverTripCloseOtpPageState();
}

class _DriverTripCloseOtpPageState extends State<DriverTripCloseOtpPage> {
  final DriverTripCloseOtpPresenter presenter =
      locate<DriverTripCloseOtpPresenter>();

  final List<TextEditingController> otpControllers = List.generate(
    4,
    (index) => TextEditingController(),
  );

  final List<FocusNode> focusNodes = List.generate(4, (index) => FocusNode());

  @override
  void dispose() {
    for (var controller in otpControllers) {
      controller.dispose();
    }
    for (var node in focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  int getOtpValue() {
    String otpString = '';
    for (var controller in otpControllers) {
      otpString += controller.text;
    }
    return otpString.isEmpty ? 0 : int.parse(otpString);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Trip Closure OTP'),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 30.px, vertical: 50.px),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText(
              'Enter OTP To Close This Trip',
              fontSize: 18.px,
              fontWeight: FontWeight.w700,
            ),
            gapH20,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: List.generate(
                4,
                (index) => SizedBox(
                  width: 40.px,
                  height: 50.px,
                  child: TextField(
                    controller: otpControllers[index],
                    focusNode: focusNodes[index],
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 22.px,
                      fontWeight: FontWeight.bold,
                    ),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.px),
                        borderSide: BorderSide(
                          color: context.theme.colorScheme.primary,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.px),
                        borderSide: BorderSide(
                          color: context.theme.colorScheme.primary,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.px),
                        borderSide: BorderSide(
                          color: context.color.primaryBtn,
                          width: 2,
                        ),
                      ),
                      contentPadding: EdgeInsets.zero,
                    ),
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(1),
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    onChanged: (value) {
                      if (value.isNotEmpty && index < 3) {
                        focusNodes[index + 1].requestFocus();
                      }
                    },
                  ),
                ),
              ),
            ),
            gapH80,
            Align(
              alignment: Alignment.center,
              child: AppLogoDisplay(
                logoAssetPath: AppAssets.icDriverLogo,
                logoAssetPath2: AppAssets.icCabwireLogo,
              ),
            ),
          ],
        ),
      ),
      bottomSheet: Padding(
        padding: EdgeInsets.only(bottom: 16.px),
        child: ActionButton(
          borderRadius: 0,
          isPrimary: true,
          isLoading: presenter.currentUiState.isLoading,
          text: 'Trip Closure',
          onPressed: () {
            final otp = getOtpValue();
            if (otp > 0) {
              presenter.completeRide(widget.rideId, otp);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Please enter a valid OTP')),
              );
            }
          },
        ),
      ),
    );
  }
}
