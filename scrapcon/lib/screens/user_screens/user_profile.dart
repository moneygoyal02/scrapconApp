import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'user_adds_settings.dart';
import 'user_settings.dart';
import 'user_support.dart'; // Add this import statement
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:provider/provider.dart';
import '../token_provider.dart'; 
import '../passwords.dart';
import 'chatbot_support.dart'; // Add this import statement

class UserProfileScreen extends StatefulWidget {
  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  String? _name;
  String? _email;
  String? _phone;
  String _language = 'English'; // Default language

  @override
  void initState() {
    super.initState();
    _fetchUserProfile();
  }

  Future<void> _fetchUserProfile() async {
    final token = Provider.of<TokenProvider>(context, listen: false).token;

    final url = '${Passwords.backendUrl}/api/users/profile'; // Use the constant
    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token', // Include the token in the headers
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (mounted) { // Check if the widget is still mounted
        setState(() {
          _name = data['name'];
          _email = data['email'];
          _phone = data['phone'];
        });
      }
    } else {
      print('Failed to fetch user profile: ${response.body}');
    }
  }

  void _toggleLanguage() {
    setState(() {
      _language = _language == 'English' ? 'Hindi' : 'English';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProfileSection(),
            SizedBox(height: 20),
            _buildSettingsOptions(context),
          ],
        ),
      ),
    );
  }

Widget _buildProfileSection() {
  return Card(
    elevation: 4,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    color: Colors.white,
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: Colors.grey.shade300,
            child: Text(
              _name != null && _name!.isNotEmpty ? _name![0].toUpperCase() : 'G',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
              ),
            ),
          ),
          SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _name ?? 'Loading...',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              ElevatedButton(
                onPressed: () {
                  if (_name != null && _email != null && _phone != null) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChatbotSupport()
                      ),
                    );
                  } else {
                    print('One or more user details are null');
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF17255A),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                ),
                child: Text('View and Edit Profile'),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}


  Widget _buildSettingsOptions(BuildContext context) {
    return Column(
      children: [
        _buildSettingsTile(
          context: context,
          icon: MdiIcons.package,
          title: 'My Ads',
          subtitle: 'View your active and inactive ads',
          destination: BuyPackagesScreen(),
        ),
        _buildSettingsTile(
          context: context,
          icon: MdiIcons.cog,
          title: 'Settings',
          subtitle: 'Privacy and logout',
          destination: SettingsScreen(),
        ),
        _buildSettingsTile(
          context: context,
          icon: MdiIcons.helpCircleOutline,
          title: 'Help and Support',
          subtitle: 'Help center, Terms and conditions, Privacy policy',
          destination: HelpAndSupportScreen(),
        ),
        _buildSettingsTile(
          context: context,
          icon: MdiIcons.translateVariant,
          title: 'Languages',
          subtitle: 'Toggle between English and Hindi',
          destination: Container(), // No navigation needed
          onTap: _toggleLanguage,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text('Current Language: $_language'),
        ),
      ],
    );
  }

  Widget _buildSettingsTile({
  required BuildContext context,
  required IconData icon,
  required String title,
  required String subtitle,
  required Widget destination,
  VoidCallback? onTap,
}) {
  return ListTile(
    leading: Icon(icon, size: 30, color: const Color(0xFF17255A)),
    title: Text(
      title,
      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
    ),
    subtitle: Text(
      subtitle,
      style: const TextStyle(fontSize: 14, color: Colors.grey),
    ),
    trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
    onTap: onTap ?? () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => destination),
      );
    },
  );
  }
}
