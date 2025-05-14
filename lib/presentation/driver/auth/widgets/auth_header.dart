import 'package:cabwire/core/utility/utility.dart';
import 'package:flutter/material.dart';
import 'status_bar_mock.dart';

class AuthHeader extends StatelessWidget {
  final String title;
  final String subtitle;

  const AuthHeader({super.key, required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24), // Original padding
      decoration: BoxDecoration(
        color: context.color.primaryBtn,
        gradient: LinearGradient(
          begin: Alignment(-0.00, 0.50),
          end: Alignment(1.00, 0.50),
          colors: [
            context.color.primaryGradient,
            context.color.secondaryGradient,
          ],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const StatusBarMock(), // Status bar is part of the header
          const SizedBox(height: 16),
          Text(title, style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 4),
          Text(subtitle, style: Theme.of(context).textTheme.titleMedium),
        ],
      ),
    );
  }
}
