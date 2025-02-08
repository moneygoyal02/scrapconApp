import 'package:flutter/material.dart';

class UserBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const UserBottomNavBar(
      {super.key, required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      selectedIndex: currentIndex,
      onDestinationSelected: onTap,
      destinations: const <NavigationDestination>[
        NavigationDestination(
          selectedIcon: Icon(Icons.dashboard),
          icon: Icon(Icons.dashboard_outlined),
          label: 'Dashboard',
        ),
        NavigationDestination(
          selectedIcon: Icon(Icons.ad_units),
          icon: Icon(Icons.ad_units_outlined),
          label: 'My Ads',
        ),
        NavigationDestination(
          selectedIcon: Icon(Icons.add_circle),
          icon: Icon(Icons.add_circle_outline),
          label: 'Add',
        ),
        NavigationDestination(
          selectedIcon: Icon(Icons.person),
          icon: Icon(Icons.person_outline),
          label: 'Profile',
        ),
        NavigationDestination(
          selectedIcon: Icon(Icons.receipt),
          icon: Icon(Icons.receipt_outlined),
          label: 'Activity',
        ),
      ],
    );
  }
}
