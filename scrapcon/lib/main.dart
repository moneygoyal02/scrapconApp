import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/token_provider.dart';
import 'screens/splash_screen.dart';
void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => TokenProvider(),
      child: ScrapconApp(),
    ),
  );
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