import 'package:flutter/material.dart';
import 'package:cabwire/core/config/app_screen.dart';
import 'package:cabwire/core/config/app_assets.dart';
import 'package:cabwire/core/utility/utility.dart';
import 'package:cabwire/presentation/driver/main/widgets/nav_destination_item.dart';

class MainNavigationBar extends StatelessWidget {
  const MainNavigationBar({
    super.key,
    required this.selectedIndex,
    required this.onDestinationSelected,
  });

  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: sixteenPx),
      decoration: BoxDecoration(
        color: context.color.backgroundColor,
        border: Border(top: BorderSide(color: context.color.blackColor200)),
      ),
      child: NavigationBar(
        backgroundColor: context.color.backgroundColor,
        selectedIndex: selectedIndex,
        onDestinationSelected: onDestinationSelected,
        destinations: [
          NavDestinationItem(
            index: 0,
            selectedIndex: selectedIndex,
            outlineIcon: AppAssets.icHome,
            fillIcon: AppAssets.icHome,
            label: 'Home',
          ),
          NavDestinationItem(
            index: 1,
            selectedIndex: selectedIndex,
            outlineIcon: AppAssets.icHistory,
            fillIcon: AppAssets.icHistory,
            label: 'History',
          ),
          NavDestinationItem(
            index: 2,
            selectedIndex: selectedIndex,
            outlineIcon: AppAssets.icEarning,
            fillIcon: AppAssets.icEarning,
            label: 'Earnings',
          ),
          NavDestinationItem(
            index: 3,
            selectedIndex: selectedIndex,
            outlineIcon: AppAssets.icProfile,
            fillIcon: AppAssets.icProfile,
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
