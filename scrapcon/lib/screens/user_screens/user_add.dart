import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:scrapcon/screens/passwords.dart';

class UserAddScreen extends StatefulWidget {
  @override
  State<UserAddScreen> createState() => _UserAddScreenState();
}

class _UserAddScreenState extends State<UserAddScreen> {
  File? _image;
  List<dynamic>? _detectedObjects;
  bool _isLoading = false;

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        _detectedObjects = null; // Clear previous results
      } else {
        print('No image selected.');
      }
    });

    if (_image != null) {
      _detectObjects();
    }
  }

  Future<void> _detectObjects() async {
    if (_image == null) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final bytes = await _image!.readAsBytes();
      final base64Image = base64Encode(bytes);

      final response = await http.post(
        Uri.parse(
            '${Passwords.backendUrl}/detect'), // Replace with your backend URL
        body: jsonEncode({'image': base64Image}),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        setState(() {
          _detectedObjects = jsonData['objects'];
          _isLoading = false;
        });
      } else {
        print('Error: ${response.statusCode}');
        setState(() {
          _isLoading = false;
        });
        _showErrorDialog('Error: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
      setState(() {
        _isLoading = false;
      });
      _showErrorDialog('An error occurred: $e');
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Object Detection'),
      ),
      body: Center(
        child: SingleChildScrollView(
          // Added for scrollability
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              if (_image != null) ...[
                Image.file(_image!),
                SizedBox(height: 20),
              ],
              ElevatedButton(
                onPressed: () => _pickImage(ImageSource.gallery),
                child: Text('Pick Image from Gallery'),
              ),
              ElevatedButton(
                onPressed: () => _pickImage(ImageSource.camera),
                child: Text('Pick Image from Camera'),
              ),
              if (_isLoading) ...[
                SizedBox(height: 20),
                CircularProgressIndicator(),
              ],
              if (_detectedObjects != null) ...[
                SizedBox(height: 20),
                Text('Detected Objects:',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(height: 10),
                for (var object in _detectedObjects!)
                  Text(
                      '${object['name']} (Confidence: ${object['confidence']})'),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
