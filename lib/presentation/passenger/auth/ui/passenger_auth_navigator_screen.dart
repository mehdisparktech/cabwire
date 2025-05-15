import 'package:flutter/material.dart';
import 'passenger_login_screen.dart';
import 'passenger_signup_screen.dart';

class AuthNavigationScreen extends StatefulWidget {
  const AuthNavigationScreen({super.key});

  @override
  State<AuthNavigationScreen> createState() => _AuthNavigationScreenState();
}

class _AuthNavigationScreenState extends State<AuthNavigationScreen> {
  bool _showLogin = true;

  void _toggleView() {
    setState(() {
      _showLogin = !_showLogin;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_showLogin) {
      return LoginScreen(toggleView: _toggleView);
    } else {
      return SignUpScreen(toggleView: _toggleView);
    }
  }
}
