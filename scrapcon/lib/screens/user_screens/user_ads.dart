import 'package:flutter/material.dart';

class UserAdsScreen extends StatelessWidget {
  final String title;
  final int quantity;
  final String location;
  final String dueDate;
  final String imageUrl;
  final VoidCallback onTap;

  UserAdsScreen({
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
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
            child: AspectRatio(
              aspectRatio: 16 / 9, // Maintains aspect ratio
              child: Image.network(
                imageUrl,
                width: double.infinity,
                fit: BoxFit.cover, // Ensures full width while maintaining aspect ratio
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 5),
                Text("Quantity: $quantity"),
                Text("Location: $location"),
                Text("Due Date: $dueDate"),
                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton(
                    onPressed: onTap,
                    child: const Text("See Bid"),
                  ),
                ),
              ],
            ),
          ),
        ],
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