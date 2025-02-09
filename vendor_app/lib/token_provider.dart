import 'package:flutter/material.dart';

class TokenProvider with ChangeNotifier {
  String? _token;
  String? _userId;  // New field for vendor ID

  String? get token => _token;
  String? get userId => _userId; 

  void setToken(String token) {
    _token = token;
    notifyListeners(); 
  }

  void setUserId(String id) {
    _userId = id;
    notifyListeners();
  }

  void clearData() { 
    _token = null;
    _userId = null;
    notifyListeners();
  }
} 