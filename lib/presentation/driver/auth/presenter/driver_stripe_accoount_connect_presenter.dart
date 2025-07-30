import 'package:cabwire/core/base/base_presenter.dart';
import 'package:cabwire/core/config/api/api_end_point.dart';
import 'package:cabwire/core/di/service_locator.dart';
import 'package:cabwire/core/external_libs/flutter_toast/custom_toast.dart';
import 'package:cabwire/core/utility/log/app_log.dart';
import 'package:cabwire/domain/services/api_service.dart';
import 'package:cabwire/presentation/driver/auth/presenter/driver_stripe_accoount_connect_ui_state.dart';
import 'package:cabwire/presentation/driver/auth/presenter/utils/driver_sign_up_navigation.dart';
import 'package:cabwire/presentation/driver/auth/ui/screens/driver_auth_navigator_screen.dart';
import 'package:cabwire/presentation/driver/auth/ui/screens/stripe_account_connect_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

class DriverStripeAccoountConnectPresenter
    extends BasePresenter<DriverStripeAccoountConnectUiState> {
  final ApiService _apiService = locate<ApiService>();
  late final DriverSignUpNavigation _navigation;
  WebViewController? webViewController;

  final Obs<DriverStripeAccoountConnectUiState> uiState = Obs(
    DriverStripeAccoountConnectUiState.empty(),
  );
  DriverStripeAccoountConnectUiState get currentUiState => uiState.value;

  // onStripeAccountConnect(BuildContext context) {
  //   if (context.mounted) {
  //     _navigation.navigateWithFadeTransition(
  //       context,
  //       const DriverAuthNavigatorScreen(),
  //       clearStack: true,
  //     );
  //   }
  // }

  //===================>> Stripe

  Future<void> onStripeAccountConnect(BuildContext context, email) async {
    toggleLoading(loading: true);

    try {
      final result = await _apiService.post(
        ApiEndPoint.stripeConnected + email,
      );

      result.fold(
        (error) {
          CustomToast(message: error.message);
        },
        (success) {
          CustomToast(message: success.message ?? '');
          appLog("success.data: ${success.data}");
          appLog("success.data['data']['url']: ${success.data['data']['url']}");
          stripePaymentByWebview(
            paymentUrl: success.data['data']['url'],
            context: context,
          );
        },
      );
    } catch (e) {
      CustomToast(message: e.toString());
    } finally {
      toggleLoading(loading: false);
    }
  }

  //===================>> stripe connect by webview

  stripePaymentByWebview({
    required String paymentUrl,
    required BuildContext context,
  }) {
    if (paymentUrl.isNotEmpty) {
      Get.to(() => StripeAccountConnectScreen());

      webViewController =
          WebViewController()
            ..setJavaScriptMode(JavaScriptMode.unrestricted)
            ..setNavigationDelegate(
              NavigationDelegate(
                onNavigationRequest: (NavigationRequest request) {
                  appLog("🔁 onNavigationRequest: ${request.url}");
                  return NavigationDecision.navigate;
                },
                onPageStarted: (url) {
                  appLog("📄 onPageStarted: $url");
                  toggleLoading(loading: true);
                },
                onPageFinished: (url) {
                  appLog("✅ onPageFinished: $url");
                  toggleLoading(loading: false);

                  if (url.contains("success-account")) {
                    _navigation.navigateWithFadeTransition(
                      context,
                      const DriverAuthNavigatorScreen(),
                      clearStack: true,
                    );
                  } else if (url.contains("failed") || url.contains("cancel")) {
                    Get.back();
                  }
                },
                onWebResourceError: (error) {
                  appLog("❌ WebView Error: ${error.description}");
                },
              ),
            )
            ..loadRequest(Uri.parse(paymentUrl));

      toggleLoading(loading: false);
    }
  }

  @override
  Future<void> addUserMessage(String message) async {
    uiState.value = currentUiState.copyWith(userMessage: message);
  }

  @override
  Future<void> toggleLoading({required bool loading}) async {
    uiState.value = currentUiState.copyWith(isLoading: loading);
  }
}
