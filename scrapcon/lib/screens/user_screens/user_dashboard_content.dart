import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:provider/provider.dart';
import '../token_provider.dart';
import '../passwords.dart';
import 'chatbot_support.dart';
import 'user_message.dart';
import 'user_add.dart';

class UserDashboardContent extends StatefulWidget {
  @override
  _UserDashboardContentState createState() => _UserDashboardContentState();
}

class _UserDashboardContentState extends State<UserDashboardContent> {
  List<dynamic> _bids = [];
  bool _isLoading = true;
  bool _mounted = true;

  @override
  void initState() {
    super.initState();
    _fetchBids();
  }

  @override
  void dispose() {
    _mounted = false;
    super.dispose();
  }

  Future<void> _fetchBids() async {
    if (!mounted) return;
    
    try {
      final token = Provider.of<TokenProvider>(context, listen: false).token;
      final url = '${Passwords.backendUrl}/api/bids/getAll';
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (!mounted) return;

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (_mounted) {
          setState(() {
            _bids = data['bids'];
            _isLoading = false;
          });
        }
      } else {
        print('Failed to fetch bids: ${response.body}');
        if (_mounted) {
          setState(() => _isLoading = false);
        }
      }
    } catch (error) {
      print('Error fetching bids: $error');
      if (_mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // Bids list
                    _isLoading
                        ? Center(child: CircularProgressIndicator())
                        : ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: _bids.length,
                            itemBuilder: (context, index) {
                              final bid = _bids[index];
                              final items = json.decode(bid['items']);
                              final firstItem = items[0];

                              return Card(
                                margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                child: ListTile(
                                  leading: Icon(Icons.timer_outlined, color: Color(0xFF17255A)),
                                  title: Text('${firstItem['category']}'),
                                  subtitle: Text('To: ${bid['address']['city']}, ${bid['address']['state']}'),
                                  trailing: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text('${firstItem['quantity']} ${firstItem['unit']}'),
                                      Text(
                                        bid['isLive'] ? 'Active' : 'Inactive',
                                        style: TextStyle(
                                          color: bid['isLive'] ? Colors.green : Colors.red,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
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
                          Text('Suggestions', 
                              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
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
          ],
        ),
        Positioned(
          bottom: 16.0,
          right: 16.0,
          child: FloatingActionButton(
            onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ChatbotSupport()),
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
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => UserAddScreen(),
          ),
        );
      },
      child: Card(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 30, color: color),
            SizedBox(height: 10),
            Text(title, style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}