import 'package:flutter/material.dart';
import 'driver_login_screen.dart';
import 'driver_signup_screen.dart';

class DriverAuthNavigatorScreen extends StatefulWidget {
  const DriverAuthNavigatorScreen({super.key});

  @override
  State<DriverAuthNavigatorScreen> createState() =>
      _DriverAuthNavigatorScreenState();
}

class _DriverAuthNavigatorScreenState extends State<DriverAuthNavigatorScreen> {
  bool _showLogin = true;

  void _toggleView() {
    setState(() {
      _showLogin = !_showLogin;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_showLogin) {
      return DriverLoginScreen(toggleView: _toggleView);
    } else {
      return DriverSignUpScreen(toggleView: _toggleView);
    }
  }
}
