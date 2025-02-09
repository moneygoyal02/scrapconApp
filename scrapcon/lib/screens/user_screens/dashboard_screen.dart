import 'package:flutter/material.dart';
import 'user_dashboard_content.dart';
import 'user_ads.dart';
import 'user_add.dart';
import 'user_profile.dart';
import 'user_activity.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _currentIndex = 0;

  // Updated screens list including the new Bids tab.
  final List<Widget> _screens = [
    // New API data tab
    UserDashboardContent(),
    UserAdsScreen(),
    UserAddScreen(),
    UserProfileScreen(),
    UserActivityScreen(),
  ];

  // Corresponding titles for the app bar.
  final List<String> _titles = [
    'Dashboard',
    'My Ads',
    'Add',
    'Profile',
    'Activity'
  ];

  void _onTap(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[_currentIndex]),
        backgroundColor: const Color(0xFF17255A),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTap,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.ads_click),
            label: 'My Ads',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_box),
            label: 'Add',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.access_time),
            label: 'Activity',
          ),
        ],
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

  // Updated pages list including the new Bids tab.
  final List<Widget> _pages = [
    Recents(material: 'Wood'),
    Recents(material: 'Steel'),
    Recents(material: 'E-Waste'),
    Recents(material: 'Paper'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Dashboard',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
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
          ),
        ],
      ),
      body: _pages[currentPageIndex],
    );
  }
}

class Recents extends StatelessWidget {
  final String material;
  const Recents({super.key, required this.material});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView.builder(
          itemCount: 3,
          itemBuilder: (BuildContext context, int index) {
            return Column(
              children: <Widget>[
                RecentTile(
                    title: material, itemCount: 20, vendor: 'ABC Scrapers'),
                const Divider(
                  color: Colors.grey,
                )
              ],
            );
          }),
    );
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
      leading: const Icon(Icons.timer_outlined),
      title: Text(
        title,
        style: heading?.copyWith(fontWeight: FontWeight.bold),
      ),
      subtitle: Text(
        'To: $vendor',
        style: heading?.copyWith(color: Colors.grey),
      ),
      trailing: Text('x$itemCount', style: boldText),
    );
  }
}
