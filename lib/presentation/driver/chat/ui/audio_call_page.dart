import 'dart:ui';

import 'package:cabwire/core/config/app_assets.dart';
import 'package:cabwire/core/utility/utility.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AudioCallScreen extends StatelessWidget {
  const AudioCallScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background image with blur
          _buildBlurredBackground(),

          // Back button
          _buildBackButton(),

          // Caller profile
          _buildCallerProfile(),

          // Call duration
          _buildCallDuration(),

          // Call controls
          _buildCallControls(),
        ],
      ),
    );
  }

  Widget _buildBlurredBackground() {
    return Stack(
      fit: StackFit.expand,
      children: [
        // This would be the actual image in a real app
        Image.asset(AppAssets.icProfileImage, fit: BoxFit.cover),
        // Blur filter
        BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(color: Colors.black.withOpacityInt(0.3)),
        ),
      ],
    );
  }

  Widget _buildBackButton() {
    return Positioned(
      top: 40,
      left: 16,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black.withOpacityInt(0.3),
          shape: BoxShape.circle,
        ),
        child: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.white,
          ),
          onPressed: () {
            Get.back();
          },
        ),
      ),
    );
  }

  Widget _buildCallerProfile() {
    return Positioned(
      top: 300,
      left: 0,
      right: 0,
      child: Column(
        children: [
          // Circular avatar
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2),
            ),
            child: ClipOval(
              child: Image.asset(AppAssets.icProfileImage, fit: BoxFit.cover),
            ),
          ),
          const SizedBox(height: 10),
          // Caller name
          const Text(
            'John Doe',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCallDuration() {
    return Positioned(
      bottom: 120,
      left: 0,
      right: 0,
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.black.withOpacityInt(0.5),
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Text(
            '03:45',
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCallControls() {
    return Positioned(
      bottom: 50,
      left: 0,
      right: 0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildControlButton(Icons.mic, Colors.white.withOpacityInt(0.3)),
          const SizedBox(width: 20),
          _buildEndCallButton(),
          const SizedBox(width: 20),
          _buildControlButton(
            Icons.volume_up,
            Colors.white.withOpacityInt(0.3),
          ),
        ],
      ),
    );
  }

  Widget _buildControlButton(IconData icon, Color backgroundColor) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(color: backgroundColor, shape: BoxShape.circle),
      child: Icon(icon, color: Colors.white, size: 24),
    );
  }

  Widget _buildEndCallButton() {
    return InkWell(
      onTap: () => Get.back(),
      child: Container(
        width: 60,
        height: 60,
        decoration: const BoxDecoration(
          color: Colors.red,
          shape: BoxShape.circle,
        ),
        child: const Icon(Icons.call_end, color: Colors.white, size: 30),
      ),
    );
  }
}

// In a real app, create a custom stateful widget with an actual timer for the call duration
class CallTimer extends StatefulWidget {
  const CallTimer({super.key});

  @override
  State<CallTimer> createState() => _CallTimerState();
}

class _CallTimerState extends State<CallTimer> {
  final String _duration = '00:00';

  @override
  Widget build(BuildContext context) {
    return Text(_duration, style: context.theme.textTheme.bodyMedium);
  }
}
