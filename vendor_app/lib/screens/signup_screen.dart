import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:vendor_app/screens/dashboard_screen.dart';
import 'dart:convert';
import 'passwords.dart'; // Import the passwords.dart file
import '../token_provider.dart';
import 'package:provider/provider.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _businessNameController = TextEditingController();
  final TextEditingController _ownerNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _signup() async {
    final url = '${Passwords.backendUrl}/api/vendors/register';
    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'businessName': _businessNameController.text,
        'ownerName': _ownerNameController.text,
        'email': _emailController.text,
        'phone': _phoneController.text,
        'password': _passwordController.text,
      }),
    );

    if (response.statusCode == 201) {
      final data = json.decode(response.body);
      final token = data['token'];
      final vendorId = data['_id'];  // Get the vendor ID from response
      
      // Set both token and vendor ID in the provider
      final tokenProvider = Provider.of<TokenProvider>(context, listen: false);
      tokenProvider.setToken(token);
      tokenProvider.setUserId(vendorId);  // Store the vendor ID

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => VendorDashboardScreen(),
        ),
      );
    } else {
      print('Signup failed: ${response.body}');
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
              'Create your Account',
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
                    controller: _businessNameController,
                    decoration: InputDecoration(labelText: 'Business Name', border: OutlineInputBorder()),
                  ),
                  SizedBox(height: 10),
                  TextField(
                    controller: _ownerNameController,
                    decoration: InputDecoration(labelText: 'Owner Name', border: OutlineInputBorder()),
                  ),
                  SizedBox(height: 10),
                  TextField(
                    controller: _emailController,
                    decoration: InputDecoration(labelText: 'Email Address', border: OutlineInputBorder()),
                  ),
                  SizedBox(height: 10),
                  TextField(
                    controller: _phoneController,
                    decoration: InputDecoration(labelText: 'Mobile Number', border: OutlineInputBorder()),
                  ),
                  SizedBox(height: 10),
                  TextField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(labelText: 'Password', border: OutlineInputBorder()),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _signup,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF186F1F),
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 15, horizontal: 100),
                      textStyle: TextStyle(fontSize: 18),
                    ),
                    child: Text('Create Account'),
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