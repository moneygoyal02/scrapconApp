import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';

void main() {
  runApp(ScrapconApp());
}

class ScrapconApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Scrapcon',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: SplashScreen(),
    );
  }
}