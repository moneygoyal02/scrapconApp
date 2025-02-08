import 'package:flutter/material.dart';

class VendorDetailsScreen extends StatelessWidget {
  final String businessName;
  final String ownerName;
  final String email;
  final String phone;

  VendorDetailsScreen({
    required this.businessName,
    required this.ownerName,
    required this.email,
    required this.phone,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Vendor Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Business Name: $businessName', style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            Text('Owner Name: $ownerName', style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            Text('Email: $email', style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            Text('Phone: $phone', style: TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}
