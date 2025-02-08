import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Settings',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Color(0xFF17255A),
        foregroundColor: Colors.white,
        elevation: 1,
      ),
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: [
          _buildSettingsTile('Notifications', 'Recommendations & Special communications'),
          _buildSettingsTile('Communication Preferences', ''),
          _buildSettingsTile('Privacy', 'Change Password', withArrow: true),
          Divider(),
          _buildActionTile('Logout'),
          _buildActionTile('Logout from all devices'),
          _buildActionTile('Delete account', isDestructive: true),
        ],
      ),
    );
  }

  Widget _buildSettingsTile(String title, String subtitle, {bool withArrow = false}) {
    return ListTile(
      title: Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      subtitle: subtitle.isNotEmpty ? Text(subtitle, style: TextStyle(fontSize: 14, color: Colors.grey)) : null,
      trailing: withArrow ? Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey) : null,
      onTap: () {},
    );
  }

  Widget _buildActionTile(String title, {bool isDestructive = false}) {
    return ListTile(
      title: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: isDestructive ? Colors.red : Colors.black,
        ),
      ),
      onTap: () {},
    );
  }
}
