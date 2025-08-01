import 'package:cabwire/core/config/app_assets.dart';
import 'package:cabwire/core/di/service_locator.dart';
import 'package:cabwire/core/static/ui_const.dart';
import 'package:cabwire/data/models/ride/ride_response_model.dart';
import 'package:cabwire/presentation/common/components/auth/app_logo_display.dart';
import 'package:cabwire/presentation/passenger/car_booking/presenter/passenger_trip_start_otp_presenter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class PassengerTripStartOtpPopup extends StatefulWidget {
  final String otp;
  final String chatId;
  final String rideId;
  final RideResponseModel rideResponse;

  const PassengerTripStartOtpPopup({
    super.key,
    required this.otp,
    required this.chatId,
    required this.rideId,
    required this.rideResponse,
  });

  @override
  State<PassengerTripStartOtpPopup> createState() =>
      _PassengerTripStartOtpPopupState();
}

class _PassengerTripStartOtpPopupState
    extends State<PassengerTripStartOtpPopup> {
  final PassengerTripStartOtpPresenter _presenter =
      locate<PassengerTripStartOtpPresenter>();
  late final List<TextEditingController> otpControllers;

  @override
  void initState() {
    super.initState();
    otpControllers = List.generate(4, (_) => TextEditingController());

    for (int i = 0; i < widget.otp.length && i < 4; i++) {
      otpControllers[i].text = widget.otp[i];
    }

    _presenter.initialize(
      widget.rideId,
      widget.chatId,
      widget.otp,
      widget.rideResponse,
    );

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
      body: SafeArea(
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 50),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Share This OTP ',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
              ),
              gapH20,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                            color: context.theme.colorScheme.primary,
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
              Align(
                alignment: Alignment.center,
                child: ElevatedButton(
                  onPressed: () => Get.back(), // dismiss popup
                  child: const Text("Close"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
