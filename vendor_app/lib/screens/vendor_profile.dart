import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'vendor_adds.dart';
import 'vendor_settings.dart';
import 'vendor_support.dart'; // Add this import statement
import 'package:http/http.dart' as http; // Add this import statement
import 'dart:convert'; // Add this import statement
import 'package:provider/provider.dart'; // Add this import statement
import '../token_provider.dart'; // Add this import statement
import 'passwords.dart'; // Add this import statement

class VendorProfileScreen extends StatefulWidget {
  @override
  _VendorProfileScreenState createState() => _VendorProfileScreenState();
}

class _VendorProfileScreenState extends State<VendorProfileScreen> {
  String? _name; // Add this variable to store the vendor name

  @override
  void initState() {
    super.initState();
    _fetchVendorProfile(); // Call the fetch method
  }

  Future<void> _fetchVendorProfile() async { // Add this method
    final token = Provider.of<TokenProvider>(context, listen: false).token;

    final url = '${Passwords.backendUrl}/api/vendors/profile'; // Use the constant
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
          _name = data['ownerName']; // Update the name variable
        });
      }
    } else {
      print('Failed to fetch vendor profile: ${response.body}');
    }
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
    return Row(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundColor: Colors.grey[300],
          child: Text(_name != null && _name!.isNotEmpty ? _name![0].toUpperCase() : 'G', // Update to use _name
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        ),
        SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(_name ?? 'Loading...', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)), // Update to use _name
            SizedBox(height: 5),
            ElevatedButton(
              onPressed: () {},
              child: Text('View and Edit Profile'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF186F1F),
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ],
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
      ],
    );
  }

  Widget _buildSettingsTile({
  required BuildContext context,
  required IconData icon,
  required String title,
  required String subtitle,
  required Widget destination,
}) {
  return ListTile(
    leading: Icon(icon, size: 30, color: const Color(0xFF186F1F)),
    title: Text(
      title,
      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
    ),
    subtitle: Text(
      subtitle,
      style: const TextStyle(fontSize: 14, color: Colors.grey),
    ),
    trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => destination),
      );
    },
  );
  }
}
