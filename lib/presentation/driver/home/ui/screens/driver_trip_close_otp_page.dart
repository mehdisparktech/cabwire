import 'package:cabwire/core/config/app_assets.dart';
import 'package:cabwire/core/config/app_screen.dart';
import 'package:cabwire/core/di/service_locator.dart';
import 'package:cabwire/core/static/ui_const.dart';
import 'package:cabwire/core/utility/utility.dart';
import 'package:cabwire/presentation/common/components/auth/app_logo_display.dart';
import 'package:cabwire/presentation/common/components/custom_app_bar.dart';
import 'package:cabwire/presentation/common/components/action_button.dart';
import 'package:cabwire/presentation/common/components/custom_text.dart';
import 'package:cabwire/presentation/driver/home/presenter/driver_trip_close_otp_presenter.dart';
import 'package:cabwire/presentation/driver/home/ui/widgets/driver_trip_close_otp_showcase.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:get/get.dart';

class DriverTripCloseOtpPage extends StatefulWidget {
  final String rideId;
  const DriverTripCloseOtpPage({super.key, required this.rideId});

  @override
  State<DriverTripCloseOtpPage> createState() => _DriverTripCloseOtpPageState();
}

class _DriverTripCloseOtpPageState extends State<DriverTripCloseOtpPage> {
  final DriverTripCloseOtpPresenter presenter =
      locate<DriverTripCloseOtpPresenter>();

  final List<TextEditingController> otpControllers = List.generate(
    4,
    (index) => TextEditingController(),
  );

  final List<FocusNode> focusNodes = List.generate(4, (index) => FocusNode());

  @override
  void dispose() {
    for (var controller in otpControllers) {
      controller.dispose();
    }
    for (var node in focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  /// Check if tutorial should be shown and start it with proper ShowCase context
  Future<void> _checkAndShowTutorialWithContext(
    BuildContext showcaseContext,
  ) async {
    final shouldShow = await DriverTripCloseOtpShowcase.shouldShowTutorial();
    if (shouldShow && mounted && showcaseContext.mounted) {
      // Wait for ShowCaseWidget to be ready
      await _waitForShowCaseReady(showcaseContext);
      if (mounted && showcaseContext.mounted) {
        try {
          DriverTripCloseOtpShowcase.startShowcase(showcaseContext);
          await DriverTripCloseOtpShowcase.markTutorialCompleted();
        } catch (e) {
          if (kDebugMode) {
            print('Failed to start tutorial: $e');
          }
        }
      }
    }
  }

  /// Wait for ShowCaseWidget to be ready with timeout
  Future<void> _waitForShowCaseReady(BuildContext showcaseContext) async {
    const maxAttempts = 10;
    const delay = Duration(milliseconds: 200);

    for (int i = 0; i < maxAttempts; i++) {
      if (!mounted || !showcaseContext.mounted) {
        if (kDebugMode) {
          print('Context no longer mounted, stopping wait');
        }
        return;
      }

      if (DriverTripCloseOtpShowcase.isShowCaseReady(showcaseContext)) {
        if (kDebugMode) {
          print('ShowCaseWidget ready after ${i + 1} attempts');
        }
        return;
      }
      await Future.delayed(delay);
    }
    if (kDebugMode) {
      print('ShowCaseWidget not ready after $maxAttempts attempts');
    }
  }

  int getOtpValue() {
    String otpString = '';
    for (var controller in otpControllers) {
      otpString += controller.text;
    }
    return otpString.isEmpty ? 0 : int.parse(otpString);
  }

  @override
  Widget build(BuildContext context) {
    return ShowCaseWidget(
      builder: (showcaseContext) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _checkAndShowTutorialWithContext(showcaseContext);
          });
        });

        return Scaffold(
          appBar: CustomAppBar(title: 'Trip Closure OTP'),
          body: DriverTripCloseOtpShowcase.buildAppBarShowcase(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 30.px,
                  vertical: 50.px,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DriverTripCloseOtpShowcase.buildTitleShowcase(
                      child: CustomText(
                        'Enter OTP To Close This Trip',
                        fontSize: 18.px,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    gapH20,
                    DriverTripCloseOtpShowcase.buildOtpFieldsShowcase(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: List.generate(
                          4,
                          (index) => SizedBox(
                            width: 40.px,
                            height: 50.px,
                            child: TextField(
                              controller: otpControllers[index],
                              focusNode: focusNodes[index],
                              keyboardType: TextInputType.number,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 22.px,
                                fontWeight: FontWeight.bold,
                              ),
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.px),
                                  borderSide: BorderSide(
                                    color: context.theme.colorScheme.primary,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.px),
                                  borderSide: BorderSide(
                                    color: context.theme.colorScheme.primary,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.px),
                                  borderSide: BorderSide(
                                    color: context.color.primaryBtn,
                                    width: 2,
                                  ),
                                ),
                                contentPadding: EdgeInsets.zero,
                              ),
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(1),
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              onChanged: (value) {
                                if (value.isNotEmpty && index < 3) {
                                  focusNodes[index + 1].requestFocus();
                                }
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                    gapH80,
                    DriverTripCloseOtpShowcase.buildLogoShowcase(
                      child: Align(
                        alignment: Alignment.center,
                        child: AppLogoDisplay(
                          logoAssetPath: AppAssets.icDriverLogo,
                          logoAssetPath2: AppAssets.icCabwireLogo,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          bottomSheet: DriverTripCloseOtpShowcase.buildActionButtonShowcase(
            child: Padding(
              padding: EdgeInsets.only(bottom: 16.px),
              child: ActionButton(
                borderRadius: 0,
                isPrimary: true,
                isLoading: presenter.currentUiState.isLoading,
                text: 'Trip Closure',
                onPressed: () {
                  final otp = getOtpValue();
                  if (otp > 0) {
                    presenter.completeRide(widget.rideId, otp);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please enter a valid OTP')),
                    );
                  }
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
