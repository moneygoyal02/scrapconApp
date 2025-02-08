import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'token_provider.dart'; 
import 'screens/splash_screen.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => TokenProvider(),
      child: VendorApp(),
    ),
  );
}

class VendorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Vendor App',
      home: SplashScreen(), 
    );
  }
}