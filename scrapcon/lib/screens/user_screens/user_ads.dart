import 'package:flutter/material.dart';

class UserAdsScreen extends StatelessWidget {
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
            location: "Sector 80, GB Road, New Delhi, India",
            dueDate: "17/08/2025",
            imageUrl: "https://fastly.picsum.photos/id/237/250/250.jpg?hmac=tNmO3YWXALG9JM81cghI9nflo3dWc3e5vlNsf_jmKWw", // Replace with your image URL
            onTap: () {
              // Handle the "See Bid" button press here
              print("See Bid tapped for Ad #$index");
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
  final String imageUrl;
  final VoidCallback onTap;

  AdCard({
    required this.title,
    required this.quantity,
    required this.location,
    required this.dueDate,
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
          Image.network(imageUrl, height: 150, fit: BoxFit.cover),
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