import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'passwords.dart'; // Import the passwords.dart file
import 'dashboard_screen.dart'; 

class VendorLoginScreen extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  VendorLoginScreen({super.key});

  Future<void> _loginAsVendor(BuildContext context) async {
    final url = '${Passwords.backendUrl}/api/vendors/login'; // Use the constant
    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'email': _emailController.text,
        'password': _passwordController.text,
      }),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final token = data['token'];
      Navigator.pushReplacement(
        // ignore: use_build_context_synchronously
        context,
        MaterialPageRoute(
          builder: (context) => VendorDashboardScreen(), // Redirect to VendorDashboardScreen
        ),
      );
    } else {
      print('Vendor login failed: ${response.body}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 100),
            child: Text(
              'Vendor Sign In',
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: ListView(
                children: [
                  TextField(
                    controller: _emailController,
                    decoration: InputDecoration(labelText: 'Email Address', border: OutlineInputBorder()),
                  ),
                  SizedBox(height: 10),
                  TextField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(labelText: 'Password', border: OutlineInputBorder()),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () => _loginAsVendor(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF17255A),
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 15, horizontal: 100),
                      textStyle: TextStyle(fontSize: 18),
                    ),
                    child: Text('Sign In as Vendor'),
                  ),
                  SizedBox(height: 10),
                  TextButton(
                    onPressed: () {
                      // Add forgot password logic here
                    },
                    child: Text('Forgot Password?'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
} 