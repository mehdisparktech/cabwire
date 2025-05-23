import 'package:flutter/material.dart';
import 'package:cabwire/core/di/service_locator.dart';
import 'package:cabwire/core/external_libs/presentable_widget_builder.dart';
import 'package:cabwire/core/utility/utility.dart';
import 'package:cabwire/presentation/passenger/home/ui/passenger_home_screen.dart';
import 'package:cabwire/presentation/passenger/passenger_services/ui/passenger_services_page.dart';
import 'package:cabwire/presentation/passenger/passenger_history/ui/passenger_history_page.dart';
import 'package:cabwire/presentation/passenger/passenger_profile/ui/passenger_profile_page.dart';
import 'package:cabwire/presentation/passenger/main/presenter/passenger_main_presenter.dart';
import 'package:cabwire/presentation/passenger/main/presenter/passenger_main_ui_state.dart';
import 'package:cabwire/presentation/passenger/main/widgets/double_tap_back_to_exit_app.dart';
import 'package:cabwire/presentation/passenger/main/widgets/main_navigation_bar.dart';

class PassengerMainPage extends StatelessWidget {
  PassengerMainPage({super.key});
  final PassengerMainPresenter _mainPresenter =
      locate<PassengerMainPresenter>();

  final List<Widget> _pages = <Widget>[
    PassengerHomeScreen(),
    PassengerServicesPage(),
    PassengerHistoryPage(),
    PassengerProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return DoubleTapBackToExitApp(
      mainPresenter: _mainPresenter,
      child: PresentableWidgetBuilder(
        presenter: _mainPresenter,
        builder: () {
          final PassengerMainUiState state = _mainPresenter.currentUiState;
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
