import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: BuyPackagesScreen(),
    );
  }
}

class BuyPackagesScreen extends StatelessWidget {
  final List<Map<String, String>> options = [
    {"title": "Buy packages", "subtitle": "Sell faster, more & higher margins with packages"},
    {"title": "My Orders", "subtitle": "Active, scheduled and expired orders"},
    {"title": "Invoices", "subtitle": "See and download your invoices"},
    {"title": "Billing information", "subtitle": "Edit your billing name, address, etc."},
    {"title": "View Cart", "subtitle": "Check out the items in your cart to purchase"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Buy Packages & My Orders"),
        backgroundColor: Color(0xFF17255A),
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        itemCount: options.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(options[index]["title"]!, style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text(options[index]["subtitle"]!),
            trailing: Icon(Icons.arrow_forward_ios, color: Colors.white),
            onTap: () {
              // Handle navigation
            },
          );
        },
      ),
      backgroundColor: Colors.white,
    );
  }
}
