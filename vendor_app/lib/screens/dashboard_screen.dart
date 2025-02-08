import 'package:flutter/material.dart';
import 'vendor_explore.dart';
import 'vendor_activity.dart';
import 'vendor_profile.dart';
import 'vendor_bottom_nav_bar.dart';
import 'vendor_dashboard_content.dart';

class VendorDashboardScreen extends StatefulWidget {
  const VendorDashboardScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _VendorDashboardScreenState createState() => _VendorDashboardScreenState();
}

class _VendorDashboardScreenState extends State<VendorDashboardScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    VendorDashboardContent(),
    VendorActivityScreen(),
    VendorExploreScreen(),
    VendorProfileScreen(),
  ];

  void _onTap(int index) {
    setState(() {
      _currentIndex = index; // Update the current index
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF186F1F),
        foregroundColor: Colors.white,
        title: Text(['Dashboard', 'Activity', 'Explore', 'Account'][_currentIndex]),
      ),
      body: _screens[_currentIndex], // Display the current screen
      bottomNavigationBar: VendorBottomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          _onTap(index); // Call the onTap function
        },
      ),
    );
  }
}

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int currentPageIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Dashboard',
              style: Theme.of(context).textTheme.headlineMedium),
        ),
        bottomNavigationBar: NavigationBar(
          onDestinationSelected: (int index) {
            setState(() {
              currentPageIndex = index;
            });
          },
          indicatorColor: Colors.grey,
          selectedIndex: currentPageIndex,
          destinations: const <Widget>[
            NavigationDestination(
              selectedIcon: Icon(Icons.home),
              icon: Icon(Icons.home_outlined),
              label: 'Home',
            ),
            NavigationDestination(
              selectedIcon: Icon(Icons.explore),
              icon: Icon(Icons.explore_outlined),
              label: 'Explore',
            ),
            NavigationDestination(
              selectedIcon: Icon(Icons.receipt),
              icon: Icon(Icons.receipt_outlined),
              label: 'Activity',
            ),
            NavigationDestination(
              selectedIcon: Icon(Icons.person),
              icon: Icon(Icons.person_outlined),
              label: 'Account',
            )
          ],
        ),
        body: <Widget>[
          Recents(material: 'Wood'),
          Recents(material: 'Steel'),
          Recents(material: 'E-Waste'),
          Recents(material: 'Paper')
        ][currentPageIndex]);
  }
}

class Recents extends StatelessWidget {
  final String material;
  const Recents({super.key, required this.material});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.all(16.0),
        child: ListView.builder(
            itemCount: 3,
            itemBuilder: (BuildContext context, int index) {
              return Column(children: <Widget>[
                RecentTile(
                    title: material, itemCount: 20, vendor: 'ABC Scrapers'),
                Divider(
                  color: Colors.grey,
                )
              ]);
            }));
  }
}

class RecentTile extends StatelessWidget {
  final String title;
  final int itemCount;
  final String vendor;

  const RecentTile(
      {super.key,
      required this.title,
      required this.itemCount,
      required this.vendor});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final boldText =
        theme.textTheme.labelLarge?.copyWith(fontWeight: FontWeight.bold);
    final heading = theme.textTheme.labelLarge;
    return ListTile(
      leading: Icon(Icons.timer_outlined),
      title: Text(title, style: heading?.copyWith(fontWeight: FontWeight.bold)),
      subtitle:
          Text('To: $vendor', style: heading?.copyWith(color: Colors.grey)),
      trailing: Text('x$itemCount', style: boldText),
    );
  }
}
