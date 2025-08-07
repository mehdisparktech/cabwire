import 'package:cabwire/core/config/api/api_end_point.dart';
import 'package:cabwire/core/config/app_assets.dart';
import 'package:cabwire/core/config/app_screen.dart';
import 'package:cabwire/core/di/service_locator.dart';
import 'package:cabwire/core/external_libs/presentable_widget_builder.dart';
import 'package:cabwire/core/static/ui_const.dart'; // For gapW25
import 'package:cabwire/core/utility/utility.dart';
import 'package:cabwire/data/services/storage/storage_services.dart';
// import 'package:cabwire/core/utility/utility.dart'; // For context.theme
import 'package:cabwire/presentation/common/components/common_image.dart';
import 'package:cabwire/presentation/common/components/common_text.dart'; // Assuming this is your custom text
import 'package:cabwire/presentation/driver/profile/ui/widgets/item.dart'; // Profile item widget
import 'package:cabwire/presentation/passenger/passenger_profile/presenter/passenger_profile_presenter.dart';
import 'package:flutter/material.dart';
// import 'package:get/get.dart'; // Navigation handled by presenter

class PassengerProfileScreen extends StatelessWidget {
  final PassengerProfilePresenter presenter =
      locate<PassengerProfilePresenter>();

  PassengerProfileScreen({super.key});

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
          fontSize: 22.px,
          color:
              Theme.of(context).colorScheme.onSurface, // Use Theme.of(context)
        ),
      ),
      body: PresentableWidgetBuilder(
        presenter: presenter,
        builder: () {
          final uiState = presenter.currentUiState;
          final profile = uiState.passengerProfile;

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
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.px,
                    vertical: 30.px,
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 60.px, // Adjusted size
                        child: ClipOval(
                          child: CommonImage(
                            fill: BoxFit.cover,
                            height: 120.px, // Adjusted size
                            width: 120.px, // Adjusted size
                            imageType: ImageType.network,
                            imageSrc:
                                ApiEndPoint.imageUrl + LocalStorage.myImage,
                          ),
                        ),
                      ),
                      gapW25, // Your constant
                      Expanded(
                        // Added Expanded
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CommonText(
                              fontSize: 22.px,
                              bottom: 10.px,
                              fontWeight: FontWeight.w700,
                              color: Theme.of(context).colorScheme.onSurface,
                              text:
                                  profile.name.isNotEmpty
                                      ? profile.name
                                      : "Mehdi Hasan",
                            ),
                            CommonText(
                              fontSize: 16.px,
                              bottom: 10.px,
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
                                padding: EdgeInsets.symmetric(
                                  horizontal: 16.px,
                                  vertical: 8.px,
                                ), // Padding for text
                                height: 40.px,
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.primary,
                                  borderRadius: BorderRadius.circular(8.px),
                                ),
                                child: Center(
                                  child: CommonText(
                                    fontSize: 14.px,
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
                    borderRadius: BorderRadius.only(
                      // Only top radius for a sheet-like feel
                      topLeft: Radius.circular(20.px),
                      topRight: Radius.circular(20.px),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacityInt(
                          0.2,
                        ), // Corrected opacity
                        spreadRadius: 0,
                        blurRadius: 10,
                        offset: const Offset(0, -5), // Shadow upwards
                      ),
                    ],
                  ),
                  padding: EdgeInsets.symmetric(
                    vertical: 16.px,
                    horizontal: 24.px,
                  ),
                  child: Column(
                    children: [
                      Item(
                        vertical: 16.px,
                        image: AppAssets.icPassword,
                        title: 'Password',
                        onTap: presenter.navigateToEditPassword,
                      ),

                      Item(
                        vertical: 16.px,
                        image: AppAssets.icTransitionHistory /* Check Asset */,
                        title: 'Terms & Conditions',
                        onTap: presenter.navigateToTermsAndConditions,
                      ),
                      Item(
                        vertical: 16.px,
                        image: AppAssets.icTermsCondition /* Check Asset */,
                        title: 'Privacy Policy',
                        onTap: presenter.navigateToPrivacyPolicy,
                      ),
                      Item(
                        vertical: 16.px,
                        image: AppAssets.icContactUs,
                        title: 'Contact Us',
                        onTap: presenter.navigateToContactUs,
                      ),
                      Item(
                        vertical: 16.px,
                        image: AppAssets.icDeleteAccount,
                        title: 'Delete Account',
                        onTap: () => presenter.showDeleteAccountDialog(context),
                      ),
                      Item(
                        vertical: 16.px,
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
