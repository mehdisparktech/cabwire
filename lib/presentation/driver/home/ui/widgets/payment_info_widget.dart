import 'package:flutter/material.dart';
// import 'package:get/get.dart'; // Not directly using context.theme here

class PaymentInfoWidget extends StatelessWidget {
  const PaymentInfoWidget({super.key});
  // If paymentType, amount, and note were dynamic, pass them:
  // final String paymentType;
  // final String amount;
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
              const Icon(Icons.payment, color: Colors.black, size: 20),
              const SizedBox(width: 8),
              const Text(
                // Use passed data if dynamic
                'Online Payment',
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
              ),
              const Spacer(),
              Text(
                // Use passed data if dynamic
                '\$100',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.black.withOpacity(0.8),
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
