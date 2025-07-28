import 'package:cabwire/core/config/app_assets.dart';
import 'package:cabwire/core/config/app_screen.dart';
import 'package:cabwire/core/static/ui_const.dart';
import 'package:cabwire/core/utility/utility.dart';
import 'package:cabwire/presentation/common/components/common_image.dart';
import 'package:cabwire/presentation/common/components/custom_text.dart';
import 'package:flutter/material.dart';
// import 'package:get/get.dart'; // Not directly using context.theme here

class PaymentInfoWidget extends StatelessWidget {
  final double fare;
  final String paymentType;
  final String note;

  const PaymentInfoWidget({
    super.key,
    required this.fare,
    this.paymentType = 'Online Payment',
    this.note = 'This is the estimated fare. This may vary.',
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.px),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CommonImage(
                imageSrc: AppAssets.icOnlinePayment,
                imageType: ImageType.svg,
                height: 24.px,
                width: 24.px,
              ),
              gapW8,
              CustomText(
                paymentType,
                fontWeight: FontWeight.w700,
                fontSize: 18.px,
                color: Color(0xFF1E1E1E),
              ),
              const Spacer(),
              CustomText(
                '\$${fare.toStringAsFixed(2)}',
                fontWeight: FontWeight.bold,
                fontSize: 18.px,
                color: Colors.black.withOpacityInt(0.8),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(top: 4.px, bottom: 24.px),
            child: CustomText(note, fontSize: 12.px, color: Colors.black54),
          ),
        ],
      ),
    );
  }
}
