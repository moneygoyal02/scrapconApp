import 'package:flutter/material.dart';

class VendorExploreScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        padding: EdgeInsets.all(16.0),
        itemCount: 3, // Example item count
        itemBuilder: (context, index) {
          return AdCard(
            title: "Wood",
            quantity: 15,
            location: "Sector 80, AB Road, New Delhi, India",
            dueDate: "5d ago",
            leadingBid: "\$100",
            imageUrl: "https://media.istockphoto.com/id/151540540/photo/crane-picking-up-car.jpg?s=2048x2048&w=is&k=20&c=nr6Cwhy-7tBaJCNRQ8m1qO0CshPm5WpxO3pEiRZlq9w=",
            onTap: () {
              _showBidPopup(context, "Wood", "Sector 80, AB Road, New Delhi, India", 15, "5d ago", "\$100");
            },
          );
        },
      ),
    );
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
                      onPressed: onTap,
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        backgroundColor: Color(0xFF17255A),
                      ),
                      child: Text('See Bid', style: TextStyle(color: Colors.white)),
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
