import 'package:flutter/material.dart';

class VendorBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  VendorBottomNavBar({required this.currentIndex, required this.onTap});

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
          selectedIcon: Icon(Icons.receipt),
          icon: Icon(Icons.receipt_outlined),
          label: 'Activity',
        ),
        NavigationDestination(
          selectedIcon: Icon(Icons.explore),
          icon: Icon(Icons.explore_outlined),
          label: 'Explore',
        ),
        NavigationDestination(
          selectedIcon: Icon(Icons.person),
          icon: Icon(Icons.person_outlined),
          label: 'Account',
        ),
      ],
    );
  }
} 