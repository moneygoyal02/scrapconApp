import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'passwords.dart'; 
import 'notifications_screen.dart';
// import 'dashboard_screen.dart';
class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  Future<void> _showNearbyScrapers() async {
    try {
      final response = await http.get(
        Uri.parse('${Passwords.backendUrl}/api/nearby'),
        headers: {
          'Content-Type': 'application/json'
        },  
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        // Handle the data as needed
        print('Nearby vendors: ${data['vendors']}');
      } else {
        print('Failed to load nearby vendors: ${response.body}');
      }
    } catch (error) {
      print('Error fetching nearby vendors: $error');
    }
  }

  Future<void> _searchByZipOrAddress() async {
    // Implement the logic to search by zip or address
    // This could involve showing a dialog to enter the zip/address
    // and then sending a request to your backend
  }

  void _navigateToNotifications(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => NotificationsScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Step 1 of 2',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            GestureDetector(
              onTap: () {
                // Handle Privacy Policy navigation
              },
              child: Text(
                'Privacy Policy',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.blue,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SizedBox(height: 20),
            Center(
              child: SvgPicture.asset(
                'assets/home.svg', // Replace with your SVG path
                height: 350,
                width: 350,
              ),
            ),
            SizedBox(height: 150),
            Text(
              "What's your Location?",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
            Spacer(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: ElevatedButton(
                onPressed: () {
                  _showNearbyScrapers();
                  _navigateToNotifications(context); // Redirect to Notifications
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF17255A),
                  padding: EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  minimumSize: Size(double.infinity, 50), // Full width button
                ),
                child: Text(
                  'Show nearby scrapers',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
            SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: OutlinedButton(
                onPressed: () {
                  _searchByZipOrAddress();
                  _navigateToNotifications(context); // Redirect to Notifications
                },
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: Colors.black),
                  padding: EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  minimumSize: Size(double.infinity, 50), // Full width button
                ),
                child: Text(
                  'Search by Zip or Address',
                  style: TextStyle(fontSize: 16, color: Colors.black),
                ),
              ),
            ),
            SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
