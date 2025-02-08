import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'vendor_adds.dart';
import 'vendor_settings.dart';
import 'vendor_support.dart'; // Add this import statement

class VendorProfileScreen extends StatelessWidget {
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
          child: Text('G', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        ),
        SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Gurshaan Singh', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
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
