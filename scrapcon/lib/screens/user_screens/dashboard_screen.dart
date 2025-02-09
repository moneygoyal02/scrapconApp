import 'package:flutter/material.dart';
import 'user_dashboard_content.dart';
import 'user_ads.dart';
import 'user_add.dart';
import 'user_profile.dart';
import 'user_activity.dart';
import 'user_bottom_nav_bar.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

/// ---
///
/// 1. API Model and Fetch Function
///
/// Define a Bid model and a function to fetch bids from your API.  
/// (Make sure to adjust the URL if you’re not using an Android emulator.)
///
class Bid {
  final String id;
  final String customerName;
  final String scheduledDate;
  final String city;
  final String items;
  final bool isLive;
  final String image;
  final int amount;

  Bid({
    required this.id,
    required this.customerName,
    required this.scheduledDate,
    required this.city,
    required this.items,
    required this.isLive,
    required this.image,
    required this.amount,
  });

  factory Bid.fromJson(Map<String, dynamic> json) {
    return Bid(
      id: json['_id'],
      customerName: json['customer']['name'],
      scheduledDate: json['scheduledDate'],
      city: json['address']['city'],
      items: json['items'],
      isLive: json['isLive'],
      image: json['image'],
      amount: json['amount'],
    );
  }
}

Future<List<Bid>> fetchBids() async {
  // Use 10.0.2.2 if running on an Android emulator instead of localhost.
  final url = Uri.parse('http://10.0.2.2:3001/api/bids/getAll');
  final response = await http.get(url);

  if (response.statusCode == 200) {
    final Map<String, dynamic> data = json.decode(response.body);
    final List<dynamic> bidsJson = data['bids'];
    return bidsJson.map((json) => Bid.fromJson(json)).toList();
  } else {
    throw Exception('Failed to load bids');
  }
}

/// ---
///
/// 2. Widget to Display Bids
///
/// A widget that uses a FutureBuilder to call [fetchBids] and displays the bid data.
///
class BidsListWidget extends StatelessWidget {
  const BidsListWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Bid>>(
      future: fetchBids(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No bids available'));
        } else {
          final bids = snapshot.data!;
          return ListView.builder(
            itemCount: bids.length,
            itemBuilder: (context, index) {
              final bid = bids[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: ListTile(
                  leading: Image.network(
                    bid.image,
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                  title: Text(
                    bid.items,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Customer: ${bid.customerName}'),
                      Text('City: ${bid.city}'),
                      Text('Scheduled: ${bid.scheduledDate}'),
                      Text('Live: ${bid.isLive ? "Yes" : "No"}'),
                    ],
                  ),
                  trailing: Text('₹${bid.amount}'),
                ),
              );
            },
          );
        }
      },
    );
  }
}

/// ---
///
/// 3. Enhanced DashboardScreen
///
/// In the DashboardScreen below we add the new BidsListWidget as the first tab.
/// (We’ve replaced your original [UserBottomNavBar] with the standard [BottomNavigationBar]
/// so that we can easily add the new “Bids” item.)
///
class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _currentIndex = 0;

  // Updated screens list including the new Bids tab.
  final List<Widget> _screens = [
    const BidsListWidget(),      // New API data tab
    UserDashboardContent(),
    UserAdsScreen(),
    UserAddScreen(),
    UserProfileScreen(),
    UserActivityScreen(),
  ];

  // Corresponding titles for the app bar.
  final List<String> _titles = [
    'Bids',
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
            icon: Icon(Icons.list),
            label: 'Bids',
          ),
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

/// ---
///
/// 4. Enhanced Dashboard with NavigationBar
///
/// The second Dashboard (using NavigationBar) is updated to include a new Bids tab.
///
class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int currentPageIndex = 0;

  // Updated pages list including the new Bids tab.
  final List<Widget> _pages = [
    const BidsListWidget(),  // New Bids tab added
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
            selectedIcon: Icon(Icons.list),
            icon: Icon(Icons.list_outlined),
            label: 'Bids',
          ),
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

/// ---
///
/// 5. Existing Recents & RecentTile Widgets (unchanged)
///
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
