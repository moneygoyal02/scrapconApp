import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../passwords.dart';
import 'dart:async';
import 'user_bids.dart';

class UserAdsScreen extends StatefulWidget {
  @override
  _UserAdsScreenState createState() => _UserAdsScreenState();
}

class _UserAdsScreenState extends State<UserAdsScreen> {
  List<dynamic> _bids = [];
  bool _isLoading = true;
  Timer? _refreshTimer;

  @override
  void initState() {
    super.initState();
    _fetchBids();
    _refreshTimer = Timer.periodic(Duration(seconds: 15), (timer) {
      if (mounted) _fetchBids();
    });
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    super.dispose();
  }

  Future<void> _fetchBids() async {
    if (!mounted) return;

    try {
      final url = '${Passwords.backendUrl}/api/bids/getAllWp';
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
      ).timeout(
        Duration(seconds: 10),
        onTimeout: () {
          throw TimeoutException('Connection timeout. Please try again.');
        },
      );

      if (!mounted) return;

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true && data['bids'] != null) {
          setState(() {
            _bids = data['bids'];
            _isLoading = false;
          });
        }
      }
    } catch (error) {
      print('Error fetching bids: $error');
      if (!mounted) return;
      setState(() => _isLoading = false);
    }
  }

  void _showBidPopup(BuildContext context, String title, String location, int quantity, String dueDate, String leadingBid) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
          contentPadding: EdgeInsets.all(16.0),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              Text(location),
              SizedBox(height: 8),
              Text('Quantity: x$quantity'),
              SizedBox(height: 8),
              Text('Due Date: $dueDate'),
              SizedBox(height: 8),
              Text('Leading Bid: $leadingBid'),
              SizedBox(height: 16),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Your Max Bid',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Cancel',
                style: TextStyle(color: Color(0xFF17255A)),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                // Add your bidding logic here
              },
              style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF17255A)),
              child: Text(
                'Place Bid',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _bids.length,
              itemBuilder: (context, index) {
                final bid = _bids[index];
                
                // Format the date
                final scheduledDate = DateTime.parse(bid['scheduledDate']);
                final now = DateTime.now();
                final difference = scheduledDate.difference(now).inDays;
                final dueDate = difference > 0 ? '${difference}d left' : '${-difference}d ago';

                // Get location
                final location = bid['address'] != null 
                    ? '${bid['address']['city']}, ${bid['address']['state']}'
                    : 'Location not available';

                // Clean up category (remove quotes)
                final category = bid['category']?.toString().replaceAll('"', '') ?? 'Unknown';

                return AdCard(
                  title: category,
                  quantity: bid['quantity'] ?? 0,
                  location: location,
                  dueDate: dueDate,
                  leadingBid: "\$${bid['amount'] ?? '0'}",
                  imageUrl: bid['image'] ?? "https://media.istockphoto.com/id/151540540/photo/crane-picking-up-car.jpg?s=2048x2048&w=is&k=20&c=nr6Cwhy-7tBaJCNRQ8m1qO0CshPm5WpxO3pEiRZlq9w=",
                  onTap: () {
                    _showBidPopup(
                      context,
                      category,
                      location,
                      bid['quantity'] ?? 0,
                      dueDate,
                      "\$${bid['amount'] ?? '0'}",
                    );
                  },
                );
              },
            ),
    );
  }
}

class AdCard extends StatelessWidget {
  final String title;
  final int quantity;
  final String location;
  final String dueDate;
  final String leadingBid;
  final String imageUrl;
  final VoidCallback onTap;

  AdCard({
    required this.title,
    required this.quantity,
    required this.location,
    required this.dueDate,
    required this.leadingBid,
    required this.imageUrl,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.network(imageUrl, height: 250, fit: BoxFit.cover),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 4),
                    Text(location),
                    SizedBox(height: 4),
                    Text('Due Date: $dueDate'),
                  ],
                ),
                Column(
                  children: [
                    Text(
                      'x$quantity',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => MyAdsScreen()), // Replace BidScreen with your target screen
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        backgroundColor: Color(0xFF17255A),
                      ),
                      child: Text('See Bid', 
                      style: TextStyle(color: Colors.white), 
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
