import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'vendor_adds.dart';
import 'vendor_settings.dart';
import 'vendor_support.dart'; 
import 'package:http/http.dart' as http;
import 'dart:convert'; 
import 'package:provider/provider.dart';
import '../token_provider.dart';
import 'passwords.dart';
import 'vendor_details_screen.dart';

class VendorProfileScreen extends StatefulWidget {
  @override
  _VendorProfileScreenState createState() => _VendorProfileScreenState();
}

class _VendorProfileScreenState extends State<VendorProfileScreen> {
  String? _businessName;
  String? _ownerName;
  String? _email;
  String? _phone;

  @override
  void initState() {
    super.initState();
    _fetchVendorProfile(); 
  }

  Future<void> _fetchVendorProfile() async {
    final token = Provider.of<TokenProvider>(context, listen: false).token;

    final url = '${Passwords.backendUrl}/api/vendors/profile'; 
    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (mounted) { 
        setState(() {
          _businessName = data['businessName']; // Store business name
          _ownerName = data['ownerName']; // Store owner name
          _email = data['email']; // Store email
          _phone = data['phone']; 
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
          child: Text(_ownerName != null && _ownerName!.isNotEmpty ? _ownerName![0].toUpperCase() : 'G', // Update to use _name
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        ),
        SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(_ownerName ?? 'Loading...', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)), // Update to use _name
            SizedBox(height: 5),
            ElevatedButton(
              onPressed: () {
                if (_businessName != null && _ownerName != null && _email != null && _phone != null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => VendorDetailsScreen(
                        businessName: _businessName!,
                        ownerName: _ownerName!,
                        email: _email!,
                        phone: _phone!,
                      ),
                    ),
                  );
                } else {
                  // Handle the case where one or more values are null
                  print('One or more vendor details are null');
                }
              },
              child: Text('View Profile'),
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
