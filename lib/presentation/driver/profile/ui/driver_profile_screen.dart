import 'package:cabwire/core/config/app_assets.dart';
import 'package:cabwire/core/static/ui_const.dart';
import 'package:cabwire/core/utility/utility.dart';
import 'package:cabwire/presentation/driver/profile/ui/contact_us_screen.dart';
import 'package:cabwire/presentation/driver/profile/ui/edit_driving_info_screen.dart';
import 'package:cabwire/presentation/driver/profile/ui/edit_password_screen.dart';
import 'package:cabwire/presentation/driver/profile/ui/edit_profile_info_screen.dart';
import 'package:cabwire/presentation/driver/profile/ui/privacy_policy_screen.dart';
import 'package:cabwire/presentation/driver/profile/ui/terms_and_conditions_screen.dart';
import 'package:cabwire/presentation/driver/profile/widgets/common_image.dart';
import 'package:cabwire/presentation/driver/profile/widgets/common_text.dart';
import 'package:cabwire/presentation/driver/profile/widgets/delete_account_dialog.dart';
import 'package:cabwire/presentation/driver/profile/widgets/item.dart';
import 'package:cabwire/presentation/driver/profile/widgets/logout_dialog.dart';
import 'package:cabwire/presentation/driver/ride_history/ui/ride_history_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DriverProfileScreen extends StatelessWidget {
  const DriverProfileScreen({super.key});

  void showDeleteAccountDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const DeleteAccountDialog(),
    );
  }

  void showLogoutDialog(BuildContext context) {
    showDialog(context: context, builder: (context) => const LogoutDialog());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
        title: CommonText(
          text: 'Profile',
          fontWeight: FontWeight.w700,
          fontSize: 22,
          color: context.theme.colorScheme.onSurface,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 30),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 80,
                    child: ClipOval(
                      child: CommonImage(
                        fill: BoxFit.cover,
                        height: 160,
                        width: 160,
                        imageType: ImageType.png,
                        imageSrc: AppAssets.icProfileImage,
                      ),
                    ),
                  ),
                  gapW25,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CommonText(
                        fontSize: 22,
                        bottom: 10,
                        fontWeight: FontWeight.w700,
                        color: context.theme.colorScheme.onSurface,
                        text: 'John Doe',
                      ),

                      CommonText(
                        fontSize: 16,
                        bottom: 10,
                        fontWeight: FontWeight.w500,
                        color: context.theme.colorScheme.onSurface,
                        text: '1234567890',
                      ),

                      InkWell(
                        onTap: () {
                          Get.to(() => EditProfileInfoScreen());
                        },
                        child: Container(
                          width: 100,
                          height: 40,
                          decoration: BoxDecoration(
                            color: context.theme.colorScheme.primary,
                            borderRadius: BorderRadius.circular(8),
                          ),

                          child: Center(
                            child: CommonText(
                              fontSize: 14,
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                              text: 'Edit Profile',
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacityInt(0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                  ),
                ],
              ),
              padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
              child: Column(
                children: [
                  Item(
                    vertical: 16,
                    image: AppAssets.icPassword,
                    title: 'Password',
                    onTap: () {
                      Get.to(() => EditPasswordScreen());
                    },
                  ),

                  Item(
                    vertical: 16,
                    image: AppAssets.icCar,
                    title: 'Edit Driving Information',
                    onTap: () {
                      Get.to(() => EditDrivingInfoScreen());
                    },
                  ),

                  Item(
                    vertical: 16,
                    image: AppAssets.icHistory,
                    title: 'History',
                    onTap: () {
                      Get.to(() => RideHistoryPage());
                    },
                  ),

                  Item(
                    vertical: 16,
                    image: AppAssets.icTransitionHistory,
                    title: 'Terms & Conditions',
                    onTap: () {
                      Get.to(() => TermsAndConditionsScreen());
                    },
                  ),

                  Item(
                    vertical: 16,
                    image: AppAssets.icTermsCondition,
                    title: 'Privacy Policy',
                    onTap: () {
                      Get.to(() => PrivacyPolicyScreen());
                    },
                  ),

                  Item(
                    vertical: 16,
                    image: AppAssets.icContactUs,
                    title: 'Contact Us',
                    onTap: () {
                      Get.to(() => ContactUsScreen());
                    },
                  ),
                  Item(
                    vertical: 16,
                    image: AppAssets.icDeleteAccount,
                    title: 'Delete Account',
                    onTap: () {
                      showDeleteAccountDialog(context);
                    },
                  ),
                  Item(
                    vertical: 16,
                    image: AppAssets.icLogout,
                    title: 'Log Out',
                    onTap: () {
                      showLogoutDialog(context);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
