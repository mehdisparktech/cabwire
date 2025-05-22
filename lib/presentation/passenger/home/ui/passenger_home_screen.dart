import 'package:cabwire/core/di/service_locator.dart';
import 'package:cabwire/core/external_libs/presentable_widget_builder.dart';
import 'package:cabwire/presentation/common/components/custom_app_bar.dart';
import 'package:cabwire/presentation/passenger/home/presenter/presenter_home_presenter.dart';
import 'package:flutter/material.dart';

class PassengerHomeScreen extends StatelessWidget {
  PassengerHomeScreen({super.key});
  final PassengerHomePresenter presenter = locate<PassengerHomePresenter>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Passenger Home',
        showBackButton: true,
        elevation: 0,
      ),
      body: PresentableWidgetBuilder(
        presenter: presenter,
        builder: () {
          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              children: [
                Text('Passenger Home'),
                Text('Passenger Home'),
                Text('Passenger Home'),
              ],
            ),
          );
        },
      ),
    );
  }
}
