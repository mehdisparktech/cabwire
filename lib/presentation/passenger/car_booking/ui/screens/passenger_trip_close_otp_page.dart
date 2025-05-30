import 'package:cabwire/core/config/app_assets.dart';
import 'package:cabwire/core/static/ui_const.dart';
import 'package:cabwire/core/utility/utility.dart';
import 'package:cabwire/presentation/common/components/auth/app_logo_display.dart';
import 'package:cabwire/presentation/common/components/custom_app_bar.dart';
import 'package:cabwire/presentation/passenger/car_booking/ui/screens/car_booking_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class PassengerTripCloseOtpPage extends StatefulWidget {
  const PassengerTripCloseOtpPage({super.key});

  @override
  State<PassengerTripCloseOtpPage> createState() =>
      _PassengerTripCloseOtpPageState();
}

class _PassengerTripCloseOtpPageState extends State<PassengerTripCloseOtpPage> {
  final otpController = TextEditingController()..text = '1';

  @override
  void initState() {
    super.initState();
    _onForwardPressed();
  }

  Future<void> _onForwardPressed() async {
    await Future.delayed(const Duration(seconds: 5));

    if (context.mounted) {
      Navigator.push(
        // ignore: use_build_context_synchronously
        context,
        MaterialPageRoute(builder: (context) => CarBookingDetailsScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Trip Closure OTP'),
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
                    controller: otpController,
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
