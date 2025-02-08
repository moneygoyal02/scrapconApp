import 'package:flutter/material.dart';// Import the SupportAgentScreen class
import 'user_message.dart';
import 'package:scrapcon/screens/user_screens/user_message.dart';

class UserDashboardContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Hardcoded list items
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: 3,
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: Icon(Icons.timer_outlined),
                      title: Text('Wood'),
                      subtitle: Text('To: ABC Scrapers'),
                      trailing: Text('x20\n\$400'),
                    );
                  },
                ),
                SizedBox(height: 20),
                // Suggestions section
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Suggestions', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                // Suggestions grid
                GridView.count(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  childAspectRatio: 1.5,
                  children: [
                    _buildSuggestionCard('Steel', Icons.build, Colors.blue),
                    _buildSuggestionCard('Wood', Icons.build, Colors.brown),
                    _buildSuggestionCard('Plastic', Icons.water, Colors.green),
                    _buildSuggestionCard('Bolt', Icons.bolt, Colors.grey),
                    _buildSuggestionCard('Car', Icons.directions_car, Colors.red),
                    _buildSuggestionCard('See all', Icons.more_horiz, Colors.black),
                  ],
                ),
              ],
            ),
          ),
        ),
        Positioned(
          bottom: 16.0,
          right: 16.0,
          child: FloatingActionButton(
            onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ChatPage()),
                );
            },
            backgroundColor: Color(0xFF17255A),
            child: Icon(Icons.support_agent),
          ),
        ),
      ],
    );
  }

  Widget _buildSuggestionCard(String title, IconData icon, Color color) {
    return Card(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 30, color: color),
          SizedBox(height: 10),
          Text(title, style: TextStyle(fontSize: 16)),
        ],
      ),
    );
  }
}