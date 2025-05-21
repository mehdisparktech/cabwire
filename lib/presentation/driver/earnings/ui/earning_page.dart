import 'package:cabwire/core/config/app_assets.dart';
import 'package:cabwire/core/utility/utility.dart';
import 'package:cabwire/presentation/common/components/auth/custom_button.dart';
import 'package:cabwire/presentation/driver/earnings/widgets/daily_earnings_card.dart';
import 'package:cabwire/presentation/driver/earnings/widgets/earnings_summary_card.dart';
import 'package:cabwire/presentation/common/components/common_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EarningsPage extends StatelessWidget {
  const EarningsPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Sample data
    final double totalEarnings = 22458.50;
    final double availableEarnings = 2458.50;
    final DateTime currentDate = DateTime(2025, 5, 6);
    final double todayEarning = 2300.25;
    final double cashPayment = 1500.0;
    final double onlinePayment = 800.25;
    final double walletAmount = 200.0;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Earning Details'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
        ),
        elevation: 0,
        actions: [
          GestureDetector(
            onTap: () {
              showMenu(
                context: context,
                position: RelativeRect.fromLTRB(100, 80, 0, 0),
                items: <PopupMenuEntry<String>>[
                  PopupMenuItem<String>(
                    value: 'today',
                    child: Text(
                      'Today',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w200,
                      ),
                    ),
                  ),
                  const PopupMenuDivider(),
                  PopupMenuItem<String>(
                    value: 'week',
                    child: Text(
                      'This Week',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w200,
                      ),
                    ),
                  ),
                  const PopupMenuDivider(),
                  PopupMenuItem<String>(
                    value: 'month',
                    child: Text(
                      'This Month',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w200,
                      ),
                    ),
                  ),
                ],
              );
            },
            child: Container(
              margin: const EdgeInsets.only(right: 10),
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacityInt(0.2),
                    spreadRadius: 2,
                    blurRadius: 5,
                  ),
                ],
              ),
              child: CommonImage(
                imageType: ImageType.svg,
                imageSrc: AppAssets.icSort,
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Earnings Summary Card
              EarningsSummaryCard(
                totalEarnings: totalEarnings,
                availableEarnings: availableEarnings,
              ),

              const SizedBox(height: 20),

              // Daily Earnings Card
              DailyEarningsCard(
                date: currentDate,
                todayEarning: todayEarning,
                cashPayment: cashPayment,
                onlinePayment: onlinePayment,
                walletAmount: walletAmount,
              ),

              const SizedBox(height: 60),

              // Action Buttons
              CustomButton(
                text: 'Withdraw Amount',
                onPressed: () {},
                radius: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
