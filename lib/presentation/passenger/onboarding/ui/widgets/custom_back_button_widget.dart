import 'package:cabwire/core/config/app_screen.dart';
import 'package:cabwire/core/utility/utility.dart';
import 'package:cabwire/presentation/passenger/onboarding/presenter/passenger_onboarding_presenter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomBackButtonWidget extends StatelessWidget {
  final PassengerOnboardingPresenter presenter;
  const CustomBackButtonWidget({super.key, required this.presenter});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: px14),
      width: context.width * 0.9,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            onTap: () {
              presenter.onBack();
            },
            child: Container(
              padding: EdgeInsets.all(px8),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: context.color.backgroundColor,
                border: Border.all(
                  color: context.color.primaryColor.withOpacityInt(0.2),
                ),
              ),
              child: Icon(
                Icons.arrow_back_ios_new,
                color: context.color.primaryColor,
                size: px16,
              ),
            ),
          ),
          InkWell(
            onTap: () {
              presenter.onSkip();
            },
            child:
                presenter.uiState.value.showSkipButton == true
                    ? Text(
                      "Skip",
                      style: context.textTheme.titleSmall?.copyWith(
                        color: context.color.primaryColor,
                      ),
                    )
                    : const SizedBox(),
          ),
        ],
      ),
    );
  }
}
