import 'package:cabwire/core/static/ui_const.dart';
import 'package:cabwire/core/utility/utility.dart';
import 'package:cabwire/presentation/common/components/custom_app_bar.dart';
import 'package:cabwire/presentation/driver/home/widgets/ride_action_button.dart';
import 'package:cabwire/presentation/driver/home/widgets/successful_payment.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class RideshareTripCloseOtpPage extends StatelessWidget {
  const RideshareTripCloseOtpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Trip Closure OTP'),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 50),
          child: Column(
            children: [
              _buildOTPInputField(
                context,
                title: 'Green Road, Dhanmondi, Dhaka.',
                otp: '1',
              ),
              gapH20,
              _buildOTPInputField(
                context,
                title: 'Green Road, Dhanmondi, Dhaka.',
                otp: '2',
              ),
              gapH20,
              _buildOTPInputField(
                context,
                title: 'Green Road, Dhanmondi, Dhaka.',
                otp: '3',
              ),
              gapH20,
              _buildOTPInputField(
                context,
                title: 'Green Road, Dhanmondi, Dhaka.',
                otp: '4',
              ),
            ],
          ),
        ),
      ),
      bottomSheet: Padding(
        padding: const EdgeInsets.only(bottom: 16.0),
        child: RideActionButton(
          borderRadius: 0,
          isPrimary: true,
          text: 'Trip Closure',
          onPressed: () {
            Get.to(() => const SuccessfulPayment());
          },
        ),
      ),
    );
  }

  Widget _buildOTPInputField(
    BuildContext context, {
    required String title,
    required String otp,
  }) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: RideActionButton(
                isPrimary: true,
                text: otp,
                onPressed: () {},
              ),
            ),
            gapW10,
            Text(
              title,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),
          ],
        ),
        gapH20,
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ...List.generate(
              4,
              (index) => Container(
                width: 60,
                height: 70,
                padding: const EdgeInsets.only(left: 10),
                child: TextField(
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
            gapW20,
            Expanded(
              child: RideActionButton(
                isPrimary: true,
                text: 'Completed',
                onPressed: () {},
              ),
            ),
          ],
        ),
      ],
    );
  }
}
