// import 'package:cabwire/core/config/app_assets.dart';
// import 'package:cabwire/presentation/common/screens/splash/ui/welcome_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// class SplashScreen extends StatelessWidget {
//   const SplashScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     Future.delayed(const Duration(seconds: 3), () {
//       Get.offAll(() => WelcomeScreen()); // Navigate to WelcomeScreen
//     });

//     return Scaffold(
//       body: Stack(
//         fit: StackFit.expand,
//         children: [
//           Image.asset(AppAssets.icSplashScreen, fit: BoxFit.cover),
//           Center(child: Image.asset(AppAssets.icSplashScreenLogo, width: 200)),
//         ],
//       ),
//     );
//   }
// }
