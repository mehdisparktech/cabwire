import 'package:flutter/material.dart';
import 'package:cabwire/core/di/service_locator.dart';
import 'package:cabwire/core/external_libs/presentable_widget_builder.dart';
import 'package:cabwire/core/utility/utility.dart';
import 'package:cabwire/presentation/passenger/home/ui/passenger_home_screen.dart';
import 'package:cabwire/presentation/passenger/main/presenter/main_presenter.dart';
import 'package:cabwire/presentation/passenger/main/presenter/main_ui_state.dart';
import 'package:cabwire/presentation/passenger/main/widgets/double_tap_back_to_exit_app.dart';
import 'package:cabwire/presentation/passenger/main/widgets/main_navigation_bar.dart';

class MainPage extends StatelessWidget {
  MainPage({super.key});
  final MainPresenter _mainPresenter = locate<MainPresenter>();

  final List<Widget> _pages = <Widget>[
    PassengerHomeScreen(),
    PassengerHomeScreen(),
    PassengerHomeScreen(),
    PassengerHomeScreen(),
    PassengerHomeScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return DoubleTapBackToExitApp(
      mainPresenter: _mainPresenter,
      child: PresentableWidgetBuilder(
        presenter: _mainPresenter,
        builder: () {
          final MainUiState state = _mainPresenter.currentUiState;
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
