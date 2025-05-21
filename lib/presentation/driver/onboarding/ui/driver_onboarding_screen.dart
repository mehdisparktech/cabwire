import 'package:cabwire/core/config/app_assets.dart';
import 'package:cabwire/core/external_libs/presentable_widget_builder.dart';
import 'package:cabwire/core/static/ui_const.dart';
import 'package:cabwire/core/utility/utility.dart';
import 'package:cabwire/presentation/common/components/common_image.dart';
import 'package:cabwire/presentation/driver/onboarding/presenter/driver_onboarding_presenter.dart';
import 'package:cabwire/presentation/driver/onboarding/widgets/custom_back_button_widget.dart';
import 'package:cabwire/presentation/driver/onboarding/widgets/custom_button_widget.dart';
import 'package:cabwire/presentation/driver/onboarding/widgets/dot_indicator_widget.dart';
import 'package:flutter/material.dart';

class DriverOnboardingScreen extends StatelessWidget {
  DriverOnboardingScreen({super.key});

  final DriverOnboardingPresenter _presenter = DriverOnboardingPresenter();

  // Onboarding page data
  final List<Map<String, dynamic>> _onboardingPages = [
    {
      'image': AppAssets.icSplash1,
      'title': 'Welcome Driver',
      'subtitle': 'Start earning with our easy-to-use driver platform.',
    },
    {
      'image': AppAssets.icSplash2,
      'title': 'Receive Ride Requests',
      'subtitle':
          'Get notified of nearby riders and choose which rides to accept.',
    },
    {
      'image': AppAssets.icSplash3,
      'title': 'Track Earnings',
      'subtitle':
          'Monitor your daily, weekly, and monthly income with detailed breakdowns.',
      'showBackButton': true,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return PresentableWidgetBuilder<DriverOnboardingPresenter>(
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
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(
                  child: CommonImage(
                    imageSrc: image,
                    fill: BoxFit.contain,
                    width: 350,
                    height: 350,
                  ),
                ),
                gapH50,
                Text(
                  title,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: context.color.secondaryTextColor,
                  ),
                ),
                gapH30,
                Text(
                  subtitle,
                  style: TextStyle(
                    color: context.color.secondaryTextColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    height: 1.50,
                  ),
                  textAlign: TextAlign.center,
                ),
                gapH20,
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
            width: 140,
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
