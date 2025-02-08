import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HelpAndSupportScreen(),
    );
  }
}

class HelpAndSupportScreen extends StatelessWidget {
  final List<Map<String, String>> options = [
    {"title": "Get help", "subtitle": "See FAQ and contact support"},
    {"title": "Rate us", "subtitle": "If you love our app, please take a moment to rate it"},
    {"title": "Invite friend to Scrapcon", "subtitle": "Invite your friends to buy and sell"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Help and Support"),
        backgroundColor: Color(0xFF186F1F),
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
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
          ),
          ListTile(
            title: Text("Version", style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text("1.0.0"),
          ),
        ],
      ),
      backgroundColor: Colors.white,
    );
  }
}
