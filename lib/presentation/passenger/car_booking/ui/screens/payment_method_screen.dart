import 'package:cabwire/core/di/service_locator.dart';
import 'package:cabwire/core/external_libs/presentable_widget_builder.dart';
import 'package:cabwire/core/static/app_colors.dart';
import 'package:cabwire/presentation/common/components/loading_indicator.dart';
import 'package:cabwire/presentation/passenger/car_booking/presenter/ride_share_presenter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaymentMethodScreen extends StatelessWidget {
  const PaymentMethodScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final presenter = locate<RideSharePresenter>();
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(),
      body: PresentableWidgetBuilder(
        presenter: presenter,
        builder: () {
          return SingleChildScrollView(
            child:
                presenter.currentUiState.isLoading == true
                    ? SizedBox(
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
                    )
                    : presenter.webViewController != null
                    ? Column(
                      children: [
                        SizedBox(
                          height: Get.height - 100,
                          width: double.infinity,
                          child: WebViewWidget(
                            controller: presenter.webViewController!,
                          ),
                        ),
                      ],
                    )
                    : const Center(
                      child: Text(
                        'Payment method not available',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
          );
        },
      ),
    );
  }
}
