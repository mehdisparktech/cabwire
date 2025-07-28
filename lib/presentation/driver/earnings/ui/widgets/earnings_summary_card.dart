import 'package:cabwire/core/config/app_screen.dart';
import 'package:cabwire/core/static/ui_const.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EarningsSummaryCard extends StatelessWidget {
  final double totalEarnings;
  final double availableEarnings;

  const EarningsSummaryCard({
    super.key,
    required this.totalEarnings,
    required this.availableEarnings,
  });

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(
      symbol: '\$',
      decimalDigits: 2,
    );

    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: Colors.white,
      child: Padding(
        padding: EdgeInsets.all(16.px),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Total Earnings',
              style: TextStyle(
                fontSize: 16.px,
                color: Colors.black87,
                fontWeight: FontWeight.w500,
              ),
            ),
            gapH8,
            Text(
              currencyFormat.format(totalEarnings),
              style: TextStyle(
                fontSize: 28.px,
                fontWeight: FontWeight.bold,
                color: Colors.orange[700],
              ),
            ),
            Divider(height: 24.px, color: Colors.grey),
            Text(
              'Today Available Earnings',
              style: TextStyle(
                fontSize: 16.px,
                color: Colors.black87,
                fontWeight: FontWeight.w500,
              ),
            ),
            gapH8,
            Text(
              currencyFormat.format(availableEarnings),
              style: TextStyle(
                fontSize: 28.px,
                fontWeight: FontWeight.bold,
                color: Colors.orange[700],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
