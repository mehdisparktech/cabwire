import 'package:cabwire/core/config/app_assets.dart';
import 'package:cabwire/core/di/service_locator.dart';
import 'package:cabwire/core/static/ui_const.dart';
import 'package:cabwire/core/utility/utility.dart';
import 'package:cabwire/data/models/ride/ride_response_model.dart';
import 'package:cabwire/presentation/common/components/auth/app_logo_display.dart';
import 'package:cabwire/presentation/common/components/custom_app_bar.dart';
import 'package:cabwire/presentation/passenger/car_booking/presenter/ride_share_presenter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class PassengerTripStartOtpPage extends StatefulWidget {
  final String otp;
  final String chatId;
  final String rideId;
  final RideResponseModel rideResponse;
  const PassengerTripStartOtpPage({
    super.key,
    required this.otp,
    required this.chatId,
    required this.rideId,
    required this.rideResponse,
  });

  @override
  State<PassengerTripStartOtpPage> createState() =>
      _PassengerTripStartOtpPage();
}

class _PassengerTripStartOtpPage extends State<PassengerTripStartOtpPage> {
  final RideSharePresenter _presenter = locate<RideSharePresenter>();
  late final List<TextEditingController> otpControllers;

  @override
  void initState() {
    super.initState();
    otpControllers = List.generate(4, (index) => TextEditingController());

    // Set each controller with the corresponding digit
    for (int i = 0; i < widget.otp.length && i < 4; i++) {
      otpControllers[i].text = widget.otp[i];
    }
    _presenter.onStartedPressed(
      context,
      widget.rideId,
      widget.rideResponse,
      widget.chatId,
    );
  }

  @override
  void dispose() {
    for (var controller in otpControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Trip Start OTP'),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 50),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Share This OTP ',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),
            gapH20,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: List.generate(
                4,
                (index) => SizedBox(
                  width: 40,
                  height: 50,
                  child: TextField(
                    readOnly: true,
                    controller: otpControllers[index],
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                          color: context.theme.colorScheme.primary,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                          color: context.theme.colorScheme.primary,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
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
                  ),
                ),
              ),
            ),
            gapH10,
            Text(
              'Please do not share your OTP until your trip has ended.',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
            ),
            gapH80,
            Align(
              alignment: Alignment.center,
              child: AppLogoDisplay(
                logoAssetPath: AppAssets.icPassengerLogo,
                logoAssetPath2: AppAssets.icCabwireLogo,
              ),
            ),
            gapH20,
          ],
        ),
      ),
    );
  }
}
