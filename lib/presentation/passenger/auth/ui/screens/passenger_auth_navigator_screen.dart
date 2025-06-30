import 'package:flutter/material.dart';
import 'package:cabwire/presentation/passenger/auth/ui/screens/passenger_login_screen.dart';
import 'package:cabwire/presentation/passenger/auth/ui/screens/passenger_signup_screen.dart';

class PassengerAuthNavigationScreen extends StatefulWidget {
  const PassengerAuthNavigationScreen({super.key});

  @override
  State<PassengerAuthNavigationScreen> createState() =>
      _PassengerAuthNavigationScreenState();
}

class _PassengerAuthNavigationScreenState
    extends State<PassengerAuthNavigationScreen> {
  bool _showLogin = true;

  void _toggleView() {
    setState(() {
      _showLogin = !_showLogin;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_showLogin) {
      return PassengerLoginScreen(toggleView: _toggleView);
    } else {
      return PassengerSignUpScreen(toggleView: _toggleView);
    }
  }
}
