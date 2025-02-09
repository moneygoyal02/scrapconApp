import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'passwords.dart';
import 'package:provider/provider.dart';
import '../token_provider.dart';
import 'dart:async';

class VendorExploreScreen extends StatefulWidget {
  @override
  _VendorExploreScreenState createState() => _VendorExploreScreenState();
}

class _VendorExploreScreenState extends State<VendorExploreScreen> {
  List<dynamic> _bids = [];
  bool _isLoading = true;
  Timer? _refreshTimer;  // Add timer for periodic updates

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
    _refreshTimer?.cancel();  // Cancel timer when disposing
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

  void _showBidPopup(BuildContext context, Map<String, dynamic> bid, String title, String location, int quantity, String dueDate, String leadingBid) {
    final TextEditingController bidController = TextEditingController();

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
              Text(title.isNotEmpty ? title : 'Unknown Title', 
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              Text(location.isNotEmpty ? location : 'Location not available'),
              SizedBox(height: 8),
              Text('Quantity: x$quantity'),
              SizedBox(height: 8),
              Text('Due Date: $dueDate'),
              SizedBox(height: 8),
              Text('Leading Bid: $leadingBid'),
              SizedBox(height: 16),
              TextField(
                controller: bidController,
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
              child: Text('Cancel', style: TextStyle(color: Color(0xFF186F1F))),
            ),
            ElevatedButton(
              onPressed: () async {
                final bidAmount = double.tryParse(bidController.text);
                if (bidAmount != null) {
                  await _placeBid(bid['_id'], bidAmount);
                  Navigator.of(context).pop();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Please enter a valid bid amount')),
                  );
                }
              },
              style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF186F1F)),
              child: Text('Place Bid', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  Future<void> _placeBid(String bidId, double bidAmount) async {
    try {
      final url = '${Passwords.backendUrl}/api/bids';
      final tokenProvider = Provider.of<TokenProvider>(context, listen: false);
      final token = tokenProvider.token;
      final vendorId = tokenProvider.userId;

      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode({
          'vendor': vendorId,
          'bid': bidId,
          'highestBid': bidAmount,
        }),
      );

      if (response.statusCode == 201) {
        final data = json.decode(response.body);
        if (data['success']) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Bid placed successfully!')),
          );
          // Immediately fetch updated bids after placing a bid
          await _fetchBids();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to place bid: ${data['message']}')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error placing bid: ${response.body}')),
        );
      }
    } catch (error) {
      print('Error placing bid: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred while placing the bid')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Vendor Explore')),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: EdgeInsets.all(16.0),
              itemCount: _bids.length,
              itemBuilder: (context, index) {
                final bid = _bids[index];
                final items = json.decode(bid['items'] ?? '[]');
                final firstItem = items.isNotEmpty ? items[0] : {};

                // Handle null address
                String location = 'Location not available';
                if (bid['address'] != null) {
                  location = '${bid['address']['city'] ?? 'Unknown City'}, ${bid['address']['state'] ?? 'Unknown State'}';
                }

                // Ensure quantity is an integer
                int quantity = firstItem['quantity'] is int 
                    ? firstItem['quantity'] 
                    : int.tryParse(firstItem['quantity'].toString()) ?? 0;

                return AdCard(
                  title: firstItem['category'] ?? 'Unknown',
                  quantity: quantity,
                  location: location,
                  dueDate: bid['scheduledDate'] ?? 'No date available',
                  leadingBid: '\$${bid['highestBid'] ?? '0'}',
                  imageUrl: bid['image'] ?? '',
                  onTap: () {
                    _showBidPopup(
                      context,
                      bid,  // Pass the entire bid object
                      firstItem['category'] ?? 'Unknown',
                      location,
                      quantity,
                      bid['scheduledDate'] ?? 'No date available',
                      '\$${bid['highestBid'] ?? '0'}',
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
          Image.network(
            imageUrl, 
            height: 250, 
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                height: 250,
                color: Colors.grey[300],
                child: Center(
                  child: Icon(Icons.image_not_supported, size: 50, color: Colors.grey[600]),
                ),
              );
            },
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 4),
                      Text(
                        location,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 4),
                      Text(dueDate),
                    ],
                  ),
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