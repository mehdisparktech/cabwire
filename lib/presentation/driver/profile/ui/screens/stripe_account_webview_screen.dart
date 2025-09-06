import 'package:cabwire/core/di/service_locator.dart';
import 'package:cabwire/core/external_libs/presentable_widget_builder.dart';
import 'package:cabwire/core/static/app_colors.dart';
import 'package:cabwire/presentation/common/components/loading_indicator.dart';
import 'package:cabwire/presentation/driver/profile/presenter/stripe_account_connect_presenter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

class StripeAccountWebScreen extends StatelessWidget {
  const StripeAccountWebScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final presenter = locate<StripeAccountConnectPresenter>();
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(),
      body: PresentableWidgetBuilder(
        presenter: presenter,
        builder: () {
          return SingleChildScrollView(
            child:
                presenter.currentUiState.isLoading == true
                    ? Center(
                      child: SizedBox(
                        width: double.infinity,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            LoadingIndicator(
                              theme: Theme.of(context),
                              color: AppColors.primary,
                            ),
                          ],
                        ),
                      ),
                    )
                    : Column(
                      children: [
                        SizedBox(
                          height: Get.height - (-Get.height / 0.8),
                          width: double.infinity,
                          child: WebViewWidget(
                            controller: presenter.webViewController!,
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
