import 'package:cabwire/core/config/app_assets.dart';
import 'package:cabwire/core/utility/utility.dart';
import 'package:cabwire/presentation/common/components/common_image.dart';
import 'package:flutter/material.dart';
// import 'package:get/get.dart'; // Not directly using context.theme here

class PaymentInfoWidget extends StatelessWidget {
  const PaymentInfoWidget({
    super.key,
    required this.paymentType,
    required this.amount,
  });
  // If paymentType, amount, and note were dynamic, pass them:
  final String paymentType;
  final String amount;
  // final String note;
  // const PaymentInfoWidget({
  //   super.key,
  //   required this.paymentType,
  //   required this.amount,
  //   required this.note,
  // });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CommonImage(
                imageSrc: AppAssets.icOnlinePayment,
                imageType: ImageType.svg,
                height: 24,
                width: 24,
              ),
              const SizedBox(width: 8),
              Text(
                // Use passed data if dynamic
                paymentType,
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                  color: Color(0xFF1E1E1E),
                ),
              ),
              const Spacer(),
              Text(
                // Use passed data if dynamic
                amount,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.black.withOpacityInt(0.8),
                ),
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.only(top: 4, bottom: 24),
            child: Text(
              // Use passed data if dynamic
              'This is the estimated fare. This may vary.',
              style: TextStyle(fontSize: 12, color: Colors.black54),
            ),
          ),
        ],
      ),
    );
  }
}
