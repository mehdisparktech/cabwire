import 'package:cabwire/core/config/app_screen.dart';
import 'package:cabwire/core/static/ui_const.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DailyEarningsCard extends StatelessWidget {
  final DateTime date;
  final double todayEarning;
  final double cashPayment;
  final double onlinePayment;
  final double walletAmount;

  const DailyEarningsCard({
    super.key,
    required this.date,
    required this.todayEarning,
    required this.cashPayment,
    required this.onlinePayment,
    required this.walletAmount,
  });

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(
      symbol: '\$',
      decimalDigits: 2,
    );

    final dateFormat = DateFormat('MMMM d, yyyy');

    return Card(
      elevation: 1,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: EdgeInsets.all(16.px),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              dateFormat.format(date),
              style: TextStyle(fontSize: 16.px, fontWeight: FontWeight.bold),
            ),
            gapH16,
            _buildEarningRow(
              'Today Total Earning',
              todayEarning,
              currencyFormat,
            ),
            gapH12,

            _buildEarningRow(
              'Cash Payment Received',
              cashPayment,
              currencyFormat,
            ),
            gapH12,
            _buildEarningRow(
              'Online Payment Received',
              onlinePayment,
              currencyFormat,
            ),
            gapH12,
            _buildEarningRow(
              'Wallet Amount',
              walletAmount,
              currencyFormat,
              textColor: walletAmount < 0 ? Colors.red : Colors.black,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEarningRow(
    String label,
    double amount,
    NumberFormat formatter, {
    Color textColor = Colors.black,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 14.px, fontWeight: FontWeight.w500),
        ),
        Text(
          formatter.format(amount),
          style: TextStyle(
            fontSize: 16.px,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
      ],
    );
  }
}
