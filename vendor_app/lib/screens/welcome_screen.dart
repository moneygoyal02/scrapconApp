import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'login_screen.dart';
import 'signup_screen.dart';

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF6ECA6B),
      body: Stack(
        children: [
          Center(
            child: SvgPicture.asset(
              'splash_main.svg',
              fit: BoxFit.cover, 
              width: MediaQuery.of(context).size.width, 
              height: MediaQuery.of(context).size.height * 0.9,
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => VendorLoginScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF186F1F),
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 15, horizontal: 100),
                    textStyle: TextStyle(fontSize: 18),
                  ),
                  child: Text('Welcome! Sign In'),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SignupScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Color(0xFF186F1F),
                    padding: EdgeInsets.symmetric(vertical: 15, horizontal: 100),
                    textStyle: TextStyle(fontSize: 18),
                  ),
                  child: Text('Create Account'),
                ),
                SizedBox(height: 30),
              ],
            ),
          ),
        ],
      ),
    );
  }
}