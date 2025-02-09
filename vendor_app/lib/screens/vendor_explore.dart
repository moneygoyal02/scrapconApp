import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'passwords.dart';

class VendorExploreScreen extends StatefulWidget {
  @override
  _VendorExploreScreenState createState() => _VendorExploreScreenState();
}

class _VendorExploreScreenState extends State<VendorExploreScreen> {
  List<dynamic> _bids = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchBids();
  }

  Future<void> _fetchBids() async {
    try {
      final url = '${Passwords.backendUrl}/api/bids/getAllWp'; // Update with your backend URL
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
                style: TextStyle(color: Color(0xFF186F1F)),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                // Add your bidding logic here
              },
              style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF186F1F)),
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
              padding: EdgeInsets.all(16.0),
              itemCount: _bids.length,
              itemBuilder: (context, index) {
                final bid = _bids[index];
                final items = json.decode(bid['items'] ?? '[]');
                final firstItem = items.isNotEmpty ? items[0] : {};

                return AdCard(
                  title: firstItem['category'] ?? 'Unknown',
                  quantity: firstItem['quantity'] ?? 0,
                  location: '${bid['address']['city']}, ${bid['address']['state']}',
                  dueDate: 'Due: ${bid['scheduledDate']}', // Format as needed
                  leadingBid: '\$${bid['amount']}', // Adjust based on your data
                  imageUrl: bid['image'] ?? '',
                  onTap: () {
                    _showBidPopup(
                      context,
                      firstItem['category'] ?? 'Unknown',
                      '${bid['address']['city']}, ${bid['address']['state']}',
                      firstItem['quantity'] ?? 0,
                      'Due: ${bid['scheduledDate']}', // Format as needed
                      '\$${bid['amount']}', // Adjust based on your data
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
                    Text(dueDate),
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
                      onPressed: onTap,
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        backgroundColor: Color(0xFF186F1F),
                      ),
                      child: Text('Make Bid', style: TextStyle(color: Colors.white)),
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
