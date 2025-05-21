import 'package:cabwire/core/config/app_assets.dart';
import 'package:cabwire/core/di/service_locator.dart';
import 'package:cabwire/core/external_libs/presentable_widget_builder.dart';
import 'package:cabwire/core/static/ui_const.dart'; // For gapW25
// import 'package:cabwire/core/utility/utility.dart'; // For context.theme
import 'package:cabwire/presentation/common/components/common_image.dart';
import 'package:cabwire/presentation/common/components/common_text.dart'; // Assuming this is your custom text
import 'package:cabwire/presentation/driver/profile/presenter/driver_profile_presenter.dart';
import 'package:cabwire/presentation/driver/profile/widgets/item.dart'; // Profile item widget
import 'package:flutter/material.dart';
// import 'package:get/get.dart'; // Navigation handled by presenter

class DriverProfileScreen extends StatelessWidget {
  final DriverProfilePresenter presenter = locate<DriverProfilePresenter>();

  DriverProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          onPressed: presenter.goBack,
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
        title: CommonText(
          // Use your CommonText
          text: 'Profile',
          fontWeight: FontWeight.w700,
          fontSize: 22,
          color:
              Theme.of(context).colorScheme.onSurface, // Use Theme.of(context)
        ),
      ),
      body: PresentableWidgetBuilder(
        presenter: presenter,
        builder: () {
          final uiState = presenter.currentUiState;
          final profile = uiState.userProfile;

          if (uiState.isLoading && profile.name.isEmpty) {
            // Show loader only on initial load
            return const Center(child: CircularProgressIndicator());
          }

          // For displaying user messages (e.g., after an update)
          if (uiState.userMessage!.isNotEmpty) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(uiState.userMessage!)));
              presenter.addUserMessage(''); // Clear message after showing
            });
          }

          return SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 30,
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 60, // Adjusted size
                        backgroundImage:
                            (profile.avatarUrl.isNotEmpty &&
                                    !profile.avatarUrl.startsWith('http'))
                                ? AssetImage(profile.avatarUrl)
                                : null,
                        child:
                            (profile.avatarUrl.isEmpty ||
                                    profile.avatarUrl.startsWith('http'))
                                ? ClipOval(
                                  child: CommonImage(
                                    fill: BoxFit.cover,
                                    height: 120, // Adjusted size
                                    width: 120, // Adjusted size
                                    imageType:
                                        profile.avatarUrl.startsWith('http')
                                            ? ImageType.network
                                            : ImageType.png,
                                    imageSrc:
                                        profile.avatarUrl.isNotEmpty
                                            ? profile.avatarUrl
                                            : AppAssets
                                                .icProfileImage, // Fallback
                                  ),
                                )
                                : null,
                      ),
                      gapW25, // Your constant
                      Expanded(
                        // Added Expanded
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CommonText(
                              fontSize: 22,
                              bottom: 10,
                              fontWeight: FontWeight.w700,
                              color: Theme.of(context).colorScheme.onSurface,
                              text:
                                  profile.name.isNotEmpty
                                      ? profile.name
                                      : "Driver Name",
                            ),
                            CommonText(
                              fontSize: 16,
                              bottom: 10,
                              fontWeight: FontWeight.w500,
                              color: Theme.of(context).colorScheme.onSurface,
                              text:
                                  profile.phoneNumber.isNotEmpty
                                      ? profile.phoneNumber
                                      : "Phone Number",
                            ),
                            InkWell(
                              onTap: presenter.navigateToEditProfile,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ), // Padding for text
                                height: 40,
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.primary,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Center(
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
                      ),
                    ],
                  ),
                ),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.only(
                      // Only top radius for a sheet-like feel
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(
                          0.2,
                        ), // Corrected opacity
                        spreadRadius: 0,
                        blurRadius: 10,
                        offset: const Offset(0, -5), // Shadow upwards
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.symmetric(
                    vertical: 16,
                    horizontal: 24,
                  ),
                  child: Column(
                    children: [
                      Item(
                        vertical: 16,
                        image: AppAssets.icPassword,
                        title: 'Password',
                        onTap: presenter.navigateToEditPassword,
                      ),
                      Item(
                        vertical: 16,
                        image: AppAssets.icCar,
                        title: 'Edit Driving Information',
                        onTap: presenter.navigateToEditDrivingInfo,
                      ),
                      Item(
                        vertical: 16,
                        image: AppAssets.icHistory,
                        title: 'History',
                        onTap: presenter.navigateToHistory,
                      ),
                      Item(
                        vertical: 16,
                        image: AppAssets.icTransitionHistory /* Check Asset */,
                        title: 'Terms & Conditions',
                        onTap: presenter.navigateToTermsAndConditions,
                      ),
                      Item(
                        vertical: 16,
                        image: AppAssets.icTermsCondition /* Check Asset */,
                        title: 'Privacy Policy',
                        onTap: presenter.navigateToPrivacyPolicy,
                      ),
                      Item(
                        vertical: 16,
                        image: AppAssets.icContactUs,
                        title: 'Contact Us',
                        onTap: presenter.navigateToContactUs,
                      ),
                      Item(
                        vertical: 16,
                        image: AppAssets.icDeleteAccount,
                        title: 'Delete Account',
                        onTap: () => presenter.showDeleteAccountDialog(context),
                      ),
                      Item(
                        vertical: 16,
                        image: AppAssets.icLogout,
                        title: 'Log Out',
                        onTap: () => presenter.showLogoutDialog(context),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
