import 'package:cabwire/core/config/app_assets.dart';
import 'package:cabwire/core/external_libs/presentable_widget_builder.dart';
import 'package:cabwire/core/static/ui_const.dart';
import 'package:cabwire/core/utility/utility.dart';
import 'package:cabwire/presentation/common/common_image.dart';
import 'package:cabwire/presentation/passenger/onboarding/presenter/passenger_onboarding_presenter.dart';
import 'package:cabwire/presentation/passenger/onboarding/widgets/custom_back_button_widget.dart';
import 'package:cabwire/presentation/passenger/onboarding/widgets/custom_button_widget.dart';
import 'package:cabwire/presentation/passenger/onboarding/widgets/dot_indicator_widget.dart';
import 'package:flutter/material.dart';

class PassengerOnboardingScreen extends StatelessWidget {
  PassengerOnboardingScreen({super.key});

  final PassengerOnboardingPresenter _presenter =
      PassengerOnboardingPresenter();

  // Onboarding page data
  final List<Map<String, dynamic>> _onboardingPages = [
    {
      'image': AppAssets.icSplash1,
      'title': 'Choose Your Ride',
      'subtitle':
          'On-time, budget-friendly and dependable ride-sharing, all within reach.',
    },
    {
      'image': AppAssets.icSplash2,
      'title': 'Instant Booking',
      'subtitle':
          'Missed your flight or late for emergency? Book a ride in minutes.',
    },
    {
      'image': AppAssets.icSplash3,
      'title': 'In-App Safety Features',
      'subtitle':
          'Share your ride details with friends or family, and see the navigation path in real-time.',
      'showBackButton': true,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return PresentableWidgetBuilder<PassengerOnboardingPresenter>(
      presenter: _presenter,
      builder: () {
        return Scaffold(
          backgroundColor: context.color.backgroundColor,
          body: SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: PageView.builder(
                    controller: _presenter.pageController,
                    onPageChanged: _presenter.onPageChanged,
                    itemCount: _onboardingPages.length,
                    itemBuilder: (context, index) {
                      return _buildOnboardingPage(
                        context,
                        _onboardingPages[index],
                      );
                    },
                  ),
                ),
                _buildBottomNavigationBar(),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildOnboardingPage(
    BuildContext context,
    Map<String, dynamic> pageData,
  ) {
    final bool showBackButton = pageData['showBackButton'] ?? false;
    final String image = pageData['image'];
    final String title = pageData['title'];
    final String subtitle = pageData['subtitle'];

    return Column(
      children: [
        if (showBackButton)
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(children: [const CustomBackButtonWidget()]),
          ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Center(child: CommonImage(image, fit: BoxFit.contain)),
                ),
                gapH20,
                Text(
                  title,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: context.color.secondaryTextColor,
                  ),
                ),
                gapH8,
                Text(
                  subtitle,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: context.color.secondarySubTitleColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomNavigationBar() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Dot indicators
          Row(
            children: List.generate(
              _onboardingPages.length,
              (index) => DotIndicatorWidget(
                isActive: _presenter.currentUiState.currentPage == index,
              ),
            ),
          ),
          // Next or Get Started button
          CustomButtonWidget(
            text:
                _presenter.currentUiState.currentPage ==
                        _onboardingPages.length - 1
                    ? 'Get Started'
                    : 'Next',
            width: 120,
            onPressed:
                _presenter.currentUiState.currentPage ==
                        _onboardingPages.length - 1
                    ? _presenter.onGetStarted
                    : _presenter.onNextPage,
          ),
        ],
      ),
    );
  }
}
