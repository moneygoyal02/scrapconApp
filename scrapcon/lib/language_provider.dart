import 'package:flutter/material.dart';

class LanguageProvider with ChangeNotifier {
  String _language = 'English';

  String get language => _language;

  void toggleLanguage() {
    _language = _language == 'English' ? 'Hindi' : 'English';
    notifyListeners();
  }
} 