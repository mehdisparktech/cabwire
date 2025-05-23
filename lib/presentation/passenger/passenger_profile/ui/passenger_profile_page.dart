import 'package:cabwire/presentation/common/components/custom_app_bar.dart';
import 'package:flutter/material.dart';

class PassengerProfilePage extends StatelessWidget {
  const PassengerProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Profile'),
      body: const Center(child: Text('Welcome to PassengerProfile Page')),
    );
  }
}
