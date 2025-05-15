import 'package:flutter/material.dart';
import 'package:cabwire/core/utility/utility.dart';
import 'auth_header.dart';

class AuthScreenWrapper extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget child;
  final bool isScrollable;
  final EdgeInsets contentPadding;

  const AuthScreenWrapper({
    super.key,
    required this.title,
    required this.subtitle,
    required this.child,
    this.isScrollable = true,
    this.contentPadding = const EdgeInsets.all(24),
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.color.primaryGradient,
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: const Alignment(-0.00, 0.50),
              end: const Alignment(1.00, 0.50),
              colors: [
                context.color.primaryGradient,
                context.color.secondaryGradient,
              ],
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AuthHeader(title: title, subtitle: subtitle, color: Colors.black),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: context.color.whiteColor,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(24),
                      topRight: Radius.circular(24),
                    ),
                  ),
                  child:
                      isScrollable
                          ? SingleChildScrollView(
                            padding: contentPadding,
                            child: child,
                          )
                          : Padding(padding: contentPadding, child: child),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
