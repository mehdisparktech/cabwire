import 'package:cabwire/presentation/driver/earnings/ui/earning_page.dart';
import 'package:cabwire/presentation/driver/home/ui/driver_home_page.dart';
import 'package:cabwire/presentation/driver/main/presenter/driver_main_presenter.dart';
import 'package:cabwire/presentation/driver/profile/ui/driver_profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:cabwire/core/di/service_locator.dart';
import 'package:cabwire/core/external_libs/presentable_widget_builder.dart';
import 'package:cabwire/core/utility/utility.dart';
import 'package:cabwire/presentation/driver/main/presenter/driver_main_ui_state.dart';
import 'package:cabwire/presentation/driver/main/widgets/double_tap_back_to_exit_app.dart';
import 'package:cabwire/presentation/driver/main/widgets/main_navigation_bar.dart';

class DriverMainPage extends StatelessWidget {
  DriverMainPage({super.key});
  final DriverMainPresenter _mainPresenter = locate<DriverMainPresenter>();

  final List<Widget> _pages = <Widget>[
    DriverHomePage(),
    EarningsPage(),
    DriverHomePage(),
    DriverProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return DoubleTapBackToExitApp(
      mainPresenter: _mainPresenter,
      child: PresentableWidgetBuilder(
        presenter: _mainPresenter,
        builder: () {
          final DriverMainUiState state = _mainPresenter.currentUiState;
          return Scaffold(
            body:
                state.selectedBottomNavIndex < _pages.length
                    ? _pages[state.selectedBottomNavIndex]
                    : _pages[0], // Default to first page if index out of range
            bottomNavigationBar: MainNavigationBar(
              selectedIndex: state.selectedBottomNavIndex,
              onDestinationSelected: (index) {
                if (index == 4) {
                  showMessage(message: 'Coming soon');
                  return;
                }
                _mainPresenter.changeNavigationIndex(index);
              },
            ),
          );
        },
      ),
    );
  }
}
