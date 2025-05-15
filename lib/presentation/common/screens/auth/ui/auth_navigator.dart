import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'signup_screen.dart';

class AuthNavigator extends StatefulWidget {
  const AuthNavigator({super.key});

  @override
  State<AuthNavigator> createState() => _AuthNavigatorState();
}

class _AuthNavigatorState extends State<AuthNavigator> {
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
