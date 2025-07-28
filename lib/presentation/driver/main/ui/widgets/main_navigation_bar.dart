import 'package:flutter/material.dart';
import 'package:cabwire/core/config/app_assets.dart';
import 'package:cabwire/presentation/driver/main/ui/widgets/nav_destination_item.dart';

class MainNavigationBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;

  const MainNavigationBar({
    super.key,
    required this.selectedIndex,
    required this.onDestinationSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey.shade300)),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          NavDestinationItem(
            index: 0,
            selectedIndex: selectedIndex,
            iconPath: AppAssets.icHome,
            label: 'Home',
            onTap: onDestinationSelected,
          ),
          NavDestinationItem(
            index: 1,
            selectedIndex: selectedIndex,
            iconPath: AppAssets.icCar,
            label: 'Create Post',
            onTap: onDestinationSelected,
          ),
          NavDestinationItem(
            index: 2,
            selectedIndex: selectedIndex,
            iconPath: AppAssets.icEarning,
            label: 'Earnings',
            onTap: onDestinationSelected,
          ),

          NavDestinationItem(
            index: 3,
            selectedIndex: selectedIndex,
            iconPath: AppAssets.icProfile,
            label: 'Profile',
            onTap: onDestinationSelected,
          ),
        ],
      ),
    );
  }
}
