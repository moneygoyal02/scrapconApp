import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'passwords.dart';
import 'dart:async';

class VendorDashboardContent extends StatefulWidget {
  @override
  _VendorDashboardContentState createState() => _VendorDashboardContentState();
}

class _VendorDashboardContentState extends State<VendorDashboardContent> {
  List<dynamic> _bids = [];
  bool _isLoading = true;
  Timer? _refreshTimer;

  @override
  void initState() {
    super.initState();
    _fetchBids();
    // Set up periodic refresh every 10 seconds
    _refreshTimer = Timer.periodic(Duration(seconds: 10), (timer) {
      _fetchBids();
    });
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    super.dispose();
  }

  Future<void> _fetchBids() async {
    try {
      final url = '${Passwords.backendUrl}/api/bids/getAllWp';
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true && data['bids'] != null) {
          setState(() {
            _bids = data['bids'];
            _isLoading = false;
          });
        } else {
          print('Failed to fetch bids: ${response.body}');
          setState(() => _isLoading = false);
        }
      } else {
        print('Failed to fetch bids: ${response.body}');
        setState(() => _isLoading = false);
      }
    } catch (error) {
      print('Error fetching bids: $error');
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Dynamic list items from API
                _isLoading
                    ? Center(child: CircularProgressIndicator())
                    : ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: _bids.length,
                        itemBuilder: (context, index) {
                          final bid = _bids[index];
                          String category = '';
                          String quantity = '';
                          
                          // Handle both direct category and items array
                          if (bid['category'] != null) {
                            category = bid['category'].replaceAll('"', '');
                          } else if (bid['items'] != null) {
                            try {
                              final items = json.decode(bid['items']);
                              if (items is List && items.isNotEmpty) {
                                category = items[0]['category'] ?? '';
                                quantity = items[0]['quantity']?.toString() ?? '';
                              }
                            } catch (e) {
                              print('Error parsing items: $e');
                            }
                          }

                          // Use direct quantity if available, otherwise use from items
                          quantity = bid['quantity']?.toString() ?? quantity;

                          return ListTile(
                            leading: Icon(Icons.timer_outlined),
                            title: Text(category),
                            subtitle: Text('To: ${bid['customer']['name']}'),
                            trailing: Text(
                              'x$quantity\n\$${bid['amount'] ?? '0'}',
                              textAlign: TextAlign.end,
                            ),
                          );
                        },
                      ),
                SizedBox(height: 20),
                // Suggestions section
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Suggestions',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                // Suggestions grid
                GridView.count(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  childAspectRatio: 1.5,
                  children: [
                    _buildSuggestionCard('Steel', Icons.build, Colors.blue),
                    _buildSuggestionCard('Wood', Icons.build, Colors.brown),
                    _buildSuggestionCard('Plastic', Icons.water, Colors.green),
                    _buildSuggestionCard('Bolt', Icons.bolt, Colors.grey),
                    _buildSuggestionCard('Car', Icons.directions_car, Colors.red),
                    _buildSuggestionCard('See all', Icons.more_horiz, Colors.black),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSuggestionCard(String title, IconData icon, Color color) {
    return Card(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 30, color: color),
          SizedBox(height: 10),
          Text(title, style: TextStyle(fontSize: 16)),
        ],
      ),
    );
  }
}