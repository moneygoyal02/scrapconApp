import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:scrapcon/screens/passwords.dart';
import 'package:scrapcon/screens/user_screens/user_activity.dart';

import 'dart:ui';

class LoadingOverlay extends StatelessWidget {
  final bool isLoading;
  final Widget child;

  const LoadingOverlay({
    super.key,
    required this.isLoading,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child, // Main content
        if (isLoading) ...[
          Positioned.fill(
              child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: Opacity(
              opacity: 0.3,
              child: Container(
                alignment: Alignment.center,
                child: const CircularProgressIndicator(),
              ),
            ),
          )),
        ],
      ],
    );
  }
}

class UserAddScreen extends StatefulWidget {
  const UserAddScreen({super.key});

  @override
  State<UserAddScreen> createState() => _UserAddScreenState();
}

class _UserAddScreenState extends State<UserAddScreen> {
  File? _image;
  List<dynamic>? _detectedObjects;
  bool _isLoading = false;

  String scrapCategory = '';
  final _quantityController = TextEditingController();
  final _scheduledDateController = TextEditingController();

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        _detectedObjects = null;
        scrapCategory = '';
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
        body: jsonEncode({
          'image': base64Image,
        }),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        setState(() {
          _detectedObjects = jsonData['objects'];

          _isLoading = false;
          if (_detectedObjects == null || _detectedObjects!.isEmpty) {
            _showErrorDialog('ERROR: ${response.body} ${response.statusCode}');
          } else {
            scrapCategory = _detectedObjects![0]['name'];
          }
        });
      } else {
        setState(() {
          _isLoading = false;
        });
        _showErrorDialog('ERROR: ${response.body} ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      _showErrorDialog('ERROR: $e');
    }
  }

  void _submitPickupRequest() async {
    final response = await http.post(
      Uri.parse(
          '${Passwords.backendUrl}/api/pickups/request'), // Replace with your backend URL
      body: jsonEncode({
        'scrapImage': _image!,
        'category': scrapCategory,
        'quantity': _quantityController.text,
        'scheduledDate': _scheduledDateController.text,
      }),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      // ignore: use_build_context_synchronously
      Navigator.of(context).push(MaterialPageRoute(
          builder: (BuildContext context) => UserActivityScreen()));
    } else {
      setState(() {
        _isLoading = false;
      });
      _showErrorDialog('ERROR: ${response.body} ${response.statusCode}');
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
      body: Center(
        child: SingleChildScrollView(
          // Added for scrollability
          child: LoadingOverlay(
              isLoading: _isLoading,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  if (_image == null)
                    ElevatedButton(
                        style: ButtonStyle(
                          iconSize: WidgetStateProperty.all(30.0),
                        ),
                        onPressed: () => _pickImage(),
                        child: Icon(Icons.add_a_photo))
                  else
                    Image.file(
                      _image!,
                      height: 300.0,
                      width: 200.0,
                    ),
                  SizedBox(height: 10.0),
                  Text('Scrap Category: $scrapCategory',
                      style: TextStyle(
                          fontSize: 10.0, fontWeight: FontWeight.bold)),
                  SizedBox(height: 10.0),
                  Padding(
                      padding: EdgeInsets.all(10.0),
                      child: TextField(
                        controller: _quantityController,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                            labelText: 'Enter Quantity',
                            border: OutlineInputBorder()),
                      )),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: TextField(
                      controller: _scheduledDateController,
                      keyboardType: TextInputType.datetime,
                      decoration: InputDecoration(
                          labelText: 'Enter Due Date',
                          border: OutlineInputBorder()),
                    ),
                  ),
                  SizedBox(height: 20.0),
                  ElevatedButton(
                    onPressed: () {
                      _submitPickupRequest();
                    },
                    child: Text('Submit'),
                  ),
                ],
              )),
        ),
      ),
    );
  }
}
