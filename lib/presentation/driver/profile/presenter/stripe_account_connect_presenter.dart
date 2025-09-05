import 'package:cabwire/core/base/base_presenter.dart';
import 'package:cabwire/core/config/api/api_end_point.dart';
import 'package:cabwire/core/external_libs/flutter_toast/custom_toast.dart';
import 'package:cabwire/core/utility/log/app_log.dart';
import 'package:cabwire/core/utility/navigation_utility.dart';
import 'package:cabwire/data/services/storage/storage_services.dart';
import 'package:cabwire/domain/services/api_service.dart';
import 'package:cabwire/presentation/driver/profile/presenter/stripe_account_connect_ui_state.dart';
import 'package:cabwire/presentation/driver/profile/ui/screens/driver_profile_screen.dart';
import 'package:cabwire/presentation/driver/profile/ui/screens/stripe_account_connect_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

class StripeAccountConnectPresenter extends BasePresenter<StripeAccountConnectUiState> {
  final ApiService _apiService;
    WebViewController? webViewController;
  final Obs<StripeAccountConnectUiState> uiState = Obs<StripeAccountConnectUiState>(StripeAccountConnectUiState.empty());
  StripeAccountConnectUiState get currentUiState => uiState.value;

  StripeAccountConnectPresenter(this._apiService);

  //===================>> Stripe

  Future<void> onStripeAccountConnect(BuildContext context) async {
    toggleLoading(loading: true);

    try {
      final result = await _apiService.post(
        ApiEndPoint.stripeConnected + LocalStorage.myEmail,
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
                    NavigationUtility.fadePush(
                      context,
                      const DriverProfileScreen(),
                    );
                  } else if (url.contains("failed") || url.contains("cancel")) {
                    NavigationUtility.fadePush(
                      context,
                      const DriverProfileScreen(),
                    );
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