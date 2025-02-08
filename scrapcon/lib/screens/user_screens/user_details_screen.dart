import 'package:flutter/material.dart';

class UserDetailsScreen extends StatelessWidget {
  final String name;
  final String email;
  final String phone;

  UserDetailsScreen({
    required this.name,
    required this.email,
    required this.phone,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Name: $name', style: TextStyle(fontSize: 18)),
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