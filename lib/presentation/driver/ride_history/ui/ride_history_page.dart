import 'package:flutter/material.dart';

class RideHistoryPage extends StatelessWidget {
  const RideHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('RideHistory Page'),
      ),
      body: const Center(
        child: Text('Welcome to RideHistory Page'),
      ),
    );
  }
}
